From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: RAID6 rebuild oddity
Date: Fri, 24 Mar 2017 15:44:53 +0800
Message-ID: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm in the process of setting up a new little array. 8 x 6TB drives in a 
RAID6. While I have the luxury of a long burn in period I've been 
beating it up and have seen some odd performance anomalies.

I have one in front of me now, so I thought I'd lay out the data and see 
if anyone has any ideas as to what might be going on.

Here's the current state. I did this by removing and adding /dev/sdb 
without a write intent bitmap to deliberately cause a rebuild.

/dev/md0:
         Version : 1.2
   Creation Time : Wed Mar 22 14:01:41 2017
      Raid Level : raid6
      Array Size : 35162348160 (33533.43 GiB 36006.24 GB)
   Used Dev Size : 5860391360 (5588.90 GiB 6001.04 GB)
    Raid Devices : 8
   Total Devices : 8
     Persistence : Superblock is persistent

     Update Time : Fri Mar 24 15:34:28 2017
           State : clean, degraded, recovering
  Active Devices : 7
Working Devices : 8
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

  Rebuild Status : 0% complete

            Name : test:0  (local to host test)
            UUID : 93a09ba7:f159e9f5:7c478f16:6ca8858e
          Events : 394

     Number   Major   Minor   RaidDevice State
        8       8       16        0      spare rebuilding   /dev/sdb
        1       8       32        1      active sync   /dev/sdc
        2       8       48        2      active sync   /dev/sdd
        3       8       64        3      active sync   /dev/sde
        4       8       80        4      active sync   /dev/sdf
        5       8       96        5      active sync   /dev/sdg
        6       8      128        6      active sync   /dev/sdi
        7       8      144        7      active sync   /dev/sdj


Here's the iostat output (hope it doesn't wrap).
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.05    0.00   10.42    7.85    0.00   81.68

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     1.60    0.00    1.40     0.00     8.80 
12.57     0.02   12.86    0.00   12.86  12.86   1.80
sdb               0.00 18835.60    0.00  657.80     0.00 90082.40 
273.89     3.72    4.71    0.00    4.71   0.85  55.80
sdc           20685.80     0.00  244.20    0.00 87659.20     0.00 
717.93     8.65   34.10   34.10    0.00   2.15  52.40
sdd           20664.60     0.00  244.60    0.00 87652.00     0.00 
716.70     8.72   34.28   34.28    0.00   2.19  53.60
sde           20647.80     0.00  240.40    0.00 87556.80     0.00 
728.43     9.13   36.54   36.54    0.00   2.30  55.40
sdf           20622.40     0.00  242.40    0.00 87556.80     0.00 
722.42     8.73   34.60   34.60    0.00   2.20  53.40
sdg           20596.00     0.00  239.20    0.00 87556.80     0.00 
732.08     9.32   37.54   37.54    0.00   2.37  56.60
sdh               0.00     1.60    0.00    1.40     0.00     8.80 
12.57     0.01    7.14    0.00    7.14   7.14   1.00
sdi           20575.80     0.00  238.20    0.00 86999.20     0.00 
730.47     8.53   34.06   34.06    0.00   2.20  52.40
sdj           22860.80     0.00  475.80    0.00 101773.60     0.00 
427.80   245.09  513.25  513.25    0.00   2.10 100.00
md1               0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    2.00     0.00     8.00 
8.00     0.00    0.00    0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00     0.00 
0.00     0.00    0.00    0.00    0.00   0.00   0.00

The long and short is /dev/sdj is the last drive in the array, and is 
getting hit with a completely different read pattern to the other 
drives, causing it to bottleneck the rebuild process.

I *thought* the rebuild process was "read one stripe, calculate the 
missing bit and write it out to the drive being rebuilt".

I've seen this behaviour now a number of times, but this is the first 
time I've been able to reliably reproduce it. Of course it takes about 
20 hours to complete the rebuild, so it's a slow diagnostic process.

I've set the stripe cache size to 8192. Didn't make a dent.

The bottleneck drive seems to change depending on the load. I've seen it 
happen simply dd'ing the array to /dev/null where the transfer rate 
slows to < 150MB/s. Stop and restart the transfer and it's back up to 
500MB/s.

I've reproduced this on kernel 4.6.4 & 4.10.5, so I'm not sure what is 
going on at the moment. There is obviously a sub-optimal read pattern 
getting fed to sdj. I had a look at it with blocktrace, but went cross 
eyed trying to figure out what was going on.

The drives are all on individual lanes on a SAS controller, are set with 
the deadline scheduler and I can get about 160MB/s sustained from all 
drives simultaneously using dd.

It's not important, but I thought since I was seeing it and I have a 
month or so of extra time with this array before it needs to do useful 
work, I'd ask.

Regards,
Brad
