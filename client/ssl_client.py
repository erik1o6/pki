#!/usr/bin/python
import socket
import ssl

# client
if __name__ == '__main__':

    HOST = '127.0.0.1'
    PORT = 1234

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setblocking(1);
    sock.connect((HOST, PORT))

    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.verify_mode = ssl.CERT_REQUIRED
    context.load_verify_locations('ca.pem')
    context.load_cert_chain(certfile="client.pem", keyfile="client-key.pem")

    if ssl.HAS_SNI:
        secure_sock = context.wrap_socket(sock, server_side=False, server_hostname=HOST)
    else:
        secure_sock = context.wrap_socket(sock, server_side=False)

    cert = secure_sock.getpeercert()
    print (cert)

    # verify server
    if not cert or ('commonName', 'test') not in cert['subject'][5]: raise Exception("ERROR")

    secure_sock.write('hello')
    print (secure_sock.read(1024))

    secure_sock.close()
    sock.close()