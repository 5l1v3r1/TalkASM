%macro  bind 2
; %1 - Port Number (Hex)
; %2 - Socket FD
	; -- Here we are building the sockaddr struct --
	; Push 0.0.0.0 as host address
	xor edx, edx
	push dword edx
	push word 0xaaff
	push word AF_INET
	mov ecx, esp
	add esp, 4 * 2
	; push addrlen
	push BYTE 16
	; push sockaddr
	push ecx
	; Finnaly, push the socket fd from ESI
	push %2
	; Move the pointer to bind() args into ECX and make the API call
	mov ecx, esp
	add esp, 4 * 3
	socketcall SYS_BIND
%endmacro

%macro	listen 1
	; %1 - Socket FD
	; The size of the queue allowed
	push dword 10
	; The socket fd
	push %1
	; Move the pointer to listen() args into ECX and make the API call
	mov ecx, esp
	add esp, 4 * 2
	socketcall SYS_LISTEN
%endmacro

%macro	accept 3
	; %1 - addrlen
	; %2 - addr
	; %3 - Socket FD
	; push addrlen (0)
	push %1
	; push addr (0 - NULL)
	push %2
	; push sockfd
	push %3
	; Move the pointer to accept() args into ECX and make the API call
	mov ecx, esp
	add esp, 4 * 3
	socketcall SYS_ACCEPT
%endmacro

%macro	sockaddr_in	2
	; %1 - Port
	; %2 - in_addr (socket address)
	push 0
	push %2
	push %1
	push AF_INET
	mov ecx, esp
	add esp, 4 * 4
%endmacro

%macro	socketcall 1
	; %1 - Subcall
	mov eax, SYS_socketcall
	mov ebx, %1
	int 0x80
%endmacro
