From: AndyLiebman@aol.com
Subject: Please Confirm I'm Solving Problem Correctly!
Date: Wed, 3 Mar 2004 22:37:55 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <17.434a3a38.2d77fe93@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have ten disks in two RAID 5 Linux arrays with Video and Audio files stored 
on them for video editing.  A couple of hours ago I was viewing a 90 minute 
video sequence (on a Windows machine that's networked to my Linux box) and all 
of a sudden, about 45 minutes into viewing, an image got corrupted; there were 
strange blocks of color in random places in the image and my video editing 
program came to a halt. When I moved backwards in the editing program timeline 
the images were okay for a while (I'm assuming because good data was still in 
the sizable RAM on the Linux box). But when I went back to the beginning of the 
video sequence and forward again, ALL of the data was corrupted with these 
random blocks of color. 

I immediately shut down the Windows machine and checked the RAID status on my 
Linux box. When I ran 'cat /proc/mdstat' it showed that all drives on both 
arrays were ACTIVE and that none were missing. 

I rebooted the Linux computer (maybe a mistake?) and now one of my arrays 
didn't start (the one that had the material I was looking at and that got 
corrupted)

[root@localhost avidserver]# mdadm -Av /dev/md6 
--uuid=57f26496:25520b96:41757b62:f83fcb7b /dev/sd*
mdadm: looking for devices for /dev/md6
mdadm: /dev/sd is not a block device.
mdadm: /dev/sd has wrong uuid.
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sda1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sdb1 is identified as a member of /dev/md6, slot 4.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdc1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdd1 has wrong uuid.
mdadm: no RAID superblock on /dev/sde
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sde1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sdf1 is identified as a member of /dev/md6, slot 0.
mdadm: no RAID superblock on /dev/sdg
mdadm: /dev/sdg has wrong uuid.
mdadm: /dev/sdg1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: /dev/sdh1 is identified as a member of /dev/md6, slot 1.
mdadm: no RAID superblock on /dev/sdi
mdadm: /dev/sdi has wrong uuid.
mdadm: /dev/sdi1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdj
mdadm: /dev/sdj has wrong uuid.
mdadm: /dev/sdj1 is identified as a member of /dev/md6, slot 2.
mdadm: added /dev/sdh1 to /dev/md6 as 1
mdadm: added /dev/sdj1 to /dev/md6 as 2
mdadm: no uptodate device for slot 3 of /dev/md6
mdadm: added /dev/sdb1 to /dev/md6 as 4
mdadm: added /dev/sdf1 to /dev/md6 as 0
mdadm: /dev/md6 assembled from 4 drives - need all 5 to start it (use --run 
to insist)

I ran mdadm -E /dev/sdXX on each of the drives on my system to confirm which 
ones belonged to which array and which was the problem drive. I found one 
drive,sdc1, which didn't have a superblock and by process of elimination it 
belonged to md6. 

mdadm -E /dev/sdc1
mdadm: No super block found on /dev/sdc1 (Expected magic a92b4efc, got 
00000000)
[root@localhost avidserver]#

TO CORRECT THIS PROBLEM I am assuming that I have to do the following: 
mdadm /dev/md6 --fail /dev/sdc1
mdadm /dev/md6 --remove /dev/sdc1
mdadm /dev/md6 --add /dev/sdc1

Would it be advisable to do steps 1 and 2 first (fail/remove), then assemble 
the array and confirm that all the data is intact before adding the failed 
drive back in? SHOULD my data be intact without the 5th drive (I know that's the 
point of RAID5, but why was I seeing corrupt data all of a sudden when just 
seconds before it had been fine throughout the array? Even if one drive went 
bad, shouldn't the data integrity have been maintained? Or do I have to get the 
bad drive out of the picture first? 

If I do assemble the array with one drive failed, and the data is still 
corrupted, what should I do then? 

Finally, I have a couple of questions about why this occurred: 

1)  Why didn't sdc1 just fail? Why was it still in the array after the 
corruption occurred, and why is it still in the array after rebooting and not marked 
automatically as failed (thus allowing the array to restart with 4 drives). 

2)  Could the cause of the problem be related to this comment I found in my 
kernel logs: 


Mar  3 20:41:43 localhost kernel: RAID5 conf printout:
Mar  3 20:41:43 localhost kernel:  --- rd:5 wd:5 fd:0
Mar  3 20:41:43 localhost kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 
dev:scsi/host3/bus0/target0/lun0/part1
Mar  3 20:41:43 localhost kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 
dev:scsi/host4/bus0/target0/lun0/part1
Mar  3 20:41:43 localhost kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 
dev:scsi/host1/bus0/target0/lun0/part1
Mar  3 20:41:43 localhost kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 
dev:scsi/host5/bus0/target0/lun0/part1
Mar  3 20:41:43 localhost kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 
dev:scsi/host2/bus0/target1/lun0/part1
Mar  3 20:41:44 localhost kernel: XFS: SB read failed


I appreciate your help. The data on this array is very important to me. It 
will take me two weeks to restore it if that becomes necessary. 

Regards, 
Andy Liebman


P.S.  I am thinking about designing a program to "almost automatically" run 
mdadm -E /dev/sdXX on all drives, figure out which device id's go together by 
uuid, and determine by process of elimination which drive needs to be 
failed/removed and (or just) added -- and then just do what needs to be done, perhaps 
running a diagnosis on the removed drive to determine if the drive needs to be 
replaced, warning the user if that's the case or adding the drive back if it's 
not a problem. Is there another such program around ( I don't want to 
reinvent the wheel). Would such a "semi automatic recovery program" be useful? Or 
would it be more dangerous than anything else? I want to find a way to make it 
possible for folks to be able to use Linux software RAID without having to know 
all the deep innards of how it works. 
