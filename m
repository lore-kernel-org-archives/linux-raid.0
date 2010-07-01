From: Shaochun Wang <scwang@ios.ac.cn>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Thu, 1 Jul 2010 14:40:44 +0800
Message-ID: <20100701064044.GB6058@localhost>
References: <20100629201153.GA13018@localhost>
 <20100630111854.006ec4d0@natsu>
 <alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 30, 2010 at 07:54:55AM +0200, Mikael Abrahamsson wrote:
> On Wed, 30 Jun 2010, Roman Mamedov wrote:
>=20
> >  dd if=3D/dev/zero of=3Dzerofile bs=3D1M count=3D2048 conv=3Dfdatas=
ync,notrunc
>=20
> To be a bit more sure about accurate measurement, make sure the amoun=
t of=20
> data you're transferring is twice the amount of RAM in the machine, t=
he=20
> above is only 2 gigs of data.
As suggested, I did the test again and got the following result:

	-bash-4.1$ sudo dd if=3D/dev/zero of=3Dtest.dd bs=3D1M count=3D5000 co=
nv=3Dfdatasync,notrunc
	Password:
	5000+0 records in
	5000+0 records out
	5242880000 bytes (5.2 GB) copied, 63.497 s, 82.6 MB/s

	-bash-4.1$ sudo dd if=3D/dev/zero of=3Dtest.dd bs=3D1M count=3D5000 co=
nv=3Dfdatasync,notrunc
	5000+0 records in
	5000+0 records out
	5242880000 bytes (5.2 GB) copied, 18.1033 s, 290 MB/s
=09
I don't know why the second dd becomes 290MB/s and the first 82.6MB/s.

--=20
Shaochun Wang(=CD=F5=C9=DC=B4=BA) <scwang@ios.ac.cn>
State Key Laboratory of Computer Science,
Institute of Software,
Chinese Academy of Sciences
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
