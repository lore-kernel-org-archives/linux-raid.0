From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BSD disklabel and autodetection
Date: Mon, 29 Jul 2002 20:13:18 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15685.5438.362051.450805@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.32.0207261708230.1091-100000@dope.pingdynasty.com>
	<3D450296.9B9D9961@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Monday July 29
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 29, mjt@tls.msk.ru wrote:
> martin@hack.org wrote:
> > 
> []
> > following some hints i've seen elsewhere on the list i tried to pass md
> > parameters to the kernel ->
> > 
> > Booting on Nautilus using machine vector Nautilus from SRM
> > Command line: ro root=/dev/md1 md=1,/dev/sdb5,/dev/sdc2,/dev/sdd2 raid=noautodetect
> > md: Will configure md1 (super-block) from /dev/sdb5,/dev/sdc2,/dev/sdd2, below.
> > 
> > with the raid=noautodetect option it works.
> > 
> > what other raid/md options can be passed this way? and how do i configure
> > more than one device? geez, hope there's not a 256 char limit to the
> > command line...
> 
> You may use md=N,dev1,dev2,... option as many times as you want, i.e.
> 
>  linux root=... md,1=/dev/sda1,.. md=2,/dev/sda2,...
> 
> I think that it's sufficient to tell it about only ONE member of
> an array this way if your raid device has persistent superblock
> (kernel will read superblock from first disk (or second for that
> matter - if you choose to tell it about second disk) and read
> other devices from there).

Nope.  You have to list all component devices.  (Storing device
identification in the superblock is a bad idea that doesn't work in
general, but does in enough specific cases that people still seem to
like it).

> 
> About other options - there are only two, raid= (e.g. noautodetect)
> and md= (above) that are raid-related.
> 
> > are these options documented somewhere??
> 
> I personally looked at sources in drivers/md/ directory and got the
> above line by reading initialization functions.  Maybe it's documented
> somewhere in Documentation/... ;)

  Documentation/md.txt

Personally, I am not a big fan of autodetection at all.

I see two reasonable ways to start up the RAID array that
stores the root filesystem.

  1/ kernel parameters like:
                md=0,/dev/sda1,/dev/sdb1

  2/ use an initrd filesystem and a user-mode program that
    finds and assembles arrays based on a simple config file.

All non-root raid arrays should be assembled after boot by
a user-mode program.
I use and recommend mdadm
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/

You can tell it how to recongnise parts of an array and 
it goes hunting, finds them, and assembles the array.

NeilBrown
