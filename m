From: Derek Piper <derek.piper@gmail.com>
Subject: Re: RAID5 on different sized disks on low-end machine
Date: Tue, 11 Jan 2005 14:14:14 -0500
Message-ID: <eaa6dfe050111111465c7e5b1@mail.gmail.com>
References: <eaa6dfe050111104772af6240@mail.gmail.com>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe050111104772af6240@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I revised my idea and thought about RAID 1+0 for some partitions,
since there are 4 drives. This outline below might clarify what I was
trying to mention earlier. Is this a feasible set-up that would be
bootable (kernel compiled-in md, I'm no stranger to compiling
kernels)? I'm interested to hear comments/opinions since I've never
done this before. Like I said, it'll be running on a Dual-pentium pro
200 (W6-LI) machine, I have no idea if machines of that vintage have
the 'cojones' for software raid or not.

My ideas of RAID1+0 / RAID5 disk system partitions							
		MB					
/dev/hde	60GB	57241	(from controller)				
/dev/hdf	60GB	57241	(from controller)				
/dev/hdg	60GB	57241	(from controller)				
/dev/hdh	80GB	78125	(unconfirmed)				
							
/dev/hd* = applies to all drives considered here							
							
Device	MB	Type	GB	Mountpoint	MD device	RAIDed size (MB)	GB
/dev/hd*1	20	RAID1 + 0	0.02	/boot	/dev/md1	40	0.04
/dev/hd*2	192	RAID1 + 0	0.19	Swap	/dev/md2	384	0.38
/dev/hd*5	2048	RAID1 + 0	2	/	/dev/md5	4096	4
/dev/hd*6	2048	RAID5	2	/home	/dev/md6	6144	6
/dev/hd*7	52933	RAID5	51.69	/data	/dev/md7	158799	155.08

Does swap being raided make sense? I hear that sometimes it's a good
idea since a disk failure won't make you crash and then I heard
elsewhere that it doesn't matter and the kernel automatically raids
swap partitions anyway. I prepared the above in a spreadsheet btw so I
could work out partition sizes.

Thanks in advance again for any comments.

Derek

On Tue, 11 Jan 2005 13:47:20 -0500, Derek Piper <derek.piper@gmail.com> wrote:
> Hi,
> 
> I am new to RAID / md devices, although I've used Linux for a number
> of years. I decided it was high-time I had a RAID at home for
> important things (email, web-sites, son's baby pics, mp3s etc.). I
> happen to have a 3 Seagate 60GB hds and 1 80GB Seagate hd that I am
> considering using for a RAID.
> 
> My question is this, is it possible (and even a good idea) to use all
> 4 hard drives as members of a 4 x 60GB RAID5 array by leaving 20GB of
> the 80GB drive as a non-raided partition? I'll be using a Promise
> Ultra TX2/100 controller.
> 
> i.e.
> 
> hde -> 60
> hdf -> 60
> hdg -> 60
> hdh -> 60/20
> 
> I heard about RAID6 too, though I'm assuming that will use up another
> disk's worth of disk space too.
> 
> i.e. RAID5 = 180GB usable size,wherease RAID6 = 120GB .. am I correct
> in my thinking?
> 
> I know many of you use far larger hard drives, I'm just trying to use
> the components I already had spare from a number of machines and
> reorganize to a RAID-backed fileserver.
> 
> The machine is a dual pentium-pro 200 (320MB RAM) .. would that be a
> dumb idea to use RAID5 on it because of the parity calculations
> needed?
> 
> Further to that, would it be a smarter idea to use RAID1 on all 4 of
> some small partition(s) at the start of the disks to house
> boot/root/usr partitions, and only RAID5 on a larger 'data' area of
> the drive that is more likely to be read than written to?
> 
> Comments are appreciated.
> 
> Thanks,
> 
> Derek
> 


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
