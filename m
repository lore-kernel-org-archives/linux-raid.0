From: "Katarina WONG" <kwong@alexandria.cc>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 05 Aug 2004 14:49:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <opsb9e9dbwqqlv12@mercury.ameuret.com>
References: <cesjcm$9da$1@sea.gmane.org> <S267610AbUHEJ5F/20040805095705Z+97@vger.kernel.org> <cet7vc$mt7$1@sea.gmane.org> <200408051338.02365.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408051338.02365.m.watts@eris.qinetiq.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 5 Aug 2004 13:38:02 +0100, Mark Watts <m.watts@eris.qinetiq.com=
> =20
wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
>> I'm still a bit torn between buying a 3ware hardware RAID for =A4140=
=2E- and
>> just using 'md'. The box is an Athlon64 3GHz, so it'll have enough C=
PU
>> power to do the RAID in software, but with partitioning etc, I think=
 the
>> hardware raid will be easier to handle because you can just ignore i=
t. =20
>> As
>> long as the 3ware BIOS will handle failing drives, read/write errors=
, =20
>> etc
>> etc. properly.
>
> 3ware (8506-4LP) is performing very badly here on Dual Opteron so I =20
> wouldn't
> recomend it.
> Even a software raid-5 with the 3ware in jbod mode wasn't great.
>

I recon that Jens was talking from a functional standpoint (hotspare, =20
auto-rebuild, etc...). I too would be interested in hearing your =20
experience on these. Also, can you expand on your "bad performance" =20
statement ?

Thx

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
