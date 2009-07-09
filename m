From: Dan Williams <dan.j.williams@intel.com>
Subject: RE: Question on RAID-5 using ADMA
Date: Wed, 08 Jul 2009 17:55:56 -0700
Message-ID: <1247100956.18114.5.camel@dwillia2-linux.ch.intel.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
	 <e9c3a7c20907081548r7e7a476difd1970b749987c13@mail.gmail.com>
	 <AC5E1C3367E37D44970B81A6ADD1DA2C07B087FE@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087FE@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2009-07-08 at 15:55 -0700, Tirumala Reddy Marri wrote:
> I enabled the test. But I don't know how to run it. I have my own version of XOR test which verify the XOR operation. In general regular RADI-5 creation and creating file system works fine. Then I was doing some destructive tests to verify the stability that is where I am running into this issue.
> Thanks,
> Marri

It can be a bit tricky to enable here are the steps:
1/ Disable other clients from consuming dma engines, i.e. set
CONFIG_NET_DMA=n and CONFIG_ASYNC_TX_DMA=n

2/ Make sure that your driver loads before the dmatest module loads,
otherwise it won't find any channels to test:
modprobe your_driver
modrpobe dmatest

Note: If you build your driver and dmatest into the kernel dmatest will
use late_initcall to initialize after your driver.

3/ Verify that the xor-threads are running.  You should see something
like the following in top:

top - 00:02:31 up 2 min,  1 user,  load average: 6.52, 2.87, 1.09
Tasks:  53 total,   8 running,  45 sleeping,   0 stopped,   0 zombie
Cpu(s):  4.7%us, 93.8%sy,  0.0%ni,  0.5%id,  0.0%wa,  0.1%hi,  0.9%si,  0.0%st
Mem:    807700k total,    31052k used,   776648k free,        0k buffers
Swap:        0k total,        0k used,        0k free,    17224k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                                                                       
  788 root      30  10     0    0    0 R 14.6  0.0   0:19.47 dma0chan0-xor0                                                                                                                
  790 root      30  10     0    0    0 R 14.6  0.0   0:19.48 dma1chan0-xor0                                                                                                                
  792 root      30  10     0    0    0 R 14.6  0.0   0:19.47 dma2chan0-xor0                                                                                                                
  793 root      30  10     0    0    0 R 14.6  0.0   0:19.49 dma2chan0-pq0                                                                                                                 
  787 root      30  10     0    0    0 R 12.8  0.0   0:19.55 dma0chan0-copy0                                                                                                               
  789 root      30  10     0    0    0 R 12.8  0.0   0:19.57 dma1chan0-copy0                                                                                                               
  791 root      30  10     0    0    0 R 12.8  0.0   0:19.55 dma2chan0-copy0

4/ Errors will be logged to the console, and you will get summary of
tests passing/failing when you remove the dmatest module.

--
Dan

