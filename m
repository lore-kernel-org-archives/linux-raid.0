From: NeilBrown <neilb@suse.de>
Subject: Re: Raid over USB disks and eject
Date: Tue, 13 Nov 2012 07:28:34 +1100
Message-ID: <20121113072834.1af12558@notabene.brown>
References: <CAGmni9rBn9V0kEqirNnLR1iGdaXc48+afuL1NbTg8R5Cr1q9hw@mail.gmail.com>
	<50A11EC0.1060203@mpstor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iWuqCKVTcw+1ByPc+rKAkyx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A11EC0.1060203@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: Salatiel Filho <salatiel.filho@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iWuqCKVTcw+1ByPc+rKAkyx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Nov 2012 16:07:28 +0000 Benjamin ESTRABAUD <be@mpstor.com> wrote:

> Hi!
>=20
> You could setup a cron job that will pause the resync by writing to sysfs:
>=20
> If your array if "md0":
>=20
> echo "idle" > /sys/block/md0/md/sync_action

"idle" is not sufficient.  It will stop the recovery, but then it will
immediately start again.
You need "frozen".

NeilBrown


>=20
> However, this is probably not necessary as the resynced stripes will be=20
> marked in the bitmap, meaning that if your rebuild fails, re-assembling=20
> the array should restart the resync from where it stopped.
>=20
> Regards,
> Ben.
>=20
> On 12/11/12 12:44, Salatiel Filho wrote:
> > Hi guys,  i have an external USB enclosure with 4 disks  in RAID5 mode
> > using mdadm. I dont know exactly why but if i use this disks for
> > massive I/O for lots of hours (over 12 hours), linux usually eject
> > some or all disks (causing a faulty in the raid) and remaps them: sdb
> > -> sdf , sdc -> sdg , sdd -> sdh , sde -> sdi
> > Well , this was never exactly a problem because most of the time those
> > disks are idle (just backup), but i had a real disk failure and i will
> > replace the disk. But probably the rebuild process will take a lot
> > more than 12 hours so the chances are that some disk will be ejected
> > and i will be in a trouble situation where a raid5 rebuilding process
> > will probably be stopped by an apparently failure. So my question is:
> >
> > If i get into that situation , will i be able to disassemble and
> > reassemble the disk using the three disks i know are 'fine' and
> > restart the rebuild process from where it stopped ? I have internal
> > bitmap enabled.
> >
> > Is it possible to somehow freeze the rebuild process ? So i could
> > pause the process for a few hours after 8 hours of work for example.
> >
> > The raid will be assembled but umounted during the rebuild proccess.
> >
> > I am using kernel 3.2.30.
> >
> > Thanks !!!
> >
> >
> > []'s
> > Salatiel
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message tomajordomo@vger.kernel.org
> > More majordomo info athttp://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/iWuqCKVTcw+1ByPc+rKAkyx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKFb8jnsnt1WYoG5AQJpkxAAk6rTsJFgO+faXBLMeYS9oVWUdrpLXY52
p7lEQVN4d0xVsKQ4XuHOYOGPxFi6q3KLzxlhUyNAGjEz1x8dBYwdPjDS9Q2h8smN
T2wtDXTiyCXTbMyRYvq5/DSnwMMRhfI0PotRnM2Sd0KjSPHBbmmT8GsNpL9iYZSL
HxDoTIawuJUuMk1LjspOVOadZrAyvnf03TKhP0E1WH6S8bAlJPYsxIH0mqAEeV6+
f2n08ieQuHnh0/eusWZk4dzvX/GpoXNgQ7xQjhiqSf01rSMDSR9MOk+u7ZGGXPz3
1BR9QLcUxtNdupXcaHThDG/usjOryxQrPJ2ftSWqRbX2mFuj9/OQUopSS764gyoJ
xwdg65dIQfe30NSd3kswxSUmRkjfaAafDc6lp4VWL/j/jtTpSypQqdZXP9GPTz11
9/atK5+tA7uRwgVF3zbJEgOREQDAlH3rzsx81HMJquODN0Yu9QbxQyntWl3ngvTQ
KCV0lIGGyTxfTOgliGMhBp/OrJ4zelAC0PMS+syKcv/ey/sUQ5Yv53vXXP+BGC0h
s49W4PzUJ+S7XOtCC0o11uoWEJPrL74b5IkvFnyrPQ4gV1zvWDiU9GZ7XIcwnGPW
+xbTG0oRNzWj8XdhME2rIRURCIOBsv0K+3CbJb26Riu43BD1Zt/GXeU3G88ad2I6
1ur/zVceQbc=
=uR30
-----END PGP SIGNATURE-----

--Sig_/iWuqCKVTcw+1ByPc+rKAkyx--
