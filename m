From: Wim Vinckier <wim-raid@tisnix.be>
Subject: Re: FSCK and it crashes...
Date: Tue, 10 Dec 2002 11:22:26 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0212101115320.23960-100000@nooks.wimpunk.com>
References: <Pine.LNX.4.43.0212091504450.30636-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0212091504450.30636-100000@unicorn.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Dec 2002, Gordon Henderson wrote:

>
> I've been using Linux RAID for a few years now with good success, but have
> recently had a problem common to some systems I look after with kernel
> version 2.4.x.
>
> When I try to FSCK a RAID partition (and I've seen this happen on RAID 1
> and 5) the machine locks up needing a reset to get it going again. On past
> occasions I reverted to a 2.2 kernel with the patches and it went just
> fine, however this time I need to access hardware (New Promise IDE
> controllers) and LVM that only seem to be supported by very recent 2.4
> kernels. (ie 2.4.19 for the hardware)
>
> I've had a quick search of the archives and didn't really find anything -
> does anyone have any clues - maybe I'm missing something obvious?
>
> The box is running Debian3 and is a dual (AMD Athlon(tm) MP 1600+)
> processor box with 4 IDE drives on 2 promise dual 133 controllers (only
> the cd-rom on the on-board controllers) The kernels are stock ones off
> ftp.kernel.org. (Debian 3 comes with 2.4.18 which doesn't have the Promise
> drivers - I had to do the inital build by connecting one drive to the
> on-board controller, then migrate it over)
>
> The 4 drives are partitiond identically with 4 primary partitions, 256M,
> 1024M, 2048M and the rest of the disk (~120M) the 4 big partitions being
> combined together into a raid 5 which I then turn into one big physical
> volume using LVM, then create a 150GB logical volume out of that (so I can
> take LVM snapshots using the remaining ~200GB avalable). I'm wondering if
> this is now a bit too ambitious. I'll do some test later without LVM, but
> I have had this problem on 2 other boxes that don't use LVM.
>
> The other partitions are also raid5 except for the root partition which is
> raid1 so it can boot.
>
> It's nice and fast, and seems stable when running, and can withstand the
> loss of any 1 disk, but when there's the nagging fear that you might never
> be able to fsck it, it's a bit worrying... (Although moving to XFS is
> something planned anyway, but I feel we're right on the edge here with new
> hardware and software and don't want to push ourselves over!)
>
> So any insight or clues would be appreciated,
>
> Thanks,
>
> Gordon
>
>
> Ps. Output of /proc/mdstat if it helps:
>
> md0 : active raid1 hdg1[1] hde1[0]
>       248896 blocks [2/2] [UU]
>
> md4 : active raid1 hdk1[1] hdi1[0]
>       248896 blocks [2/2] [UU]
>
> md1 : active raid5 hdk2[3] hdi2[2] hdg2[1] hde2[0]
>       1493760 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]
>
> md2 : active raid5 hdk3[3] hdi3[2] hdg3[1] hde3[0]
>       6000000 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]
>
> md3 : active raid5 hdk4[3] hdi4[2] hdg4[1] hde4[0]
>       353630592 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]
>
> unused devices: <none>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I'm had a problem with was very simular.  One disk in my raid1 system
failed and needed to be replaced.  After i installed a new disk but when
it was syncing for a while, my system crashed.  I didn't need a fdisk
because i was using a reiserfs.  When I started my system again, raid
needed a sync so I got the crash again.  I tried it with a 2.4.18, 2.4.19
and a 2.4.20 kernel.  2.4.18 was able to sync my disks and after a little
search I found a different value in /proc/sys/dev/raid/speed_limit_max.
When I changed it in my 2.4.20 I mostly could sync.  I wasn't able to
trace the exact problem.  I thought it was a thermal problem since I had
some thermal problems with my system but it seems there are more people
out there with almost the same problem.

Greetings,

Wim.
------------------------------------------------------------------------
Wim VINCKIER
Wasstraat 38                                          Wim-Raid@tisnix.be
B-9000  Gent                                               ICQ 100545109
------------------------------------------------------------------------
'Windows 98 or better required' said the box... so I installed linux

