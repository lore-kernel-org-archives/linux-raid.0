From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: A few mdadm questions
Date: Sat, 13 Nov 2004 21:03:47 -0500
Message-ID: <200411140203.iAE23rN08652@www.watkins-home.com>
References: <4196A85B.5060106@osiel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4196A85B.5060106@osiel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Robert Osiel' <bob@osiel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Your array had 5 disks, not counting any spares.
You need to start the array with at least 4 of the five disks, spares don't
help when starting an array.

I don't know why it thinks your disk (hdi1) is a spare.  But, that may
explain how it was removed from the array.  Unless Neil has some magic
incantations, I think you are out of luck.

If Neil has no ideas, you could try to start the array with the drive that
failed (hdk1), but that will cause corruption of any stripes that have
changed since the drive was removed from the array.  So, save this option as
a last resort.  Of course, if hdk1 has failed hard, you will not be able to
use it.

Last resort!!!  Corruption will occur!
mdadm --assemble --force /dev/md0 /dev/hde1 /dev/hdk1 /dev/hdm1 /dev/hdo1

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robert Osiel
Sent: Saturday, November 13, 2004 7:36 PM
To: linux-raid@vger.kernel.org
Subject: Re: A few mdadm questions

Guy/Neil:

Thanks a lot for the help.
Sorry that I didn't include all of the info in my last message, but this 
box is off the network right now and doesn't even have a floppy or 
monitor, so I had to do a little work to get the info out.

I tried to start the array with the 3 good disks and the 1 spare, but I 
got an error to the effect that 3 good + 1 spare drives are not enough 
to start the array (see below)

 > cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]  [multipath]
read_ahead not set
unused devices: <none>

 > mdadm -D /dev/md0
mdadm: md device /dev/md0 does not appear to be active

 > mdadm --assemble --force /dev/md0 /dev/hde1 /dev/hdi1 /dev/hdm1 /dev/hdo1
mdadm: /dev/md0 assembled from 3 drives and 1 spare - not enough to 
start the array

 > cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]  [multipath]
read_ahead not set
md0: inactive
ide/host2/bus0/target0/lun0/part1[0]
ide/host4/bus0/target0/lun0/part1[5]
ide/host6/bus1/target0/lun0/part1[4]
ide/host6/bus0/target0/lun0/part1[3]

Some notes:
hdk1 is the disk which failed initially
hdi1 is the disk which I removed and which thinks it is a 'spare'

The other three drives report basically identical info, like this:
 > mdadm -E /dev/hde1

Magic : a92b4efc
Version : 00.90.00
UUID : ec2e64a8:fffd3e41:ffee5518:2f3e858c
Creation Time : Sun Oct 5 01:25:49 2003
Build Level: raid5
Device Size : 160079488 (152.66 GiB 163.92 GB)
Raid Devices : 5
Total Devices : 5
Preferred Minor : 0

Update Time Sat Sep 25 22:07:26 2004
State : dirty
Active Devices : 3
Working Devices : 4
Failed Devices : 1
Spare Devices : 1
Checksum : 4ee5cc77 - correct
Events : 0.10

Layout : left-symmetric
Chunk Size :  128K

    Number        Major    Minor    RaidDevice    State
this    0        22        1        0        active sync
0        0        22        1        0        active sync
1        1        0        0        1        faulty removed
2        2        56        1        2        faulty 
/dev/ide/host4/bus0/target0/lun0/part1
3        3        57        1        3        active sync    
/dev/ide/host4/bus1/target0/lun0/part1
4        4        88        1        4        active sync 
/dev/ide/host6/bus0/target0/lun0/part1
5        5        34        1        5        spare

Here are the two drives in question:

__________mdadm -E /dev/hdi1:

Magic : a92b4efc
Version : 00.90.00
UUID : ec2e64a8:fffd3e41:ffee5518:2f3e858c
Creation Time : Sun Oct 5 01:25:49 2003
Build Level: raid5
Device Size : 160079488 (152.66 GiB 163.92 GB)
Raid Devices : 5
Total Devices : 5
Preferred Minor : 0

Update Time Sat Sep 25 22:07:26 2004
State : dirty
Active Devices : 3
Working Devices : 4
Failed Devices : 1
Spare Devices : 1
Checksum : 4ee5cc77 - correct
Events : 0.10

Layout : left-symmetric
Chunk Size :  128K

    Number        Major    Minor    RaidDevice    State
this    5        34        1        5        spare
0        0        22        1        0        active sync
1        1        0        0        1        faulty removed
2        2        56        1        2        faulty 
/dev/ide/host4/bus0/target0/lun0/part1
3        3        57        1        3        active sync    
/dev/ide/host4/bus1/target0/lun0/part1
4        4        88        1        4        active sync 
/dev/ide/host6/bus0/target0/lun0/part1
5        5        34        1        5        spare


__________mdadm -E /dev/hdk1
Magic : a92b4efc
Version : 00.90.00
UUID : ec2e64a8:fffd3e41:ffee5518:2f3e858c
Creation Time : Sun Oct 5 01:25:49 2003
Build Level: raid5
Device Size : 160079488 (152.66 GiB 163.92 GB)
Raid Devices : 5
Total Devices : 5
Preferred Minor : 0

Update Time Sat Sep 25 22:07:24 2004
State : dirty
Active Devices : 4
Working Devices : 5
Failed Devices : 0
Spare Devices : 1
Checksum : 4ee5cc77 - correct
Events : 0.9

Layout : left-symmetric
Chunk Size :  128K

    Number        Major    Minor    RaidDevice    State
this    2        56        1        2        active sync 
/dev/ide/host4/bus0/target0/lun0/part1
0        0        22        1        0        active sync
1        1        0        0        1        faulty removed
2        2        56        1        2        active sync 
/dev/ide/host4/bus0/target0/lun0/part1
3        3        57        1        3        active sync    
/dev/ide/host4/bus1/target0/lun0/part1
4        4        88        1        4        active sync 
/dev/ide/host6/bus0/target0/lun0/part1
5        5        34        1        5        spare




Neil Brown wrote:

>On Friday November 12, bugzilla@watkins-home.com wrote:
>  
>
>>First, stop using the old raid tools.  Use mdadm only!  mdadm would not
have
>>allowed your error to occur.
>>    
>>
>
>I'm afraid this isn't correct, though the rest of Guy's advice is very
>good (thanks Guy!).
>
>  mdadm --remove
>does exactly the same thing as
>  raidhotremove
>
>It is the kernel that should (and does) stop you from hot-removing a
>device that is working and active.  So I'm not quite sure what
>happened to Robert...
>
>Robert: it is always useful to provide specific with the output of 
>    cat /proc/mdstat
>and
>    mdadm -D /dev/mdX
>
>This avoids possible confusion over terminology.
>
>NeilBrown
>  
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

