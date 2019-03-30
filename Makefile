all: clean server
clean:
	rm -rf _build
server:
	dune build server.exe --profile release
