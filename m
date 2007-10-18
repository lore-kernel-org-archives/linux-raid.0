From: nefilim <thenephilim13@yahoo.com>
Subject: slow raid5 performance
Date: Thu, 18 Oct 2007 15:21:41 -0700 (PDT)
Message-ID: <13284909.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi

Pretty new to software raid, I have the following setup in a file server:

/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Oct 10 11:05:46 2007
     Raid Level : raid5
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Oct 18 15:02:16 2007
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 9dcbd480:c5ca0550:ca45cdab:f7c9f29d
         Events : 0.9

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1

3 x 500GB WD RE2 hard drives
AMD Athlon XP 2400 (2.0Ghz), 1GB RAM
/dev/sd[ab] are connected to Sil 3112 controller on PCI bus
/dev/sd[cde] are connected to Sil 3114 controller on PCI bus

Transferring large media files from /dev/sdb to /dev/md0 I see the following
with iostat:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.01    0.00   55.56   40.40    0.00    3.03

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda               0.00         0.00         0.00          0          0
sdb             261.62        31.09         0.00         30          0
sdc             148.48         0.15        16.40          0         16
sdd             102.02         0.41        16.14          0         15
sde             113.13         0.29        16.18          0         16
md0            8263.64         0.00        32.28          0         31
 
which is pretty much what I see with hdparm etc. 32MB/s seems pretty slow
for drives that can easily do 50MB/s each. Read performance is better around
85MB/s (although I expected somewhat higher). So it doesn't seem that PCI
bus is limiting factor here (127MB/s theoretical throughput.. 100MB/s real
world?) quite yet... I see a lot of time being spent in the kernel.. and a
significant iowait time. The CPU is pretty old but where exactly is the
bottleneck? 

Any thoughts, insights or recommendations welcome!

Cheers
Peter
-- 
View this message in context: http://www.nabble.com/slow-raid5-performance-tf4650085.html#a13284909
Sent from the linux-raid mailing list archive at Nabble.com.

