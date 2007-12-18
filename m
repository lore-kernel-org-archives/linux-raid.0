From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: Raid over 48 disks
Date: Tue, 18 Dec 2007 15:20:28 -0600
Message-ID: <cccedfc60712181320v5ec446abq37e45e5d905866cb@mail.gmail.com>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
	 <Pine.LNX.4.64.0712181325480.13538@p34.internal.lan>
	 <476820B0.9010200@ph.tum.de>
	 <Pine.LNX.4.64.0712181523250.7823@p34.internal.lan>
	 <476837F6.7050404@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476837F6.7050404@ph.tum.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/18/07, Thiemo Nagel <thiemo.nagel@ph.tum.de> wrote:
> >> Performance of the raw device is fair:
> >> # dd if=/dev/md2 of=/dev/zero bs=128k count=64k
> >> 8589934592 bytes (8.6 GB) copied, 15.6071 seconds, 550 MB/s
> >>
> >> Somewhat less through ext3 (created with -E stride=64):
> >> # dd if=largetestfile of=/dev/zero bs=128k count=64k
> >> 8589934592 bytes (8.6 GB) copied, 26.4103 seconds, 325 MB/s
> >
> > Quite slow?
> >
> > 10 disks (raptors) raid 5 on regular sata controllers:
> >
> > # dd if=/dev/md3 of=/dev/zero bs=128k count=64k
> > 8589934592 bytes (8.6 GB) copied, 10.718 seconds, 801 MB/s
> >
> > # dd if=bigfile of=/dev/zero bs=128k count=64k
> > 3640379392 bytes (3.6 GB) copied, 6.58454 seconds, 553 MB/s
>
> Interesting.  Any ideas what could be the reason?  How much do you get
> from a single drive?  -- The Samsung HD501LJ that I'm using gives
> ~84MB/s when reading from the beginning of the disk.
>
> With RAID 5 I'm getting slightly better results (though I really wonder
> why, since naively I would expect identical read performance) but that
> does only account for a small part of the difference:
>
>         16k read        64k write
> chunk
> size    RAID 5  RAID 6  RAID 5  RAID 6
> 128k    492     497     268     270
> 256k    615     530     288     270
> 512k    625     607     230     174
> 1024k   650     620     170     75

It strikes me that these numbers are meaningless without knowing if
that is actual data-to-disk or data-to-memcache-and-some-to-disk-too.
Later versions of 'dd' offer 'conv=fdatasync' which is really handy
(call fdatasync on the output file, syncing JUST the one file, right
before close). Otherwise, oflags=direct will (try) to bypass the
page/block cache.

I can get really impressive numbers, too (over 200MB/s on a single
disk capable of 70MB/s) when I (mis)use dd without fdatasync, et al.

The variation in reported performance can be really huge without
understanding that you aren't actually testing the DISK I/O but *some*
disk I/O and *some* memory caching.




-- 
Jon
