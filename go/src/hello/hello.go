package hello

//#include <stdlib.h>
import "C"
import (
	"fmt"
	"time"
)

// export Reverse
func Reverse(s *C.char) *C.char {
	C.srand(C.uint(time.Now().Nanosecond()))
	fmt.Println(C.rand())
	r := []rune(C.GoString(s))
	for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
		r[i], r[j] = r[j], r[i]
	}
	return C.CString(string(r))
}

func GoReverse(s string) string {
	return C.GoString(Reverse(C.CString(s)))
}
