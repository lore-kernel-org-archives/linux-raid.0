From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: RAID5 on different sized disks on low-end machine
Date: Wed, 12 Jan 2005 00:26:33 +0000
Message-ID: <cs1qqb$98l$1@sea.gmane.org>
References: <eaa6dfe050111104772af6240@mail.gmail.com> <eaa6dfe050111111465c7e5b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe050111111465c7e5b1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Derek Piper wrote:
> Hi,
> 
> I revised my idea and thought about RAID 1+0 for some partitions,
> since there are 4 drives. This outline below might clarify what I was
> trying to mention earlier. Is this a feasible set-up that would be
> bootable (kernel compiled-in md, I'm no stranger to compiling
> kernels)? I'm interested to hear comments/opinions since I've never
> done this before. Like I said, it'll be running on a Dual-pentium pro
> 200 (W6-LI) machine, I have no idea if machines of that vintage have
> the 'cojones' for software raid or not.
> 
> My ideas of RAID1+0 / RAID5 disk system partitions							
> 		MB					
> /dev/hde	60GB	57241	(from controller)				
> /dev/hdf	60GB	57241	(from controller)				
> /dev/hdg	60GB	57241	(from controller)				
> /dev/hdh	80GB	78125	(unconfirmed)				
> 							
> /dev/hd* = applies to all drives considered here							
> 							
> Device	MB	Type	GB	Mountpoint	MD device	RAIDed size (MB)	GB
> /dev/hd*1	20	RAID1 + 0	0.02	/boot	/dev/md1	40	0.04
> /dev/hd*2	192	RAID1 + 0	0.19	Swap	/dev/md2	384	0.38
> /dev/hd*5	2048	RAID1 + 0	2	/	/dev/md5	4096	4
> /dev/hd*6	2048	RAID5	2	/home	/dev/md6	6144	6
> /dev/hd*7	52933	RAID5	51.69	/data	/dev/md7	158799	155.08
> 
> Does swap being raided make sense? I hear that sometimes it's a good
> idea since a disk failure won't make you crash and then I heard
> elsewhere that it doesn't matter and the kernel automatically raids
> swap partitions anyway. I prepared the above in a spreadsheet btw so I
> could work out partition sizes.
> 
> Thanks in advance again for any comments.
> 
> Derek
> 
> On Tue, 11 Jan 2005 13:47:20 -0500, Derek Piper <derek.piper@gmail.com> wrote:
> 
>>Hi,
>>
>>I am new to RAID / md devices, although I've used Linux for a number
>>of years. I decided it was high-time I had a RAID at home for
>>important things (email, web-sites, son's baby pics, mp3s etc.). I
>>happen to have a 3 Seagate 60GB hds and 1 80GB Seagate hd that I am
>>considering using for a RAID.
>>
>>My question is this, is it possible (and even a good idea) to use all
>>4 hard drives as members of a 4 x 60GB RAID5 array by leaving 20GB of
>>the 80GB drive as a non-raided partition? I'll be using a Promise
>>Ultra TX2/100 controller.
>>
>>i.e.
>>
>>hde -> 60
>>hdf -> 60
>>hdg -> 60
>>hdh -> 60/20
>>
>>I heard about RAID6 too, though I'm assuming that will use up another
>>disk's worth of disk space too.
>>
>>i.e. RAID5 = 180GB usable size,wherease RAID6 = 120GB .. am I correct
>>in my thinking?
>>
>>I know many of you use far larger hard drives, I'm just trying to use
>>the components I already had spare from a number of machines and
>>reorganize to a RAID-backed fileserver.
>>
>>The machine is a dual pentium-pro 200 (320MB RAM) .. would that be a
>>dumb idea to use RAID5 on it because of the parity calculations
>>needed?
>>
>>Further to that, would it be a smarter idea to use RAID1 on all 4 of
>>some small partition(s) at the start of the disks to house
>>boot/root/usr partitions, and only RAID5 on a larger 'data' area of
>>the drive that is more likely to be read than written to?

Derek,

I have a machine with 6 x 250GB SATA disks, but the configuration I use 
would work just as well for you. Here's what I'd do:

Partition all your drives the same.
Create one small partition of 1GB, plus one large partition using up the 
rest of the disk (i.e. around 59GB), *except* the 80GB drive. On this, 
create a 1GB partition, a 59GB partition, plus a third partition using 
up the rest of the disk (i.e. around 20GB)

Assuming these drives are /dev/hd[efgh], configure them as follows:

/dev/hd[ef]1  	/dev/md0	/
/dev/hd[gh]1	/dev/md1	swap
/dev/hd[efgh]2	/dev/md2	lvm volume group
/dev/hdh3	-		use for whatever you want!

Now, use lvm to create logical volumes in your large volume group. I 
have created /var, /use, and use the rest for /home.

These are my arrays:

[root@dude slimserver]# mdadm --detail --scan
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=be8ad31a:f13b6f4b:c39732fc:c84f32a8
    devices=/dev/sdb1,/dev/sde1
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=826170e2:cdd598d4:d212c9b1:6602deef
    devices=/dev/sdc1,/dev/sdf1
ARRAY /dev/md5 level=raid5 num-devices=5 spares=1 
UUID=a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
    devices=/dev/sda2,/dev/sdb2,/dev/sdc2,/dev/sdd2,/dev/sde2,/dev/sdf2
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=4b28338c:bf08d0bc:bb2899fc:e7f35eae
    devices=/dev/sda1,/dev/sdd1

These are the lvm logical volumes:

[root@dude slimserver]# lvdisplay
   --- Logical volume ---
   LV Name                /dev/audio_vg/usr_lv
   VG Name                audio_vg
   LV UUID                qseH0A-wKgo-xhB5-2tJ4-Qnxx-VOML-0eb43m
   LV Write Access        read/write
   LV Status              available
   # open                 1
   LV Size                10.00 GB
   Current LE             160
   Segments               1
   Allocation             inherit
   Read ahead sectors     0
   Block device           253:0

   --- Logical volume ---
   LV Name                /dev/audio_vg/var_lv
   VG Name                audio_vg
   LV UUID                nzH8uf-LhyU-o5My-tK48-ckaw-xzfL-esbfj4
   LV Write Access        read/write
   LV Status              available
   # open                 1
   LV Size                5.00 GB
   Current LE             80
   Segments               1
   Allocation             inherit
   Read ahead sectors     0
   Block device           253:1

   --- Logical volume ---
   LV Name                /dev/audio_vg/home_lv
   VG Name                audio_vg
   LV UUID                zbixtc-S6mb-MTVR-WXGw-dkjG-EU9q-WeZItv
   LV Write Access        read/write
   LV Status              available
   # open                 1
   LV Size                914.38 GB
   Current LE             14630
   Segments               1
   Allocation             inherit
   Read ahead sectors     0
   Block device           253:2


This is what my filesystems look like:

[root@dude slimserver]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              1.4G  357M  985M  27% /
/dev/mapper/audio_vg-var_lv
                       5.0G  1.4G  3.3G  30% /var
/dev/mapper/audio_vg-usr_lv
                       9.9G  2.4G  7.0G  26% /usr
/dev/mapper/audio_vg-home_lv
                       915G  142G  764G  16% /home

And finally swap:

[root@dude slimserver]# swapon -s
Filename                                Type            Size    Used 
Priority
/dev/md1                                partition       1469816 224     -1

R.
--
http://robinbowes.com

