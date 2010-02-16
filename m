From: Michael <michael@rw23.de>
Subject: =?UTF-8?Q?Slow=28=3F=29=20raid=35=20to=20raid=36=20reshape=20speed?=
Date: Tue, 16 Feb 2010 12:50:08 +0100
Message-ID: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

iam reshaping my 4-drive raid5 to a 5-drive raid6, but the speed is a
little slow.

md2 : active raid6 sdc3[0] sdg3[4] sdf3[3] sda3[2] sdd3[1]
      2898182016 blocks super 0.91 level 6, 64k chunk, algorithm 18 [5/4]
[UUUU_]
      [======>..............]  reshape = 34.2% (330530816/966060672)
finish=2897.5min speed=3655K/sec

i know it is a expensive process, but my system near-to-idle, so there may
be something wrong.
with top, i can see there is no noticable cpu load caused by the md2_raid6
process or any other.
with iotop, i can see mdadm reading and writing a little data once a
secound, but not continuous.

i think the kernel's raid io is not visible at iotop or iam wrong?

i have moved the --backup-file from my usb drive to a internal ide hard
drive and gained 800k/sec more speed.
~3000-4000k/sec are not so bad that the reshaping takes forever, but could
be faster, right?

i have tried playing around with sync_speed_min and sync_speed_max without
any result.
setting the stripe_cache to 8192 or something did not show a real
performance gain.

is my speed bad, good, normal? any ideas how to "tune" it a bit?

now some infos:
Linux raw 2.6.32-ARCH #1 SMP PREEMPT

raid reshape process continued like this (from dmesg):
raid5: reshape will continue                                              
                                                                     
raid5: device sdc3 operational as raid disk 0                             
                                                                     
raid5: device sdf3 operational as raid disk 3                             
                                                                     
raid5: device sda3 operational as raid disk 2                             
                                                                     
raid5: device sdd3 operational as raid disk 1                             
                                                                     
raid5: allocated 5259kB for md2                                           
                                                                     
0: w=1 pa=18 pr=5 m=2 a=2 r=5 op1=0 op2=0                                 
                                                                     
4: w=1 pa=18 pr=5 m=2 a=2 r=5 op1=1 op2=0                                 
                                                                     
3: w=2 pa=18 pr=5 m=2 a=2 r=5 op1=0 op2=0                                 
                                                                     
2: w=3 pa=18 pr=5 m=2 a=2 r=5 op1=0 op2=0                                 
                                                                     
1: w=4 pa=18 pr=5 m=2 a=2 r=5 op1=0 op2=0                                 
                                                                     
raid5: raid level 6 set md2 active with 4 out of 5 devices, algorithm 2   
                                                                     
RAID5 conf printout:                                                      
                                                                     
 --- rd:5 wd:4                                                            
                                                                     
 disk 0, o:1, dev:sdc3                                                    
                                                                     
 disk 1, o:1, dev:sdd3                                                    
                                                                     
 disk 2, o:1, dev:sda3                                                    
                                                                     
 disk 3, o:1, dev:sdf3                                                    
                                                                     
 disk 4, o:1, dev:sdg3                                                    
                                                                     
...ok start reshape thread                                                
                                                                     
md2: detected capacity change from 0 to 2967738384384                     
                                                                     
md: md2 switched to read-write mode.                                      
                                                                     
md: reshape of RAID array md2                                             
                                                                     
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.                        
                                                                     
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for reshape.                                                     
md: using 128k window, over a total of 966060672 blocks.                  
                                                                     
 md2: unknown partition table                


[root@raw S02-complete-]mdadm --detail /dev/md2
/dev/md2:
        Version : 0.91
  Creation Time : Thu Feb 11 16:01:12 2010
     Raid Level : raid6
     Array Size : 2898182016 (2763.92 GiB 2967.74 GB)
  Used Dev Size : 966060672 (921.31 GiB 989.25 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Feb 16 12:45:13 2010
          State : clean, degraded, recovering
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 64K

 Reshape Status : 34% complete
     New Layout : left-symmetric

           UUID : 9815a2c6:c83a9a53:2a8015ce:9d8e5e8c (local to host raw)
         Events : 0.375234

    Number   Major   Minor   RaidDevice State
       0       8       35        0      active sync   /dev/sdc3
       1       8       51        1      active sync   /dev/sdd3
       2       8        3        2      active sync   /dev/sda3
       3       8       83        3      active sync   /dev/sdf3
       4       8       99        4      spare rebuilding   /dev/sdg3


thanks, michael.
