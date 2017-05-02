From: Bernd <berndman80@gmx.de>
Subject: Fwd: Please Help! Degraded Raid6
Date: Tue, 02 May 2017 23:11:10 +0200
Message-ID: <C7A7AD68-1ABB-4186-8228-BC89B95E4571@gmx.de>
References: <C89BFE2F-0C7A-47CA-A970-EA90C0FF053A@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C89BFE2F-0C7A-47CA-A970-EA90C0FF053A@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




-------- Ursprüngliche Nachricht --------
Von: Bernd <berndman80@gmx.de>
Gesendet: 2. Mai 2017 22:52:38 MESZ
An: linux-raid@vger.kernel.org
CC: neilb@suse.de
Betreff: Please Help! Degraded Raid6 

Hello, 
I have a problem with my degraded raid6 and hope you can help me. Please excuse if my english is not so well...
A few days ago i wanted to boot my server and while booting the electricity fuse dropped out. And my raid 6 was in the state active degraded not started. It was degraded with 7 of 8 devices before the crash. I was able to boot with the 7 devices and had all my data. Now when booting all devices are spares and when ich do mdadm --run --force /dev/md0 the state is active degraded not started. Im not able to run the raid and can't touch my data. Add or readd the removed device is denied. System removed it a time ago without my help...think i have to recreate with one missing device. And think a have lost my superblocks...Please help. Dont know what to do. Don't want loose all my data! ...thank you for your help  Bernd


This is what i tried:

berndman@berndman:~$ sudo mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
  Used Dev Size : 1953509376 (1863.01 GiB 2000.39 GB)
   Raid Devices : 8
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Fri Mar 31 14:56:50 2017
          State : active, degraded, Not Started 
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 4096K

           Name : berndman:0  (local to host berndman)
           UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
         Events : 1686

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       49        1      active sync   /dev/sdd1
       8       8        1        2      active sync   /
dev/sda1
       3       8       65        3      active sync   /dev/sde1
       4       8      129        4      active sync   /dev/sdi1
       5       8       33        5      active sync   /dev/sdc1
       6       8       17        6      active sync   /dev/sdb1
       7       0        0        7      removed



berndman@berndman:~$ sudo cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : inactive sdi1[4] sda1[8] sdd1[1] sde1[3] sdf1[0] sdc1[5] sdb1[6]
      13674587752 blocks super 1.2
                                                                                                                                                                                                                                                                               
unused devices: <none>            


                                                                                                                                                                                                                                        
berndman@berndman:~$ sudo mdadm --run /dev/md0                                                                                                                                                                                                                              
mdadm: failed to run array /dev/md0: Input/output error 




                                                                                                                                                                                                                       
berndman@berndman:~$ sudo mdadm --examine /dev/sd[a-z]                                                                                                                                                                                                
/dev/sda:                                                                                                                                                                                                                                                                      
   MBR Magic : aa55                                                                                                                                                                                                                                                            
Partition[0] :   3907027120 sectors at         2048 (type fd)                                                                                                                                                                                                                  
/dev/sdb:                                                                                                                                                                                                                                                                      
   MBR Magic : aa55                                                                                                                                                                                                                                                            
Partition[0] :   3907027120 sectors at         2048 (type fd)                                                                                                                                                                                                                  
/dev/sdc:                                                                                                                                                                                                                                                                      
   MBR Magic : aa55                                                                                                                                                                                                                                                            
Partition[0] :   3907027120 sectors at         2048 (type fd)                                                                                                                                                                                                                  
/dev/sdd:                                                                                                                                                                                                                                                                      
   MBR Magic : aa55                                                                                                                                                                                                                                                            
Partition[0] :   3907027120 sectors at         2048 (type fd)                                                                                                                                                                                                                  
/dev/sde:                                                                                                                                                                                                                                                                      
   MBR Magic : aa55                                                                                                                                                                                                                                                            
Partition[0] :   3907027120 sectors at         2048 (type fd)                                                                                                                                                                                                                  
/dev/sdf:                                                                                                                                                                                                                                                                      
   MBR Magic : aa55                                                                                                                                                                                                                                                            
Partition[0] :   3907027120 sectors at         2048 (type fd)                                                                                                                                                                                                                  
/dev/sdg:                                                                                                                                                                                                                                                                      
   MBR Magic : aa55                                                                                                                                                                                                                                                            
Partition[0] :     73969664 sectors at         2048 (type 83)                                                                                                                                                                                                                  
Partition[1] :      4190210 sectors at     73973758 (type 05)                                                                                                                                                                                                                  
/dev/sdh:                                                                                                                                                                                                                                                                      
          Magic : a92b4efc                                                                                                                                                                                                                                                     
        Version : 1.2
    Feature Map : 0x2
     Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8
           Name : berndman:0  (local to host berndman)
  Creation Time : Wed Dec 19 20:39:11 2012
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 0 sectors
          State : clean
    Device UUID : 0be2a583:659bbe6e:7d8c93dc:6592505b

    Update Time : Fri Jul 10 22:32:34 2015
       Checksum : b60eeb71 - correct
         Events : 607

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 7
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdi:
   MBR Magic : aa55
Partition[0] :   3907027120 sectors at         2048 (type fd)



berndman@berndman:~$ sudo mdadm --assemble --run --force /dev/md0 /dev/sd[abcdefi]1
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has no superblock - assembly aborted
berndman@berndman:~$
