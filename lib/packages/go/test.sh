cat >main.go <<EOF
package main
import "fmt"
func main() {
  fmt.Println("1")
}
EOF
[[ $(go run main.go) == "1" ]]
