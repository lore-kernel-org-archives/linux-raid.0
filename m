From: Mark Watts <m.watts@eris.qinetiq.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 5 Aug 2004 13:38:02 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408051338.02365.m.watts@eris.qinetiq.com>
References: <cesjcm$9da$1@sea.gmane.org> <S267610AbUHEJ5F/20040805095705Z+97@vger.kernel.org> <cet7vc$mt7$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cet7vc$mt7$1@sea.gmane.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: Jens Benecke <jens@spamfreemail.de>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


> I'm still a bit torn between buying a 3ware hardware RAID for =A4140.=
- and
> just using 'md'. The box is an Athlon64 3GHz, so it'll have enough CP=
U
> power to do the RAID in software, but with partitioning etc, I think =
the
> hardware raid will be easier to handle because you can just ignore it=
=2E As
> long as the 3ware BIOS will handle failing drives, read/write errors,=
 etc
> etc. properly.

3ware (8506-4LP) is performing very badly here on Dual Opteron so I wou=
ldn't=20
recomend it.
Even a software raid-5 with the 3ware in jbod mode wasn't great.

Mark.

- --=20
Mark Watts
Senior Systems Engineer
QinetiQ Trusted Information Management
Trusted Solutions and Services group
GPG Public Key ID: 455420ED

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBEioqBn4EFUVUIO0RApf/AKC1A+9grRDHL2Yg6xU1hiE7LICZCQCfRkbH
x4oIjT2aqo0pazXQ5eDXwzY=3D
=3Dpd4i
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
