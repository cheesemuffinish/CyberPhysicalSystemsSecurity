from pymodbus.client.sync import ModbusTcpClient as ModbusClient
import time
client = ModbusClient('192.168.1.14', port=502)
client.connect()
UNIT = 0x1
while True:
	rr=client.read_discrete_inputs(0,2,unit=UNIT)
	box_at_sensorA = not rr.bits[0]
	box_at_sensorB = not rr.bits[1]
	if box_at_sensorA:
		client.write_coil(0, True,unit=UNIT)
	if box_at_sensorB:
		client.write_coil(0, False,unit=UNIT)
	time.sleep(.1)