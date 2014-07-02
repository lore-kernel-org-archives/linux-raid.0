From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 2 Jul 2014 16:55:57 +0200
Message-ID: <20140702165557.85a2024cf32d012b9c632c56@bbaw.de>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
	<20140702204502.6b538fa8@notabene.brown>
	<20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
	<20140702152429.742a3e8ea8bd100f5b3bae1f@bbaw.de>
	<20140702151406.Horde.HZoGSPYRo99TtBOu1q6B-GA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702151406.Horde.HZoGSPYRo99TtBOu1q6B-GA@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Pedro,

Wed, 02 Jul 2014 15:14:06 +0100
Pedro Teixeira <finas@aeiou.pt> =3D=3D> Lars T=C3=A4uber <taeuber@bbaw.=
de> :
> Hi Lars,
>=20
> the output of those commands:
>=20
> root@nas3:/# cat /sys/block/sdb/queue/physical_block_size
> 4096
> root@nas3:/# cat /sys/block/md0/queue/physical_block_size
> 4096
> root@nas3:/#
>=20
> The strange thing here is that dmesg is not poluted with sata errors =
=20
> like it is usual when a hard disk has bad sectors or some other =20
> hardware problem. the only thing in dmesg that hints to why reading =20
> the md volume fails are from dm itself.

maybe because the controller-drive combination doesn't fit.
Does the controller tell some errors?
The LSI 9201-i16 compatibility list doesn't mention any 4k SATA drive.
Only 3 4k-SAS drives (seagate though) are mentioned to be compatible.

Maybe that's the cause?

Good luck
Lars


> Cheers
> Pedro
>=20
>=20
> Citando Lars T=C3=A4uber
> > Hi Pedro,
> >
> > maybe an issue with the logical/physical blocksize?
> > What tell these commands:
> >
> > cat /sys/block/sdb/queue/physical_block_size
> > cat /sys/block/md0/queue/physical_block_size
> >
> > Seagate says there are 4096 bytes/sector on this devices.
> >
> > Lars
>=20
>=20
>=20
> _____________________________________________________________________=
___________
> Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
> http://www.aeiou.pt


--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstra=C3=9Fe 22-23                      10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
