From: Al Boldi <a1426z@gawab.com>
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 14:29:34 +0300
Message-ID: <200707201429.34419.a1426z@gawab.com>
References: <200707200813.03553.a1426z@gawab.com> <20070720053526.GG943@1wt.eu> <Pine.LNX.4.64.0707200858030.31013@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707200858030.31013@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> On Jul 20 2007 07:35, Willy Tarreau wrote:
> >On Fri, Jul 20, 2007 at 08:13:03AM +0300, Al Boldi wrote:
> >> As always, a good friend of mine managed to scratch my partion table by
> >> cat'ing /dev/full into /dev/sda.  I was able to push him out of the
> >> way, but at least the first 100MB are gone.  I can probably live
> >> without the first partion, but there are many partitions after that,
> >> which I hope should easily be recoverable.
>
> Go use GPT, it's got a backup copy of the ptable at then end of the disk
> ;-)

Would that be compatible with md?

> >> I tried parted, but it's not working out for me.  Does anybody know of
> >> a simple partition recovery tool, that would just scan the disk for
> >> lost partions?
> >
> >The best one is simply "fdisk", because you can manually enter your
> >cylinders numbers. You have to find by hand the beginning of each
> > partition, and for this, you have to remember what filesystems you used
> > and see how to identify them (using a magic). Then with an hex editor,
> > you scan the disk to find such entries and note the possible sectors on
> > a paper. Then comes fdisk. You create the part, exit and try to mount
> > it. If it fails, fdisk again and try other values.
>
> Pretty easy:
> "XFSB" (offset +0),
> "ReIsErFs2" (offset +0x10034),
> "SWAPSPACE2" (offset +0xff6),
> "FAT32" (offset +0x52h, maybe harder) / "mkdofs" (+0x3)
> ext2/3 is TOUGH. (sequence 0x53ef at +0x438 - quite ambiguous!)

Actually, there is an easier way to do this with cfdisk.  Once you know where 
a partition starts, enter it into cfdisk and set the size to something 
short, then save and restart cfdisk. If the position is correct, then cfdisk 
will identify the fs type.  Now exit again and do an fsck, which will error 
out complaining about a dev-size/fs-size mismatch.  Adjust the cfdisk 
partition accordingly, and cycle through the rest of the partitions.

But, I want something much more automated.  And the partition table backup 
per partition entry isn't really a bad idea.


Thanks!

--
Al

