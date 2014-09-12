From: NeilBrown <neilb@suse.de>
Subject: Re: Howto start reshape from 100% when change readonly raid to
 readwrite
Date: Fri, 12 Sep 2014 14:05:32 +1000
Message-ID: <20140912140532.7f8db3a2@notabene.brown>
References: <CAFvwrujsWB_zdvW0xfoGtOOrH5TH89m9CLEj-fBqn17N88LHpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/21.Wn9yNLTFKxLluKqsUH1E"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFvwrujsWB_zdvW0xfoGtOOrH5TH89m9CLEj-fBqn17N88LHpg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Apple Yin <bravery.apple@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/21.Wn9yNLTFKxLluKqsUH1E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 11:06:59 +0800 Apple Yin <bravery.apple@gmail.com> wrot=
e:

> I met a prolem which confused me long time.
> Background:
> I have two machines which connected to the same HDDs, both of them are
> linux software raid. Machine 1 called Master, Machine 2 called Slave.
> Master can readwrite the HDD, Slave can read the HDD only.
>=20
> /dev/md1 was  created on Master, and level is raid5 with 3 active
> disks + 1 spare disk. On slave I assemble the md1 as readonly with the
> same disks.Here is my steps:
> Create md1(raid5) on Master:
> #mdadm --create /dev/md1 -l 5 -n 3 -x 1 /dev/sd[bcde]
> Assemble md1(raid5) as readonly on Slave:
> #mdadm -A /dev/md1 /dev/sd[bcde] -o
>=20
>=20
> When Master doing the reshape(#mdadm --grow --raid-devices 4 /dev/md1
> ), Slave need to do the same reshape( #mdadm --grow --raid-devices 4
> /dev/md1).But md on Slave is readonly, so md_do_sync() not start.
> After Master finish the reshape, all data has moved from 3disks to
> 4disks. How can I ask Slave's md1 to start the reshape from 100% after
> set it to readwrite ? Here is my steps:

There is no way that you can make this reliable.
Even without a --grow happening, the read-only mount of changeable data cou=
ld
end up very confused.  You definitely cannot get md/raid5 to track the
changes made by another instance of md when reshaping.

If you unmount and --stop the array before starting the reshape, then
re-assemble and re-mount it, the more obvious probably should go away.
But it is likely there will still be less-obvious problems.

md might support clusters one day (though raid1 is much more likely than
raid5) but it certainly doesn't today.
I suggest you try to find a different solution to your underlying problem.

NeilBrown


>=20
> 1.On Slave, I modify the reshape_position_store() of md.c in kernel,
> to let user space to set reshape_position to =E2=80=9Cnone=E2=80=9D (100%=
):
> static ssize_t
> reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
> {
> =E2=80=A6
> if (cmd_match(buf, =E2=80=9Cnone=E2=80=9D))
> ;
> else if (buf =3D=3D e || (*e && *e !=3D =E2=80=98\n=E2=80=99))
> return -EINVAL;
>=20
> if (cmd_match(buf, =E2=80=9Cnone=E2=80=9D))
> mddev->reshape_position =3D MaxSector;
> else
> mddev->reshape_position =3D new;
> =E2=80=A6
> }
> #echo none > /sys/block/md1/md/reshape_position
>=20
> 2. change readonly raid to readwrite on Slave
> #mdadm =E2=80=93readwrite /dev/md1
>=20
>=20
> Result: the reshape didn=E2=80=99t start . Slave's md1 size still the old=
 size
> ( with 3 disk size)
>=20
>=20
>=20
> BRs,
> AppleYin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/21.Wn9yNLTFKxLluKqsUH1E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBJxDDnsnt1WYoG5AQLRpg//b+2GXjjD+8NIYzX6UkdCvjgL8TmZzjwl
6AvSHbzbFzl79OTNO47ftTiXG4GW9hTGNbAp/WLPyTaHDdSZ43QZ7ne7sOj6olto
ZmId6QoL1LFl4avhfqGcHuC2lZEawOfqfJI4+1XLwzsOUfcW+VOecHIYTqvCd9Sm
0ysFtBPo0DGqCssgeaa+UQ6d3KYq3sPJpv3LQ2WlpONtns1FD4zcLQ2h40hvicKl
s9CONmMMOkwkbqQXu6QUD1fr6Ma/BI7sIT/+TA43wXg5+Pj7XZvuFmTUFK/+Tpcv
TCfd0cauWoDGuQUFFMISuKt+25xd8qNZoIpaaLzuUqpWhycIZadLss0hB2BLT1YN
t5Q8nW3ftPD2N613JM4T7Q2aZKKvy7tZ2j5+sh2krF9pLN/aVtzMDGVoVdaqhVEK
IZxye25MGBZDCQbCRcztg4jBN/HfwK+EYiDqawIo866tp7Eo3Nf0vHJWGAN7MSmG
GJoXMlQpz3QpbF7A+kjD8nkvR++aqHWi/8Mc7ydni7iTMPpNulPSTi1NIjbKD4UO
JuVeCcDMxNyqcsj982tJA3ebywyAXt/bJykzEXfYpc7W0qRgikTWoz4toIlxn3Je
bySWqCtycpznL89S0UJRaPIKnQG5w/Ac1b1k4DziBR0j5mBVpc+aP2Lz3SLxFimw
JEyrYwWn84s=
=/bOj
-----END PGP SIGNATURE-----

--Sig_/21.Wn9yNLTFKxLluKqsUH1E--
