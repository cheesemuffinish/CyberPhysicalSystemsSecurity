Project0 Introduction to Python & Packet Dissection


Task 1
On blackboard you will find a sample PCAP file. Using the scapy library you will need to output two files:
dest.txt, source.txt. dest.txt will contain a list (one per line) of all the destination IP addresses found
within the PCAP. Source.txt will contain the source IP addresses. Make sure that duplicate addresses
are not duplicated in the output files. For example, if the address 10.4.2.24 is the destination in two
packets, it should only appear once in the dest.txt file.

to run this command: sudo python3 task1.py
the following output files in the diectory related to this task: pcap_source.txt and pcap_dest.txt


Task 2
Task 2 is the same as Task 1, however now this task must be done in real time. Again using scapy, you
will need to listen on the default internet interface (typically eth0) and write each new destination and
source IP to files (dest.txt, source.txt). 

to run this command: sudo python3 task2.py
the following output files in the diectory related to this task: task2_source.txt and task2_dest.txt

