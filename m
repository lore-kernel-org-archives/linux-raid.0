From: dean gaudet <dean@arctic.org>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance
 hit?
Date: Sat, 29 Dec 2007 09:22:05 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0712290852140.5207@twinlark.arctic.org>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan> <20071219215948.GA7129@cthulhu.home.robinhill.me.uk> <477154C1.6000503@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <477154C1.6000503@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Dec 2007, Bill Davidsen wrote:

> The issue I'm thinking about is hardware sector size, which on modern drives
> may be larger than 512b and therefore entail a read-alter-rewrite (RAR) cycle
> when writing a 512b block.

i'm not sure any shipping SATA disks have larger than 512B sectors yet... 
do you know of any?  (or is this thread about SCSI which i don't pay 
attention to...)

on a brand new WDC WD7500AAKS-00RBA0 with this partition layout:

255 heads, 63 sectors/track, 91201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

so sda1 starts at a non-multiple of 4096 into the disk.

i ran some random seek+write experiments using
<http://arctic.org/~dean/randomio/>, here are the results using 512 byte
and 4096 byte writes (fsync after each write), 8 threads, on sda1:

# ./randomio /dev/sda1 8 1 1 512 10 6
  total |  read:         latency (ms)       |  write:        latency (ms)
   iops |   iops   min    avg    max   sdev |   iops   min    avg    max   sdev
--------+-----------------------------------+----------------------------------
  148.5 |    0.0   inf    nan    0.0    nan |  148.5   0.2   53.7   89.3   19.5
  129.2 |    0.0   inf    nan    0.0    nan |  129.2  37.2   61.9   96.7    9.3
  131.2 |    0.0   inf    nan    0.0    nan |  131.2  40.3   61.0   90.4    9.3
  132.0 |    0.0   inf    nan    0.0    nan |  132.0  39.6   60.6   89.3    9.1
  130.7 |    0.0   inf    nan    0.0    nan |  130.7  39.8   61.3   98.1    8.9
  131.4 |    0.0   inf    nan    0.0    nan |  131.4  40.0   60.8  101.0    9.6
# ./randomio /dev/sda1 8 1 1 4096 10 6
  total |  read:         latency (ms)       |  write:        latency (ms)
   iops |   iops   min    avg    max   sdev |   iops   min    avg    max   sdev
--------+-----------------------------------+----------------------------------
  141.7 |    0.0   inf    nan    0.0    nan |  141.7   0.3   56.3   99.3   21.1
  132.4 |    0.0   inf    nan    0.0    nan |  132.4  43.3   60.4   91.8    8.5
  131.6 |    0.0   inf    nan    0.0    nan |  131.6  41.4   60.9  111.0    9.6
  131.8 |    0.0   inf    nan    0.0    nan |  131.8  41.4   60.7   85.3    8.6
  130.6 |    0.0   inf    nan    0.0    nan |  130.6  41.7   61.3   95.0    9.4
  131.4 |    0.0   inf    nan    0.0    nan |  131.4  42.2   60.8   90.5    8.4


i think the anomalous results in the first 10s samples are perhaps the drive
coming out of a standby state.

and here are the results aligned using the sda raw device itself:

# ./randomio /dev/sda 8 1 1 512 10 6
  total |  read:         latency (ms)       |  write:        latency (ms)
   iops |   iops   min    avg    max   sdev |   iops   min    avg    max   sdev
--------+-----------------------------------+----------------------------------
  147.3 |    0.0   inf    nan    0.0    nan |  147.3   0.3   54.1   93.7   20.1
  132.4 |    0.0   inf    nan    0.0    nan |  132.4  37.4   60.6   91.8    9.2
  132.5 |    0.0   inf    nan    0.0    nan |  132.5  37.7   60.3   93.7    9.3
  131.8 |    0.0   inf    nan    0.0    nan |  131.8  39.4   60.7   92.7    9.0
  133.9 |    0.0   inf    nan    0.0    nan |  133.9  41.7   59.8   90.7    8.5
  130.2 |    0.0   inf    nan    0.0    nan |  130.2  40.8   61.5   88.6    8.9
# ./randomio /dev/sda 8 1 1 4096 10 6
  total |  read:         latency (ms)       |  write:        latency (ms)
   iops |   iops   min    avg    max   sdev |   iops   min    avg    max   sdev
--------+-----------------------------------+----------------------------------
  145.4 |    0.0   inf    nan    0.0    nan |  145.4   0.3   54.9   94.0   20.1
  130.3 |    0.0   inf    nan    0.0    nan |  130.3  36.0   61.4   92.7    9.6
  130.6 |    0.0   inf    nan    0.0    nan |  130.6  38.2   61.2   96.7    9.2
  132.1 |    0.0   inf    nan    0.0    nan |  132.1  39.0   60.5   93.5    9.2
  131.8 |    0.0   inf    nan    0.0    nan |  131.8  43.1   60.8   93.8    9.1
  129.0 |    0.0   inf    nan    0.0    nan |  129.0  40.2   62.0   96.4    8.8

it looks pretty much the same to me...

-dean
