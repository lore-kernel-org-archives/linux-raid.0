From: Mark Watts <mrwatts@fast24.co.uk>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 16:01:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408011601.46636.mrwatts@fast24.co.uk>
References: <Pine.LNX.4.44.0408011407230.7382-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408011407230.7382-100000@uplift.swm.pp.se>
Content-Disposition: inline
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Sun, 1 Aug 2004, Mark Watts wrote:
> > This doesn't help explain why some of us are experiencing crap
> > performance and un-responsive systems whereas others are having none of
> > these problems  with the same 3Ware cards.
>
> On my 3ware equipped system running hw raid5 I get lousy write speeds
> (approx 5-15 megabyte/s) on writes. I get great read speeds. I don't sit
> directly on the console so I have no idea if the system is interactively
> responsive or not, but I notice no problems being logged in via ssh.
>
> On the other hand, the 3ware volume is only used for bulk data storage,
> the system, swap and other often needed data that is accessed and changed
> often, I have stored on SCSI drives that are RAID1 or not RAIDed at all.
>
> I would never store the system/swap on a 3ware hw RAID5, that would be
> disasterous for performance. Could you perhaps describe your system setup
> in more detail?

Tyan S2845
Dual Opteron 246 Processors
2GB DDR333 Ram
nVidia FX5700
3Ware 8506-4LP 4 port SATA raid card
4x 250GB Maxtor hdds

RAID Configuration:
4-disk RAID-5 with 64K block size.

/dev/sda1 = / = 20GB
/dev/sda2 = swap = 2048MB
/dev/sda5 = /home = 100GB

All partitions (except swap) formatted as ext3.

Kernel - 2.6.8rc1, SMP for x86_64

Read performance is ok but nothing special.
Writing larger files (anything that takes more than a few seconds) will cause 
the system to 'stutter' as the write occurs.
Longer writes (eg: copying ISO image about or formatting the rest of the 
filesystem (600GB)) cause the system load to go high, very quickly.
System is almost unusable at this stage but load returns to normal as the 
write completes.


Slow write speeds is one thing, practically locking the system up while the 
write occurs is another, unless I'm missing something obvious.


