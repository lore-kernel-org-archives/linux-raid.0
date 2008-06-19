From: Neil Brown <neilb@suse.de>
Subject: Re: resync=PENDING, interrupted RAID5 grow will not automatically
 reconstruct
Date: Thu, 19 Jun 2008 14:06:16 +1000
Message-ID: <18521.56120.815779.403788@notabene.brown>
References: <3E998AD6CC01E746957550D4CD642A742303FF@TGEN-M2.ad.tgen.org>
	<C47DA531.9128%jmolina@tgen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jesse Molina on Tuesday June 17
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Molina <jmolina@tgen.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 17, jmolina@tgen.org wrote:
>=20
> I think I figured this out.
>=20
> man md
>=20
> Read the section regarding the sync_action file.
>=20
> do as root; =B3echo idle > /sys/block/md2/md/sync_action=B2
>=20
>=20
>=20
> After issuing the idle command, my array says;
>=20
> user@host# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
>     =20
> md2 : active raid5 sdd5[0] sdg5[4] sdh5[3] sdf5[2] sde5[1]
>       325283840 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/=
5]
> [UUUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  resh=
ape =3D 85.3% (138827968/162641920)
> finish=3D279.7min speed=3D1416K/sec

Well done :-)

Yes, you've found the bug that was fixed by commit
   25156198235325805cd7295ed694509fd6e3a29e
which is in 2.6.25.
I'm glad you found the workaround.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
