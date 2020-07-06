"""
Simple script to write cuda devices to file
"""
import logging
import torch

NUM_CUDA_DEVICES = torch.cuda.device_count()
logging.basicConfig(filename='test.log', level=logging.DEBUG)
# logging.debug('This message should go to the log file')
logging.info('Number of Cuda Devices: %s', NUM_CUDA_DEVICES)
for i in range(NUM_CUDA_DEVICES):
    logging.info('Device number %s is: %s', i, torch.cuda.get_device_name(i))
# logging.warning('And this, too')
