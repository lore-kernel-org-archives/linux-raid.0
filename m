From: Janusz Zamecki <janusz@pipi.ma.cx>
Subject: Re: RAID1 & 2.6.9 performance problem
Date: Mon, 17 Jan 2005 21:49:09 +0100
Message-ID: <1105994949.14134.236.camel@pipi.ma.cx>
References: <41EBD827.80701@pipi.ma.cx>
	 <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net>
	 <1105977081.15184.12.camel@linux.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1105977081.15184.12.camel@linux.local>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W li=B6cie z pon, 17-01-2005, godz. 16:51, Hans Kristian Rosbach pisze:=
=20

[...]

> Actually I have managed to get about 30-40% higher throughput with ju=
st
> a little hacking on the code that selects what disk to use.
>=20
> Problem is
> -It selects the disk that is closest to the wanted sector by remember=
ing
>  what sector was last requested and what disk was used for it.
> -For sequential reads (sucha as hdparm) it will override and use the
>  same disk anyways. (sector =3D lastsector+1)
>=20
> I gained a lot of throughput by alternating disk, but seek time was
> roughly doubled. I also tried to get smart and played some with the
> code in order to avoid seeking both disks back and forth wildly when
> there were two sequential reads. I didn't find a good way to do it
> unfortunately.

What about the special case where whole disks are mirrored?=20
Then there is no need for selecting disks other than round-robin,
because the heads should be in similar positions (except for rebuild
situation).

I will be more than happy to give up partitions to get better
performance instead. I have two disks, so raid 1+0 is not an option.

Could you please reconsider releasing your patch?

Best regards, Janusz
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
