From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Questions regarding startup of imsm container
Date: Tue, 23 Mar 2010 15:16:27 -0700
Message-ID: <4BA93DBB.6000503@intel.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com> 	<e9c3a7c21003231401p55d4e392u22b062aaf464b1da@mail.gmail.com> <7db987b31003231441j56733b15wd111c4aa22e9eccc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003231441j56733b15wd111c4aa22e9eccc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Terbush <randy@terbush.org>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Randy Terbush wrote:
> Thanks for the suggestions from Dan and others. I've managed to pin
> the names of the raid devices. Getting closer to figuring out the
> startup problem hopefully. kernel trace included below...
> 
> This is running on Gentoo with kernel 2.6.30.
> Linux hifi 2.6.30-gentoo-r9 #1 SMP Mon Mar 22 08:25:58 MDT 2010 x86_64
> Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel GNU/Linux
> 
[..]
> And /proc/mdstat says:
> 
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md127 : active (read-only) raid5 sdb[3] sdc[2] sdd[1] sde[0]
>       2930280448 blocks super external:/md0/0 level 5, 64k chunk,
> algorithm 0 [4/4] [UUUU]
>         resync=PENDING
> 
> md0 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
>       9028 blocks super external:imsm
> 
> unused devices: <none>
> 

This shows that Gentoo is most likely not including mdmon in their 
initramfs environment.  mdadm assembles the array readonly, but then 
mdmon is required to mark the array writable.

> And a look at the kernel messages from dmesg says:
[..]
> [   22.918983] ------------[ cut here ]------------
> [   22.918986] kernel BUG at drivers/md/md.c:6139!

I believe I hit this bug before and it came down to a mismatch between 
the readonly status of the array.  The block device was marked 
read-write according to blockdev --getro, but the internal md device 
state was readonly.  I believe this has been fixed upstream (but the 
commit escapes me), but would also be addressed by having mdmon 
available when the array is assembled.  It would be nice if Gentoo would 
adopt Dracut for their initramfs generation tool as it already 
comprehends the mdmon wrangling issues.

--
Dan

