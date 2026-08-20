import serial
import serial.tools.list_ports
import matplotlib.pyplot as plt
import numpy as np

# Configuration
def find_serial_port():
    ports = serial.tools.list_ports.comports()
    for port in ports:
        # You can match by description, hwid, or manufacturer
        if "usbserial" in port.device.lower() or "arduino" in port.description.lower():
            return port.device
    return None

SERIAL_PORT = find_serial_port()
if not SERIAL_PORT:
    print("Device not found. Please check your connection.")
    exit()
    
BAUD_RATE = 115200 
NUM_SAMPLES = 1024

def get_user_config(): 
    print("--- Logic Analyzer Configuration ---")
    while True:
        try:
            channel = int(input("Select Trigger Channel (0-7): "))
            if 0 <= channel <= 7:
                break
            print("Invalid channel. Must be between 0 and 7.")
        except ValueError:
            print("Please enter a valid number.")
            
    print("Modes: 0=Rising, 1=Falling, 2=High, 3=Low")
    while True:
        try:
            mode = int(input("Select Trigger Mode (0-3): "))
            if 0 <= mode <= 3:
                break
            print("Invalid mode. Must be between 0 and 3.")
        except ValueError:
            print("Please enter a valid number.")
            
    config_byte = (mode & 0x03) | ((channel & 0x07) << 2)
    return bytes([config_byte])

def read_data(config_byte): 
    print(f"Connecting to {SERIAL_PORT}...") 
    try: 
        with serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=5) as ser: 
            ser.write(config_byte) 
            print("Configuration sent. Waiting for trigger...")
            raw_data = ser.read(NUM_SAMPLES)
        
            if len(raw_data) < NUM_SAMPLES:
                print("Timeout: Did not receive all samples.")
                return None
            
        print("Data received! Plotting...")
        return np.frombuffer(raw_data, dtype=np.uint8)
    except serial.SerialException as e:
        print(f"Error opening serial port: {e}")
        return None


def plot_data(data): 
    plt.figure(figsize=(12, 6)) 
    for i in range(8): 
        channel_data = (data >> i) & 1 
        plt.step(range(NUM_SAMPLES), channel_data + (i * 1.5), where='mid', label=f'Channel {i}')
    plt.title('FPGA Logic Analyzer Capture')
    plt.xlabel('Sample Number')
    plt.ylabel('Channel')
    plt.yticks([])
    plt.legend(loc='right')
    plt.grid(True, alpha=0.3)
    plt.show()

if __name__ == "__main__": 
    config = get_user_config() 
    data = read_data(config) 
    if data is not None: 
        plot_data(data)