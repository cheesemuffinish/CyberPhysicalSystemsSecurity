import scapy
from scapy.arch.windows import show_interfaces
from scapy.all import sniff
from scapy.all import *
from scapy.contrib.modbus import *
# from scipy.stats import sem, t
# from scipy import mean
# import scipy

class NormalcyProfiling():
	def __init__(self,required_confidence=.95,server_ip='192.168.1.30'):
		print("i am here")
		self.last_packet_time=None
		self.last_packet=None
		self.num_packets=0
		self.mean_time_between_packets=0
		self.std_time_between_packets=0
		self.sum_sq=0
		self.required_confidence=required_confidence
		self.stop_capture=False
		self.server_ip=server_ip
	def get_average(self,prev_avg,x,n):
		print("im in this code 111!")
		return ((prev_avg*n+x)/(n+1))
	def get_variance(self,current_avg,n,x):
		self.sum_sq+=(x-current_avg)**2
		var=self.sum_sq/n
		std=math.sqrt(var)
		print("im in this code 222!")
		return std
	def process_packet(self,packet):
		if not packet.haslayer(IP) or not packet.haslayer(TCP):
			print("im in this code! 333")
			return
		ip_layer=packet[IP]
		tcp_layer=packet[TCP]
		if ip_layer.dst!=self.server_ip or tcp_layer.dport!=502:
			return
		packet_time=tcp_layer.time
		if self.last_packet==None:
			self.last_packet=packet
			self.last_packet_time=packet_time
			return
		average=self.get_average(self.mean_time_between_packets,(packet_time-self.last_packet_time),self.num_packets)

		self.num_packets+=1
		variance=self.get_variance(current_avg=average,n=self.num_packets,x=(packet_time-self.last_packet_time))
		self.std_time_between_packets=variance
		self.mean_time_between_packets=average
		self.last_packet_time=packet_time
		return
	def stop_filter(self,packet):
		if self.num_packets>=1000:
			print(self.mean_time_between_packets)
			self.stop_capture=True
		return self.stop_capture

class IDS():
	def __init__(self,required_confidence=.95,server_ip='192.168.1.30',normal_mean=.0166):
		self.last_packet_time=None
		self.last_packet=None
		self.num_packets=0
		self.mean_time_between_packets=0
		self.normal_mean=normal_mean
		self.server_ip=server_ip
	def get_average(self,prev_avg,x,n):
		return ((prev_avg*n+x)/(n+1))
		print("im in this code!")
	def process_packet(self,packet):
		print("im in this code 0!")
		if not packet.haslayer(IP) or not packet.haslayer(TCP):
			print("im in this code 1!")
			return
		ip_layer=packet[IP]
		tcp_layer=packet[TCP]
		if ip_layer.dst!=self.server_ip or tcp_layer.dport!=502:
			print("im in this code 2!")
			return
		packet_time=tcp_layer.time
		if self.last_packet==None:
			self.last_packet=packet
			self.last_packet_time=packet_time
			print("im in this code 3!")
			return
		average=self.get_average(self.mean_time_between_packets,(packet_time-self.last_packet_time),self.num_packets)
		if self.num_packets%100==0:
			print(average)
		self.num_packets+=1
		self.mean_time_between_packets=average
		self.last_packet_time=packet_time
		if self.num_packets>=100 and average<=.01:
			print('anomaly_found')
			exit()
		return
n=IDS()
sniff(iface="VirtualBox Host-Only Ethernet Adapter",prn=n.process_packet)