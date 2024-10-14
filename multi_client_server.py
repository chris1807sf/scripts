#!/usr/bin/python3

import socket
#import os
from _thread import *
import sys

serverSocket = socket.socket()
host = '127.0.0.1'
port = 12345

try:
    serverSocket.bind((host, port))
except socket.error as e:
    print(f'Error when doing ServerSocket.bind {e}')
    serverSocket.close()
    sys.exit()
    
print('Waitiing for a Connection..')
serverSocket.listen(5)


def threaded_client(connection,CLIENTHOST):
    connection.send(str.encode('Welcome ' +  CLIENTHOST+ ' on Server ' + host + '\n'))
    while True:
        data = connection.recv(2048)
        data = data.decode('utf-8')
        # reply = 'Server Says: ' + data.decode('utf-8')
        # if not data: break
        #connection.sendall(str.encode(reply))
        # bestand file2 is tav logging
        if data:
            reply = 'received OK: ' + str(data)
            connection.sendall(str.encode(reply))
        else:
            break
    connection.close()

while True:
    Client, address = serverSocket.accept()
    print('Connected from: ' + address[0] + ':' + str(address[1]))
    wie=address[0] + ':' + str(address[1])
    start_new_thread(threaded_client, (Client,wie))
    # ThreadCount += 1
    # print('(while True: Thread Number: ' + str(ThreadCount))
serverSocket.close()
