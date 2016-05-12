package main

import (
	"bufio"
	"bytes"
	"fmt"
	"../../fmic"
	"math/rand"
	"os"
//	"regexp"
	"runtime"
	"time"
)

//-----------------------------------------------------------------------------
func main() {
	rand.Seed(time.Now().UnixNano())
	runtime.GOMAXPROCS(runtime.NumCPU())
	//re := regexp.MustCompile(`SOURCE_1="[^"]+`)
	genome_index := os.Args[1]
	rea1 := os.Args[2]
	rea2 := os.Args[3]
	fmt.Println("loading index...")
	idx := fmic.LoadCompressedIndex(genome_index)
	genome_id := make(map[string]int)
	for i := 0; i < len(idx.GENOME_ID); i++ {
		genome_id[idx.GENOME_ID[i]] = i
	}

	f1, err := os.Open(rea1)
	check_for_error(err)
	r1 := bufio.NewReader(f1)
	f2, err := os.Open(rea2)
	check_for_error(err)
	r2 := bufio.NewReader(f2)
	i := 0
	tp, fp, fn := 0, 0, 0
	var read1, read2 []byte
	var cur_genome int
	var header string

	gid := make(map[string]int)
	for i := 0; i < len(idx.GENOME_ID); i++ {
		gid[idx.GENOME_ID[i]] = i
	}

	//fmt.Println(gid)

	fmt.Println("querying reads...")
	for {
		line1, err := r1.ReadBytes('\n')
		line2, err := r2.ReadBytes('\n')
		//fmt.Println(string(line))
		if err != nil {
			break
		}
		if len(line1) > 1 && len(line2) > 1 {
			if i%2 == 0 {
				items := bytes.SplitN(line1[1:], []byte{' '}, 2)
				header = string(bytes.TrimSpace(items[0]))
				//fmt.Println("1", header)
				
				//fmt.Println("2", gid[header])
				//cur_genome = gid[re.FindString(header)[10:]]
				cur_genome = gid[header]
				//fmt.Println(cur_genome)
			}

			if i%2 == 1 {
				read1 = bytes.TrimSpace(line1)
				read2 = bytes.TrimSpace(line2)
				//fmt.Println("r1: "+string(read1))			
				//fmt.Println("r2: "+string(read2))
				seqs := idx.FindGenomeR(read1, reverse_complement(read2), 1500, 100)
				//fmt.Println(seqs)
				if _, ok := seqs[cur_genome]; ok {
					tp++
					fp += len(seqs) - 1
				} else {
					fn++
					fmt.Println("False Negative", cur_genome, seqs)
				}
			}
		}
		i++
	}
	fmt.Println(tp, fp, fn, float64(tp)/float64(tp+fp), float64(tp)/float64(tp+fn))
}

func reverse_complement(s []byte) []byte {
	rs := make([]byte, len(s))
	for i := 0; i < len(s); i++ {
		if s[i] == 'A' {
			rs[len(s)-i-1] = 'T'
		} else if s[i] == 'T' {
			rs[len(s)-i-1] = 'A'
		} else if s[i] == 'C' {
			rs[len(s)-i-1] = 'G'
		} else if s[i] == 'G' {
			rs[len(s)-i-1] = 'C'
		} else {
			rs[len(s)-i-1] = s[i]
		}
	}
	return rs
}

func check_for_error(e error) {
	if e != nil {
		panic(e)
	}
}
