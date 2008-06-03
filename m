From: "Jeremy Leigh" <jeremy.leigh@gmail.com>
Subject: RE: Problem Growing Raid 5 Array - Help Needed!
Date: Wed, 4 Jun 2008 01:03:15 +1000
Message-ID: <48455d39.16078e0a.20d2.14eb@mx.google.com>
References: <48440E0A.7020707@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48440E0A.7020707@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Greaves' <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,
These commands are being run from root.

[root@FileServer ~]# fsck /dev/md0
fsck 1.40.2 (12-Jul-2007)
e2fsck 1.40.2 (12-Jul-2007)
fsck.ext2: Device or resource busy while trying to open /dev/md0
Filesystem mounted or opened exclusively by another program?

[root@FileServer ~]# resize2fs /dev/md0
resize2fs 1.40.2 (12-Jul-2007)
resize2fs: Device or resource busy while trying to open /dev/md0
Couldn't find valid filesystem superblock.

[root@FileServer ~]# lsof | grep /home
smbd      4674      root  cwd       DIR  253,0     4096    2 /home

[root@FileServer ~]# umount /home -f
[root@FileServer ~]# lsof | grep /home
[root@FileServer ~]#
[root@FileServer ~]# mdadm --stop --scan
mdadm: fail to stop array /dev/md0: Device or resource busy


Yes, I have rebooted, and rebooted into single user mode with no effect.

Mount works fine for the LVM volume sitting on /dev/md0
[root@FileServer ~]# mount /dev/LVMRAID/LV0 /home
[root@FileServer ~]#

Before sending email to this list I had already commented out the line in
/etc/fstab in case that was the cause. But here it is anyway.

#/dev/LVMRAID/LV0		/home		ext3	defaults	1 2

Finally, I can give you output of mdadm --detail, but to be honest, I don't
know what else I can do... This is really frustrating.

[root@FileServer ~]# mdadm --detail /dev/md0 
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Jul 18 21:10:47 2007
     Raid Level : raid5
     Array Size : 3418686208 (3260.31 GiB 3500.73 GB)
  Used Dev Size : 488383744 (465.76 GiB 500.10 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jun  4 00:19:29 2008
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           UUID : 46e9ab9d:c365cd2c:e08c1bc3:73c070ca
         Events : 0.988674

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       5       8      113        5      active sync   /dev/sdh1
       6       8       97        6      active sync   /dev/sdg1
       7       8      129        7      active sync   /dev/sdi1


I am not sure why it says RAID size, 3500.73 GB? Well it should be 4000 GB -
or maybe that only appears after the resize2fs.

Thanks for your response so far David.
Anyone else want to join in?

Regards.


-----Original Message-----
From: David Greaves [mailto:david@dgreaves.com] 
Sent: Tuesday, 3 June 2008 1:13 AM
To: Jeremy Leigh
Cc: linux-raid@vger.kernel.org
Subject: Re: Problem Growing Raid 5 Array - Help Needed!

Jeremy Leigh wrote:
> Hi Guys, I have just grown my raid 5 from 7 to 8 500Gb drives.
> I am now running into this problem.
> When I try to run fsck /dev/md0 I get the following:

What command line?

> fsck.ext2: Device or resource busy while trying to open /dev/md0
> Filesystem mounted or opened exclusively by another program?
> 
> Or when I try to run resize2fs /dev/md0 to make use of new drive, I get
the
> following:
> 
> resize2fs: Device or resource busy while trying to open /dev/md0
> Couldn't find valid filesystem superblock.
again, what command.


> Cat /proc/mdstat outputs:
> 
> Personalities : [raid6] [raid5] [raid4] 
> md0 : active raid5 sdb1[0] sdi1[7] sdg1[6] sdh1[5] sdf1[4] sde1[3] sdd1[2]
> sdc1[1]
>       3418686208 blocks level 5, 256k chunk, algorithm 2 [8/8] [UUUUUUUU]
>       
> unused devices: <none>
So the resize worked and is complete.

> However, I can still access and mount my filesystem - I just cannot grow
it,
> which I find very strange.
> I have tried to init 1, to go to single user mode, and I have made sure
file
> system is unmounted, but this 'busy' error still occurs.

Have you rebooted? (Question, not suggestion)

What is the output from a mount command.
What is the line in /etc/fstab than normally mounts this filesystem?

Is mdadm running as a monitor daemon?

does lsof | grep <mountpoint> show anything?

David

