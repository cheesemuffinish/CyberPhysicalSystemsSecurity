#! /usr/bin/env python3

from scapy.all import *
import time

def extract_ips(packet):
	
	# loop through all of the packets
	for pkt in packet:		
		
		#find all of the IPs in the packets
		if IP in pkt:
		
			#add the IPs to either a source or dest list
			source_ip = pkt[IP].src
			dest_ip = pkt[IP].dst
			
			#only add the IP to the list if its not contained
			if str(source_ip) not in source_set:
				source_set.append(str(source_ip))
			if str(dest_ip) not in dest_set:
				dest_set.append(str(dest_ip))
#lists to hold to source and dest IPs			 
source_set = []		
dest_set = []	

#command to sniff a provided pcap file and extract IP addresses
sniff(offline = "sample.pcap", prn=extract_ips)

#File IO commands to write lists to files
with open("pcap_source.txt", "w") as file:
	for item in source_set:
		file.write(item + '\n')
		
with open("pcap_dest.txt", "w") as file:
	for item in dest_set:
		file.write(item + '\n')
		
