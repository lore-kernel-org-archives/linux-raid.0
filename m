From: Drew <drew.kay@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 20:42:22 -0700
Message-ID: <c268e4660910052042t25849cbbl41aa7b8754bf7950@mail.gmail.com>
References: <c268e4660910051141r125e943csa91dad2ede6d41f5@mail.gmail.com>
	<20091006005026746.OZOR12917@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091006005026746.OZOR12917@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> =C2=A0 =C2=A0 =C2=A0 =C2=A0Yep. =C2=A0Sure can. =C2=A0I've used LVM, =
and for some applications it's
> great. =C2=A0Indeed, as I mentioned, adfas might be well served with =
LVM volumes
> on each machine. =C2=A0It certainly would provide great performance, =
although as
> I also mentioned, I don't think drive performance is really his probl=
em, per
> se.

I follow the threads on the MythTV list so I'd agree there are better
ways to partition/RAID the system. The MythTV guys are, in many cases,
pushing Terabytes of data through consumer grade SATA drives, RAID,
LVM and high performance filesystems like JFS/XFS. It's amazing
sometimes the extent they go to tuning their rigs to handle the
various on-disk buffers and what not MythTV seems to use.

Adfas: You may want to consider talking with the boys over at MythTV.
If you want to tune your rig for MythTV those guys are the best ones
to talk with as they know their app very well.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
