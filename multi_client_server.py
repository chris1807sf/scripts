#!/usr/bin/python3

import socket
import os
from _thread import *

ServerSocket = socket.socket()
host = '192.168.50.40'
port = 65432
ThreadCount = 0     # niet meer gebruikt
try:
    ServerSocket.bind((host, port))
except socket.error as e:
    ServerSocket.close()
    # print(str(e))

print('Waitiing for a Connection..')
ServerSocket.listen(5)


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
               file = open("file2","a+")
               file.write(str(data))
               file.write('\n')
               file.close()
               reply = 'ontvangen: ' + str(data)
               connection.sendall(str.encode(reply))

    connection.close()

while True:
    Client, address = ServerSocket.accept()
    print('Connected from: ' + address[0] + ':' + str(address[1]))
    wie=address[0] + ':' + str(address[1])
    start_new_thread(threaded_client, (Client,wie))
    # ThreadCount += 1
    # print('(while True: Thread Number: ' + str(ThreadCount))
ServerSocket.close()
