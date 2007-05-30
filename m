From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mismatch_cnt = 128 for root (/) md raid1 device
Date: Wed, 30 May 2007 08:06:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705300806410.5844@p34.internal.lan>
References: <Pine.LNX.4.64.0705260510040.25381@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705260510040.25381@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Asking again..

On Sat, 26 May 2007, Justin Piszcz wrote:

> Kernel 2.6.21.3
>
> Fri May 25 20:00:02 EDT 2007: Executing RAID health check for /dev/md0...
> Fri May 25 20:00:03 EDT 2007: Executing RAID health check for /dev/md1...
> Fri May 25 20:00:04 EDT 2007: Executing RAID health check for /dev/md2...
> Fri May 25 20:00:05 EDT 2007: Executing RAID health check for /dev/md3...
> Sat May 26 04:40:09 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
> Sat May 26 04:40:09 EDT 2007: 0
> Sat May 26 04:40:09 EDT 2007: cat /sys/block/md1/md/mismatch_cnt
> Sat May 26 04:40:09 EDT 2007: 0
> Sat May 26 04:40:09 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
> Sat May 26 04:40:09 EDT 2007: 128
> Sat May 26 04:40:09 EDT 2007: cat /sys/block/md3/md/mismatch_cnt
> Sat May 26 04:40:09 EDT 2007: 0
> Sat May 26 04:40:09 EDT 2007: The meta-device /dev/md0 has no mismatched
> sectors.
> Sat May 26 04:40:10 EDT 2007: The meta-device /dev/md1 has no mismatched
> sectors.
> Sat May 26 04:40:11 EDT 2007: The meta-device /dev/md2 has 128 mismatched
> sectors.
> Sat May 26 04:40:11 EDT 2007: Executing repair on /dev/md2
> Sat May 26 04:40:12 EDT 2007: The meta-device /dev/md3 has no mismatched
> sectors.
> Sat May 26 05:00:14 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
> Sat May 26 05:00:14 EDT 2007: 0
> Sat May 26 05:00:14 EDT 2007: cat /sys/block/md1/md/mismatch_cnt
> Sat May 26 05:00:14 EDT 2007: 0
> Sat May 26 05:00:14 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
> Sat May 26 05:00:14 EDT 2007: 0
> Sat May 26 05:00:14 EDT 2007: cat /sys/block/md3/md/mismatch_cnt
> Sat May 26 05:00:14 EDT 2007: 0
>
> I often see 128 or so for the root volume (/) for my RAID1.  Any idea?  I 
> know when you reboot/shutdown a system with md raid1 it does not mount 
> uncleanly (I believe?).
>
> Just curious why it happens on the root volume and if its something I should 
> be worried about?
>
> md0=swap
> md1=boot
> md2=root
> md3=raid5_volume
>
>
