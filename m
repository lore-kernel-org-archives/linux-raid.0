From: Steve Vialle <vevets3@gmail.com>
Subject: [New Here] Need some help recovering failed Raid-5, Cant seem to re-create the same size array.
Date: Sun, 15 Jan 2012 17:33:04 +1300
Message-ID: <1979195.K3igYoDXoV@local.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First off, Hi all.
First time posting to _any_ mailing list so feel free to correct any 
misdemeanors on my part :-)

My situation is this:
I decided to convert my operational raid-5 (5x2Tb devices + 1 spare) into a 
raid-6 using all 6 devices.

During the reshape, devices 0 & 2 failed due to a dodgy power cable :-(

*REBOOT* && replace cable.

I attempted to assemble & restart the reshape with the 2 devices plugged back 
in:
$>mdadm --assemble /dev/md3 /dev/sdg1 /dev/sdf1 /dev/sdi1 /dev/sde1 /dev/sdh1 
/dev/sdj1 --backup-file=/root/backup-md3

Got:
mdadm: device 6 in /dev/md3 has wrong state in superblock, but /dev/sdg1 seems 
ok                          
mdadm: accepting backup with timestamp 1326496445 for array with timestamp 
1326504140                             
mdadm: restoring critical section                                                                                 
mdadm: /dev/md3 assembled from 3 drives,  1 rebuilding and 2 spares - not 
enough to start the array.

$> mdadm -S /dev/md3

I then set up a dm sandbox with 
dmsetup create sdg1 --table "0 3907027120 snapshot /dev/sdg1 /dev/loop0 N 1" 
etc. for each drive (I am under the impression this will keep me from 
buggering things up further, seems to work as advertised)

Attempted to asemble the array again with --force:
$>mdadm --assemble /dev/md3 /dev/mapper/sdg1 /dev/mapper/sdf1 /dev/mapper/sdi1 
/dev/mapper/sde1 /dev/mapper/sdh1 /dev/mapper/sdj1 --backup-file=/root/backup-
md3 --force

Got:
mdadm: clearing FAULTY flag for device 0 in /dev/md3 for /dev/mapper/sdg1                                         
mdadm: Marking array /dev/md3 as 'clean'                                                                          
mdadm: accepting backup with timestamp 1326496445 for array with timestamp 
1326504140                             
mdadm: restoring critical section                                                                                 
mdadm: /dev/md3 assembled from 3 drives,  1 rebuilding and 2 spares - not 
enough to start the array.

Looks like my 2 (Presumably ok) devices in slot 0&2 have been marked as spare?
As I have been unable to find a way to reverse this, I tried recreating the 
array with the original raid-5 order & layout: 
<https://raid.wiki.kernel.org/articles/r/a/i/RAID_Recovery_d376.html>

System log snippet from last array start prior to interrupted reshape:
                   
md/raid:md3: device sdh1 operational as raid disk 4              
md/raid:md3: device sdi1 operational as raid disk 2              
md/raid:md3: device sdg1 operational as raid disk 0              
md/raid:md3: device sdf1 operational as raid disk 1              
md/raid:md3: device sde1 operational as raid disk 3              
md/raid:md3: allocated 5320kB                                    
md/raid:md3: raid level 5 active with 5 out of 5 devices, algorithm 2                                                                                                              
md3: detected capacity change from 0 to 8001586462720

This gives the device order as sdg1, sdf1, sdi1, sde1, sdh1
I know the chunk size == 128K
The layout == left-symmetric
And the metadata == 1.2

So:

$>mdadm -S /dev/md3
$>mdadm --create --metadata=1.2 --level=5 --chunk=128K --layout=left-symmetric 
--raid-devices=5 --assume-clean /dev/md3 /dev/mapper/sdg1 /dev/mapper/sdf1 
/dev/mapper/sdi1 /dev/mapper/sde1 /dev/mapper/sdh1

The array starts as expected, but fsck can't find a superblock.
Testdisk finds a superblock:
Partition  Start        End                    Size in sectors
ext4         32  0  1  1953512351 1 4 15628098560

But the filesystem appears larger than the array:
Disk /dev/md3 - 8001 GB / 7452 GiB - CHS 1953512192 2 4

Examining logs shows:
Original raid5 > md3: detected capacity change from 0 to 8001586462720
New raid5 >      md3: detected capacity change from 0 to 8001585938432
i.e. 524,288 smaller.

Comparing the output of $>mdadm -E [any disk in array]:
Failed raid-6:

/dev/mapper/sde1:                                                                                                 
          Magic : a92b4efc                                                                                        
        Version : 1.2                                                                                             
    Feature Map : 0x4                                                                                             
     Array UUID : 06a7fdac:3b560176:9fc05905:34f97822                                                             
           Name : Damnation:3                                                                                     
  Creation Time : Sun Jun 12 14:38:45 2011                                                                        
     Raid Level : raid6                                                                                           
   Raid Devices : 6                                                                                               
                                                                                                                  
 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)                                                             
     Array Size : 15628098560 (7452.06 GiB 8001.59 GB)                                                            
  Used Dev Size : 3907024640 (1863.01 GiB 2000.40 GB)                                                             
    Data Offset : 2048 sectors                                                                                    
   Super Offset : 8 sectors                                                                                       
          State : clean                                                                                           
    Device UUID : 4fcba3d0:3219c5d9:e847abe8:c8c93e03                                                             
                                                                                                                  
  Reshape pos'n : 232030208 (221.28 GiB 237.60 GB)                                                                
     New Layout : left-symmetric                                                                                  
                                                                                                                  
    Update Time : Sat Jan 14 14:22:20 2012                                                                        
       Checksum : f214fb99 - correct                                                                              
         Events : 193807                                                                                          
                                                                                                                  
         Layout : left-symmetric-6                                                                                
     Chunk Size : 128K                                                                                            
                                                                                                                  
   Device Role : Active device 3                                                                                  
   Array State : .A.AAA ('A' == active, '.' == missing)

