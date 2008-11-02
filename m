From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: md raid10 regression in 2.6.27.4 (possibly earlier)
Date: Sun, 02 Nov 2008 19:37:35 +0200
Message-ID: <490DE55F.6080600@mandriva.org>
References: <490D8EBF.8050400@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490D8EBF.8050400@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson skrev:
> Hi,
> 
> Some weeks ago I upgraded from 2.6.23 to 2.6.27.4. After a failed hard
> drive I realized that re-adding drives to a degraded raid10 no longer
> works (it adds the drive as a spare and never starts a resync). Booting
> back into the old .23 kernel allowed me to complete and resync the array
> as usual. Attached find a test case reliably failing on vanilla 2.6.27.4
> with no patches.
> 

I've just been hit with the same problem...

I have a brand new server setup with 2.6.27.4 x86_64 kernel and a mix of
raid0, raid1, raid5 & raid10 partitions like this:
$ cat /proc/mdstat
Personalities : [raid10] [raid6] [raid5] [raid4] [raid1] [raid0]
md6 : active raid5 sdc8[2] sdb8[1] sda8[0] sdd8[3]
       2491319616 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
       bitmap: 0/198 pages [0KB], 2048KB chunk

md5 : active raid1 sda7[1] sdb7[0] sdd7[2]
       530048 blocks [4/4] [UUUU]

md3 : active raid10 sda5[4](S) sdb5[1] sdc5[2] sdd5[5](S)
       20980608 blocks 64K chunks 2 near-copies [4/2] [_UU_]

md1 : active raid0 sda2[0] sdb2[1] sdc2[2] sdd2[3]
       419456512 blocks 128k chunks

md2 : active raid10 sda3[4](S) sdc3[5](S) sdb3[1] sdd3[3]
       41961600 blocks 64K chunks 2 near-copies [4/2] [_U_U]

md0 : active raid10 sda1[0] sdd1[3] sdc1[2] sdb1[1]
       8401792 blocks 64K chunks 2 near-copies [4/4] [UUUU]

md4 : active raid10 sda6[0] sdd6[3] sdc6[2] sdb6[1]
       10506240 blocks 64K chunks 2 near-copies [4/4] [UUUU]



I have mdadm 2.6.7 with the following fixes:
d7ee65c960fa8a6886df7416307f57545ddc4460 "Fix bad metadata formatting"
43aaf431f66270080368d4b33378bd3dc0fa1c96 "Fix NULL pointer oops"

I was hitting the NULL pointer oops, wich prevented my md's to start 
fully, but with the patches above I can (re)boot the system without
beeing dropped into maintenance mode...

but I cant bring theese raid10 back fully online:

md3 : active raid10 sda5[4](S) sdb5[1] sdc5[2] sdd5[5](S)
       20980608 blocks 64K chunks 2 near-copies [4/2] [_UU_]

md2 : active raid10 sda3[4](S) sdc3[5](S) sdb3[1] sdd3[3]
       41961600 blocks 64K chunks 2 near-copies [4/2] [_U_U]

I can remove and add the missing disks, but they only end up as spares,
they dont get back online...

Any Pointers?

--
Thomas
