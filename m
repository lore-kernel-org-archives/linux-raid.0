From: Mark Watts <m.watts@eris.qinetiq.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 14:24:25 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407301424.25496.m.watts@eris.qinetiq.com>
References: <200407301116.42676.m.watts@eris.qinetiq.com> <Pine.LNX.4.58.0407300858200.503@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0407300858200.503@chaos.egr.duke.edu>
Content-Disposition: inline
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


> On Fri, 30 Jul 2004 at 11:16am, Mark Watts wrote
>
> > Basically anything involving I/O is causing the system to crawl.
> > I can reliably reproduce this by doing:
> >
> > 	mke2fs -j /dev/sda7
> >
> > Where sda7 is a 600GB partition.
> >
> > Basically the system load goes orbital and responsivness goes out the
> > window. gkrellm only shows ~1MB/sec of disk activity and the processors
> > (Dual Opteron) are twiddling their thumbs (top shows 100% 'wa' state for
> > both processors), yet I can hardly do anything with any open
> > applications.
> >
> > Kernel is a 2.6.8rc1 kernel.org job.
>
> Make sure that your driver and firmware versions match (check the 3ware
> site).  Also, have you tried other FSs?  I get *very* good performance out
> of 7500-8s using XFS on 2.4 (and hardware RAID5+software RAID0).  I
> haven't tried 2.6 yet.

I'm running the latest firmware from www.3ware.com (FE8S 1.05.00.068)
Driver is v1.26.00.039 from kernel 2.6.8rc1

Obviously these aren't the same, but I can only see drivers for RedHat or 
generic 2.4 kernels on the 3ware site, not 2.6.x

Mark.

- -- 
Mark Watts
Senior Systems Engineer
QinetiQ Trusted Information Management
Trusted Solutions and Services group
GPG Public Key ID: 455420ED

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBCkwJBn4EFUVUIO0RAn4uAKDfFSFhbINbNzy64XJHfcqE3ZxrZwCfWhrE
r9pxnUC81Uwdm3OCc8JzPy8=
=aEJ4
-----END PGP SIGNATURE-----