New raid-5 (Should be the same as above but raid5 / left-symmetric?):

/dev/mapper/sde1:                                                                                                 
          Magic : a92b4efc                                                                                        
        Version : 1.2                                                                                             
    Feature Map : 0x0                                                                                             
     Array UUID : e6e1fa47:fa23ea0c:4cabf95d:1aa9c21d                                                             
           Name : (none):3  (local to host (none))                                                                
  Creation Time : Sun Jan 15 06:03:21 2012                                                                        
     Raid Level : raid5                                                                                           
   Raid Devices : 5                                                                                               
                                                                                                                  
 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)                                                             
     Array Size : 15628097536 (7452.06 GiB 8001.59 GB)                                                            
  Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)                                                             
    Data Offset : 2048 sectors                                                                                    
   Super Offset : 8 sectors                                                                                       
          State : clean                                                                                           
    Device UUID : 7d4fe0db:fbd649f7:d62d9df8:39dafe20                                                             
                                                                                                                  
    Update Time : Sun Jan 15 06:03:21 2012                                                                        
       Checksum : 7823d35e - correct                                                                              
         Events : 0                                                                                               
                                                                                                                  
         Layout : left-symmetric                                                                                  
     Chunk Size : 128K                                                                                            
                                                                                                                  
   Device Role : Active device 3                                                                                  
   Array State : AAAAA ('A' == active, '.' == missing) 


Note Avail Dev Size is the same, but Array Size 15628097536 < 15628098560 by 
1024 and Used Dev Size 3907024384 < 3907024640 by 256

I have tried many combinations of level, layout & stripe size (Though I am 
certain I had it right the first time) to no avail.

Any idea where those 256b are going?
I see little hope of recovering the filesystem if the array size != original 
layout.

Any help MUCH appreciated, I have scoured the WWW and been to #linux-raid on 
freenode.
From what I can tell, recreating the array has worked for others in a similar 
situation... But they all managed to create something _identical_ to the 
original array.

Thank you for taking the time to read this.
Steve.
<steve_v@orcon.net.nz>
<vevets3@gmail.com>






