From: Mark Watts <m.watts@eris.qinetiq.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Mon, 2 Aug 2004 13:54:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408021354.36804.m.watts@eris.qinetiq.com>
References: <Pine.LNX.4.44.0408011724460.7382-100000@uplift.swm.pp.se> <200408011633.25028.mrwatts@fast24.co.uk> <Pine.LNX.4.56.0408011806110.6442@lion.drogon.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408011806110.6442@lion.drogon.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: Gordon Henderson <gordon@drogon.net>, Mark Watts <mrwatts@fast24.co.uk>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


> On Sun, 1 Aug 2004, Mark Watts wrote:
> > I'm going to try using xfs instead of ext3 on Monday too.
>
> I doubt it's a filesystem issue.
>
> Try this - make the array work flat-out - dd into a fil eor something and
> look at the process state of 'dd'. See if it's stuck in "D".
>
> Now look at /proc/interrupts...
>
> Look for ERR and MIS counts of non-zero...

Both of those are zero, even when hammering the disks.

Mark.

- -- 
Mark Watts
Senior Systems Engineer
QinetiQ Trusted Information Management
Trusted Solutions and Services group
GPG Public Key ID: 455420ED

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDjmMBn4EFUVUIO0RAqjKAJ0R+SMjOUFfVQ/QMimcE2pFNukosQCeNYyY
C26gL+Lh/vqG1q75nazqf5E=
=vwnS
-----END PGP SIGNATURE-----
