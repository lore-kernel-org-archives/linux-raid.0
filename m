From: Neil Brown <neilb@suse.de>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 11:38:17 +1100
Message-ID: <20100216113817.5a1d1227@notabene.brown>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	<4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
	<4B77044B.1020609@zytor.com>
	<alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
	<4B7719C1.1060400@zytor.com>
	<4B785C49.7010105@shiftmail.org>
	<4B786898.8030309@zytor.com>
	<4B788525.6000608@grumpydevil.homelinux.org>
	<alpine.LNX.2.01.1002141839210.12929@filesrv1.baby-dragons.com>
	<20100215071243.GA5068@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100215071243.GA5068@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Feb 2010 08:12:43 +0100
Luca Berra <bluca@comedia.it> wrote:

> On Sun, Feb 14, 2010 at 06:40:31PM -0900, Mr. James W. Laferriere wrote:
> > On Mon, 15 Feb 2010, Rudy Zijlstra wrote:
> >> H. Peter Anvin wrote:
> >>> IMO it would make sense to support autoassemble for 1.0 superblocks, and
> sorry kernel autodetect is borked
> 
> >>> making them the default.  The purpose would be to get everyone off 0.9.
> >>>  However, *any* default is better than 1.1.
> 
> there has been a discussion on what format should be made as the
> default, under the subject: "[ANNOUNCE] mdadm-3.1 has been withdrawn",
> iirc 1.1 was chosen as the default, versus 1.2, because it puts the
> superblock at the very same place as the partition table, thus
> preventing any possible confusion between partitioned disk and whole
> disk md. (yes someone managed to put both a whole disk 1.2 superblock
> and a valid partition table on the same device....)
> 
> >> As long is autodetect is supported in the kernel, i am willing to upgrade 
> >> to 1.0 superblocks. BUT i need the autodetect in the kernel, as i refuse 
> it wont be implemented
> 
> >> to use initrd for production servers.
> > 	I also have to agree with Rudy in this matter .
> >
> then use kernel command line

I cannot agree with this recommendation.
Using a kernel command line like:

   md=0,/dev/sda1,/dev/sdb1

will assemble v1.x arrays without an initrd.  However it depends on the device
names (sda, sdb) being stable.  If you also have an 'sdc', and sda dies in
such a way that it cannot be seen at all, then on the next reboot, md will
try to assemble sdb1 and sdc1 (which have now been renamed to sda1 and sdb1)
and this will fail.  So it works when everything else is working, but can
then fail exactly when you need it the most.

There are other edge cases that can confuse autodetect as well.  I put a lot
of effort into getting the assembly algorithms in mdadm to be as robust as I
could make them, and I really recommend using mdadm to assemble all arrays,
through an initrd if / is an md array.

If you really don't want to trust a distro initrd, then the mdadm source code
contains instructions for building a minimal initramfs which just runs mdadm
to assemble the root device, then mounts and pivot_roots to that.

If people have problems with initramfs, then I recommend filing bug reports
rather than simply choosing not to use it.  It isn't going to go away.

NeilBrown

