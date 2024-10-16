#!/usr/bin/python3

import socket
#import os
from _thread import *
import sys

serverSocket = socket.socket()
host = '127.0.0.1'
port = 12345

threadcount = 0;

try:
    serverSocket.bind((host, port))
except socket.error as e:
    print(f'Error when doing ServerSocket.bind {e}')
    serverSocket.close()
    sys.exit()
    
print('Waitiing for a Connection..')
serverSocket.listen(5)


def threaded_client(connection,CLIENTHOST):
    global threadcount
    threadcount+=1
    print(f"threadcount: {threadcount}")

    connection.send(str.encode('Welcome ' +  CLIENTHOST+ ' on Server ' + host + '\n'))
    while True:
        data = connection.recv(2048)
        data = data.decode('utf-8').rstrip()
        # reply = 'Server Says: ' + data.decode('utf-8')
        # if not data: break
        #connection.sendall(str.encode(reply))
        # bestand file2 is tav logging
        if data:
            print(f'threadcount: {threadcount}, data: +++{data}+++')
            if data=="close":
                reply = 'bye'
                print(f"threadcount: {threadcount}: reply=bye")
                threadcount-=1
                print(f"updated threadcount: {threadcount}")
            else:
                reply = 'received OK: ' + str(data)
            connection.send(str.encode(reply))
        else:
            break
    connection.close()

while True:
    Client, address = serverSocket.accept()
    print('Connected from: ' + address[0] + ':' + str(address[1]))
    wie=address[0] + ':' + str(address[1])
    start_new_thread(threaded_client, (Client,wie))
    if threadcount>=3:
        print(f'threadcount: {threadcount} >=3, Will break')
        break
    
print(f'will -do serverSocket.close()')
serverSocket.close(
