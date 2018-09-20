package main

import (
	"io/ioutil"
	"log"
	"net/http"
)

func testfile(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/plain")

	filecontent, err := ioutil.ReadFile("testfile")
	if err != nil {
		w.WriteHeader(500)
		return
	}

	_, err = w.Write(filecontent)
	if err != nil {
		w.WriteHeader(400)
		return
	}
}

func logRequest(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%s %s %s\n", r.RemoteAddr, r.Method, r.URL)
		handler.ServeHTTP(w, r)
	})
}

func main() {
	http.HandleFunc("/testfile", testfile) // set router
	log.Print("Listening on :9090")
	err := http.ListenAndServe(":9090", logRequest(http.DefaultServeMux)) // set listen port
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
