From: "Majed B." <majedb@gmail.com>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Thu, 1 Jul 2010 23:30:26 +0300
Message-ID: <AANLkTilnBWCGHUgQnmrzSzpo7TRYSedBVUZEOHKI4MmG@mail.gmail.com>
References: <20100629201153.GA13018@localhost> <20100630111854.006ec4d0@natsu>
	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se> <20100701064044.GB6058@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100701064044.GB6058@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

How much RAM does your machine have?

Write to the disk an amount that is larger than the amount of RAM and
see if you get the same result.

Also you can use hdparm to flush the caches before running dd the 2nd t=
ime.

2010/7/1 Shaochun Wang <scwang@ios.ac.cn>
>
> On Wed, Jun 30, 2010 at 07:54:55AM +0200, Mikael Abrahamsson wrote:
> > On Wed, 30 Jun 2010, Roman Mamedov wrote:
> >
> > > =C2=A0dd if=3D/dev/zero of=3Dzerofile bs=3D1M count=3D2048 conv=3D=
fdatasync,notrunc
> >
> > To be a bit more sure about accurate measurement, make sure the amo=
unt of
> > data you're transferring is twice the amount of RAM in the machine,=
 the
> > above is only 2 gigs of data.
> As suggested, I did the test again and got the following result:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0-bash-4.1$ sudo dd if=3D/dev/zero of=3Dtes=
t.dd bs=3D1M count=3D5000 conv=3Dfdatasync,notrunc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Password:
> =C2=A0 =C2=A0 =C2=A0 =C2=A05000+0 records in
> =C2=A0 =C2=A0 =C2=A0 =C2=A05000+0 records out
> =C2=A0 =C2=A0 =C2=A0 =C2=A05242880000 bytes (5.2 GB) copied, 63.497 s=
, 82.6 MB/s
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0-bash-4.1$ sudo dd if=3D/dev/zero of=3Dtes=
t.dd bs=3D1M count=3D5000 conv=3Dfdatasync,notrunc
> =C2=A0 =C2=A0 =C2=A0 =C2=A05000+0 records in
> =C2=A0 =C2=A0 =C2=A0 =C2=A05000+0 records out
> =C2=A0 =C2=A0 =C2=A0 =C2=A05242880000 bytes (5.2 GB) copied, 18.1033 =
s, 290 MB/s
>
> I don't know why the second dd becomes 290MB/s and the first 82.6MB/s=
=2E
>
> --
> Shaochun Wang(=E7=8E=8B=E7=BB=8D=E6=98=A5) <scwang@ios.ac.cn>
> State Key Laboratory of Computer Science,
> Institute of Software,
> Chinese Academy of Sciences
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml



--
=C2=A0 =C2=A0 =C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
