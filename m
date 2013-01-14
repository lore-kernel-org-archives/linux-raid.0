From: Tommy Apel Hansen <tommyapeldk@gmail.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 22:38:34 +0100
Message-ID: <1358199514.2950.3.camel@workstation-home>
References: <201212212357.19292.thomas@fjellstrom.ca>
	 <1358121900.3019.1.camel@workstation-home>
	 <201301140158.27135.thomas@fjellstrom.ca>
	 <201301141122.15322.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301141122.15322.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: stan@hardwarefreak.com, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Test of my raw SAS2 7K2 disks without bcache
*****************************************************************************
*****************************************************************************
~ # mdadm -C /dev/md0 -l 6 -c 512 -n 7 --assume-clean --run --force /dev/dm-[0,1,2,3,4,5,7]
*****************************************************************************
~ # mdadm -D /dev/md0
/dev/md0:
     Raid Level : raid6
     Array Size : 9767564800 (9315.08 GiB 10001.99 GB)
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 7
  Total Devices : 7
         Layout : left-symmetric
     Chunk Size : 512K

    Number   Major   Minor   RaidDevice State
       0     253        0        0      active sync   /dev/dm-0
       1     253        1        1      active sync   /dev/dm-1
       2     253        2        2      active sync   /dev/dm-2
       3     253        3        3      active sync   /dev/dm-3
       4     253        4        4      active sync   /dev/dm-4
       5     253        5        5      active sync   /dev/dm-5
       6     253        7        6      active sync   /dev/dm-7
*****************************************************************************
~ # echo 32768 > /sys/block/md0/md/stripe_cache_size
*****************************************************************************
~ # blockdev --getra /dev/dm-0
2048
~ # iozone -I -a -s 1g -y 8192 -q 8192 -i 0 -i 1 -i 2 -I -f /dev/md0
        O_DIRECT feature enabled
        Auto Mode
        File size set to 1048576 KB
        Using Minimum Record Size 8192 KB
        Using Maximum Record Size 8192 KB
        O_DIRECT feature enabled
        Command line used: iozone -I -a -s 1g -y 8192 -q 8192 -i 0 -i 1 -i 2 -I -f /dev/md0
        Output is in Kbytes/sec
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
                                                            random  random
              KB  reclen   write rewrite    read    reread    read   write
         1048576    8192  193370  193976   297343   314465  311949  197962                                                          

iozone test complete.
*****************************************************************************
*****************************************************************************
This test should be of more intrest for you as those are the normal blocksizes you'll see hit the disks
*****************************************************************************
~ # iozone -I -a -s 25m -y 4 -q 64 -i 0 -i 1 -i 2 -I -f /dev/md0
        O_DIRECT feature enabled
        Auto Mode
        File size set to 25600 KB
        Using Minimum Record Size 4 KB
        Using Maximum Record Size 64 KB
        O_DIRECT feature enabled
        Command line used: iozone -I -a -s 25m -y 4 -q 64 -i 0 -i 1 -i 2 -I -f /dev/md0
        Output is in Kbytes/sec
        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
                                                            random  random                                  
              KB  reclen   write rewrite    read    reread    read   write
           25600       4     864     931   149704   197296  202074    8378                                                          
           25600       8    1713    1717   204531   254967  245363   15468                                                          
           25600      16    3522    3389   270464   266586  237274   19848                                                          
           25600      32    5824    5887   342603   422281  324350   36111                                                          
           25600      64   10555   10304   382500   367605  318845   56680                                                          

iozone test complete.
*****************************************************************************
One more thing you should look for when you do this type of test is that you are properly
maxing out you cpu while doing this, my tests were done on a Dual Xeon E5-2609 @ 2.40GHz,
that's a total o 8 physical cores, while doing this singlethread iozone test only 1 core was in use
and it was maxed out at 12.5% iowait according to iostat, if you run iozone in a multithreaded setup
you result will get higher, I was noting just about 48MB/s to every drive in the array while doing
the tests above which is about 100MB/s from the max of those drives.
*****************************************************************************
MULTITHREAD TEST BELOW USING XFS
*****************************************************************************
~ # mkfs.xfs -f /dev/md0
data     =                       bsize=4096   blocks=2441887744, imaxpct=5
         =                       sunit=128    swidth=640 blks
*****************************************************************************
~ # mount -t xfs -o noatime,inode64 /dev/md0 /mnt
*****************************************************************************
mnt # iozone -t 20 -s 512m -i 0 -i 1 -i 2 -I -r 8m
Children see throughput for 20 initial writers  =  431515.35 KB/sec
Children see throughput for 20 rewriters        =  349231.38 KB/sec
Children see throughput for 20 readers          =  647558.30 KB/sec
Children see throughput for 20 re-readers       =  643240.44 KB/sec
Children see throughput for 20 random readers   =  642147.36 KB/sec
Children see throughput for 20 random writers   =  325886.66 KB/sec
iozone test complete.
*****************************************************************************
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00   21.01   78.61    0.00    0.38
*****************************************************************************
This test brought the drives up around 100MB/s but I ran out of cpu cycles,
Now replicate my tests on you system as see what numbers you can come up with,
considering your drives are not enterprise sas drives you numbers might be some 
10% lower or so.
*****************************************************************************


