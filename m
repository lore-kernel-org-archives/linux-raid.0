From: Poonam Dalya <poonamsbox@yahoo.com>
Subject: Linux RAID setup
Date: Sat, 9 Oct 2004 05:21:06 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041009122106.650.qmail@web60410.mail.yahoo.com>
Reply-To: poonamsbox@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids


 Hello Sir,

         I want to Setup RAID 0 on my standalone
system. I have windows and linux both on my system. I
went through many documents and and also through the
book 'Managing RAID on Linux ' by Derek Vadala. I
tried to setup RAID with the following steps. I
downloaded mdadm from your site. I have listed down
the steps i did with their outputs. Please if you
could go through it and let me know where the problem
lies, it would be of great help.
 
 1. I was able to include the RAID modules with the
 modprobe command. The mdstat file was as below.
 
 bash2-2.05b# cat /proc/mdstat
 Personalities : [raid0] [raid1]
 read_ahead not set
 unused devices: <none>
 
 ---------------------------------------------------
 
 2. I partitioned the disk using fdisk and the
 pratition table looked like below
 
 Disk /dev/hda: 40.0 GB, 40020664320 bytes
 255 heads, 63 sectors/track, 4865 cylinders
 Units = cylinders of 16065 * 512 = 8225280 bytes
  
    Device Boot    Start       End    Blocks   Id 
 System
 /dev/hda1   *         1      1275  10241406    c 
 Win95 FAT32 (LBA)
 /dev/hda2          1276      2550  10241437+   f 
 Win95 Ext'd (LBA)
 /dev/hda3          2551      2626    610470   82 
 Linux swap
 /dev/hda4          2627      4865  17984767+  fd 
 Linux raid autodetect
 /dev/hda5          1276      2550  10241406   fd 
 Linux raid autodetect
  
 ------------------------------------------------
 
 3. Then I worrked with the following command.
       I got the following error.
 
 bash2-2.05b# mdadm --create /dev/md0 --level=0
 --chunk=128 --raid-disks=2 /dev/hda5 /dev/hda4
 mdadm: /dev/hda5 appears to contain an ext2fs file
 system size=10241404K  mtime=Sat Oct  9 17:06:24 2004
 Continue creating array? y
 mdadm: ADD_NEW_DISK for /dev/hda5 failed: Invalid
 argument
 
 --------------------------------------------------

 4. When i again tried with that command, it showed
 the following error.
 
 bash2-2.05b# mdadm --create /dev/md0 --level=0
 --chunk=128 --raid-disks=2 /dev/hda5 /dev/hda4
 mdadm: /dev/hda5 appears to contain an ext2fs file
 system size=10241404K  mtime=Sat Oct  9 17:06:24 2004
 Continue creating array? y
 mdadm: SET_ARRAY_INFO failed for /dev/md0: File
 exists
 
 ---------------------------------------------------

 5. the mdstat file was same 
 
 bash2-2.05b#  cat /proc/mdstat
 Personalities : [raid0] [raid1]
 read_ahead not set
 md0 : inactive
 unused devices: <none>
 
        Please if you could solve my problem, it
 would be of very great help for me. I have a deadline
as sunday and today is saturday. So, sir please do
 reply.
         Thank you.
 
 With Regards,
 Poonam
India.
 
 
 		
 
 



		

