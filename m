From: Graeme Gemmill <graeme@gemmill.name>
Subject: mdadm problem
Date: Sun, 21 Mar 2010 18:26:02 +0000
Message-ID: <4BA664BA.20505@gemmill.name>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090704020105090201020707"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090704020105090201020707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I would be very grateful for advice on removing all traces of a previous 
mdadm attempt to create a 3-disk RAID 5 setup so that I can try again 
(or give some advice to solve the problem).
Mandriva 2010.0, mdadm v3.0.2
I had apparently created the RAID 5 set using /dev/sda, /dev/sdc, 
/dev/sdd. I could write to it locally but not from the PC that has the 
data I want to protect, but couldn't stop it(some message to the effect 
that the devise was busy? Can't remember).
I therefore re-installed Mandriva 2010.0, used fdisk to create a single 
partition on each of the three disks but was unable to create the array. 
I was very surprised to find that /proc/mdstat appeared to have survived 
the re-install although mdadm appears not to recognise elements of the 
array (See attachment). Furthermore the existence of /dev/sda1 as a 
RAID-type partition appears to cause elements of the Mandriva Control 
Centre to exit abnormally (the program blkid -o udev -p /dev/sda doesn't 
work).
Some RAID expertise would be very welcome!
TIA
Graeme Gemmill

--------------090704020105090201020707
Content-Type: text/plain;
 name="mdadmOutput"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadmOutput"

# fdisk /dev/sda
Command (m for help): p
Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x699d5c03                     
   Device Boot      Start         End      Blocks   Id  System
Command (m for help): n
Command action         
   e   extended                                                                                                                                              
   p   primary partition (1-4)                                                                                                                               
p                                                                                                                                                            
Partition number (1-4): 1                                                                                                                                    
First cylinder (1-60801, default 1):                                                                                                                         
Using default value 1                                                                                                                                        
Last cylinder, +cylinders or +size{K,M,G} (1-60801, default 60801):                                                                                          
Using default value 60801                                                                                                                                    
                                                                                                                                                             
Command (m for help): t                                                                                                                                      
Selected partition 1                                                                                                                                         
Hex code (type L to list codes): fd                                                                                                                          
Changed system type of partition 1 to fd (Linux raid autodetect)                                                                                             
                                                                                                                                                             
Command (m for help): p                                                                                                                                      
                                                                                                                                                             
Disk /dev/sda: 500.1 GB, 500107862016 bytes                                                                                                                  
255 heads, 63 sectors/track, 60801 cylinders                                                                                                                 
Units = cylinders of 16065 * 512 = 8225280 bytes                                                                                                             
Disk identifier: 0x699d5c03                                                                                                                                  
                                                                                                                                                             
   Device Boot      Start         End      Blocks   Id  System                                                                                               
/dev/sda1               1       60801   488384001   fd  Linux raid autodetect                                                                                
                                                                                                                                                             
Command (m for help): w                                                                                                                                      
The partition table has been altered!                                                                                                                        
                                                                                                                                                             
Calling ioctl() to re-read partition table.                                                                                                                  
Syncing disks.                                                                                                                                               
[root@Bach ~]# fdisk /dev/sdc
> SNIP
   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       60801   488384001   fd  Linux raid autodetect
>SNIP                           
[root@Bach ~]# fdisk /dev/sdd
>SNIP
   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       60801   488384001   fd  Linux raid autodetect
                           
[root@Bach ~]# mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sda1 /dev/sdc1 /dev/sdd1
mdadm: layout defaults to left-symmetric                                                                 
mdadm: chunk size defaults to 64K                                                                        
mdadm: layout defaults to left-symmetric                                                                 
mdadm: super0.90 cannot open /dev/sda1: Device or resource busy                                          
mdadm: layout defaults to left-symmetric                                                                 
mdadm: super1.x cannot open /dev/sda1: Device or resource busy                                           
mdadm: ddf: Cannot use /dev/sda1: Device or resource busy                                                
mdadm: Cannot use /dev/sda1: It is busy                                                                  
mdadm: device /dev/sda1 not suitable for any style of array                                              
[root@Bach ~]# cat /etc/mtab
/dev/sdb2 / ext3 rw 0 0     
none /proc proc rw 0 0      
none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
gvfs-fuse-daemon /home/graeme/.gvfs fuse.gvfs-fuse-daemon rw,nosuid,nodev,user=graeme 0 0
[root@Bach ~]# cat /etc/fstab
# Entry for /dev/sdb2 :      
UUID=f0c2de4f-422a-44bb-88d2-194c55dc127b / ext3 defaults 1 1
none /proc proc defaults 0 0                                 
[root@Bach ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] 
md127 : active raid5 sda[0] sdd[2] sdc[1]
      976772992 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>
[root@Bach ~]# mdadm --stop /dev/sda
mdadm: /dev/sda does not appear to be an md device
[root@Bach ~]# mdadm --stop /dev/sdc
mdadm: /dev/sdc does not appear to be an md device
[root@Bach ~]# mdadm --zero-superblock /dev/sda1
mdadm: Couldn't open /dev/sda1 for write - not zeroing
[root@Bach ~]# mdadm --zero-superblock /dev/sda
mdadm: Couldn't open /dev/sda for write - not zeroing
[root@Bach ~]# mdadm -Q /dev/sda
/dev/sda: is not an md array
/dev/sda: device 0 in 3 device active raid5 /dev/md127.  Use mdadm --examine for more detail.
[root@Bach ~]# mdadm --examine /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cc526422:3aae7bc9:d6030a07:261540d2
  Creation Time : Wed Mar 17 15:53:39 2010
     Raid Level : raid5
  Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
     Array Size : 976772992 (931.52 GiB 1000.22 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 127

    Update Time : Sun Mar 21 07:10:38 2010
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 60a86cd3 - correct
         Events : 50

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        0        0      active sync   /dev/sda

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
[root@Bach ~]#

--------------090704020105090201020707--
