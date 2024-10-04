#!/usr/bin/python3

import socket			 

server = socket.socket()		 
print ("Socket successfully created")

port = 12345			

server.bind(('', port)) #ip-address given as empty		 
print ("socket binded to %s" %(port)) 

# put the socket into listening mode 
server.listen(1)	 
print ("socket is listening")		 

while True: 
  # Establish connection with client. 
  conn, addr = s.accept()	 
  print ('Got connection from', addr )
  datagram = conn.recv(1024)
  if datagram:
    tokens = datagram.strip().split()
    if tokens[0].lower() == "post":
      flist.append(tokens[1])
      conn.send(len(tokens) + "")
    else if tokens[0].lower() == "get":
      conn.send(tokens.popleft())
    else:
      conn.send("-1")
    conn.close()
