From: Mark Watts <m.watts@eris.qinetiq.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Mon, 2 Aug 2004 10:40:02 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408021040.02276.m.watts@eris.qinetiq.com>
References: <Pine.LNX.4.44.0408011724460.7382-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408011724460.7382-100000@uplift.swm.pp.se>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


> On Sun, 1 Aug 2004, Mark Watts wrote:
> > RAID Configuration:
> > 4-disk RAID-5 with 64K block size.
> >
> > /dev/sda1 = / = 20GB
> > /dev/sda2 = swap = 2048MB
> > /dev/sda5 = /home = 100GB
> >
> > All partitions (except swap) formatted as ext3.
>
> It would be interesting to see difference if you put the system and swap
> on another drive that is not part of the RAID5.
>
> > Kernel - 2.6.8rc1, SMP for x86_64
>
> I use v2.4, haven't used 2.6 with 3ware and SMP at all, so the problem
> might be there. Did you try the smp_affinity thing I emailed about 1-2
> days ago?

Ok i tried this and it made no difference.


- -- 
Mark Watts
Senior Systems Engineer
QinetiQ Trusted Information Management
Trusted Solutions and Services group
GPG Public Key ID: 455420ED

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDgvyBn4EFUVUIO0RAqJ0AKC2CgF/qT32el1xq7JdGntZj2fl0wCfVkRt
9sehETCi1tgs+ol/vRrkYu8=
=Ven5
-----END PGP SIGNATURE-----
