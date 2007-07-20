From: Willy Tarreau <w@1wt.eu>
Subject: Re: [RFH] Partion table recovery
Date: Fri, 20 Jul 2007 07:35:27 +0200
Message-ID: <20070720053526.GG943@1wt.eu>
References: <200707200813.03553.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761181AbXGTFfk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 20, 2007 at 08:13:03AM +0300, Al Boldi wrote:
> As always, a good friend of mine managed to scratch my partion table by 
> cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but 
> at least the first 100MB are gone.  I can probably live without the first 
> partion, but there are many partitions after that, which I hope should 
> easily be recoverable.
> 
> I tried parted, but it's not working out for me.  Does anybody know of a 
> simple partition recovery tool, that would just scan the disk for lost 
> partions?

The best one is simply "fdisk", because you can manually enter your
cylinders numbers. You have to find by hand the beginning of each partition,
and for this, you have to remember what filesystems you used and see how to
identify them (using a magic). Then with an hex editor, you scan the disk to
find such entries and note the possible sectors on a paper. Then comes fdisk.
You create the part, exit and try to mount it. If it fails, fdisk again and
try other values.

I've saved many disks that way, it may sound harder than it really is. It
should not take you more than half an hour to get the first part. Knowing
your approximate partitions size will help too.

Good luck!
Willy
