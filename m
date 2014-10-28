From: NeilBrown <neilb@suse.de>
Subject: Re: Very small bug on assemble --force
Date: Wed, 29 Oct 2014 07:50:50 +1100
Message-ID: <20141029075050.605a11a9@notabene.brown>
References: <544FA7B6.7030100@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gG9YnT1IqddGZkxZqhSVA=s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <544FA7B6.7030100@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/gG9YnT1IqddGZkxZqhSVA=s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2014 15:27:02 +0100 Ethan Wilson <ethan.wilson@shiftmail.org>
wrote:

> Very small bug report:

Thanks for the bug report.
However, please always quote version of mdadm and version of Linux.

I think this might have been fixed already, in mdadm 3.3.1.

NeilBrown


> mdadm assemble --force fails to assemble at the very last step after=20
> having adjusted the event count:
>=20
>=20
> root@storage1:/root# mdadm --assemble /dev/md106 --config=20
> /etc/mdadm/mdadm.secondary.conf --force
> mdadm: forcing event count in=20
> /dev/mapper/mpathid-350014ee0ac5a112e-part1(3) from 1058 upto 1061
> mdadm: forcing event count in=20
> /dev/mapper/mpathid-350014ee056feaaf4-part1(4) from 1058 upto 1061
> mdadm: forcing event count in=20
> /dev/mapper/mpathid-350014ee001a93ede-part1(6) from 1058 upto 1061
> mdadm: clearing FAULTY flag for device 1 in /dev/md106 for=20
> /dev/mapper/mpathid-350014ee0ac5a112e-part1
> mdadm: clearing FAULTY flag for device 5 in /dev/md106 for=20
> /dev/mapper/mpathid-350014ee056feaaf4-part1
> mdadm: clearing FAULTY flag for device 8 in /dev/md106 for=20
> /dev/mapper/mpathid-350014ee001a93ede-part1
> mdadm: Marking array /dev/md106 as 'clean'
> mdadm: /dev/md106 assembled from 8 drives - not enough to start the array.
>=20
> mdadm is wrong here: 8 devices is indeed the total number of devices for=
=20
> this array.
> the last command started it inactive like this:
>=20
> md106 : inactive dm-101[0](S) dm-24[9](S) dm-107[6](S) dm-103[5](S)=20
> dm-123[4](S) dm-95[3](S) dm-105[2](S) dm-106[1](S)
>        4193255424 blocks super 1.2
> (maybe the blocks count is also wrong? Not adjusted for parity maybe?=20
> 4193255424  / 8.0 * 6.0 =3D=3D 3144941568.0 almost correct)
>=20
> it can be fixed simply by doing:
>=20
> root@storage1:/root# mdadm --stop /dev/md106
> mdadm: stopped /dev/md106
>=20
> root@storage1:/root# mdadm --assemble /dev/md106 --config=20
> /etc/mdadm/secondary.conf --no-degraded
> mdadm: /dev/md106 has been started with 8 drives.
>=20
> now it works:
>=20
> md106 : active raid6 dm-101[0] dm-24[9] dm-107[6] dm-103[5] dm-123[4]=20
> dm-95[3] dm-105[2] dm-106[1]
>        3144938496 blocks super 1.2 level 6, 512k chunk, algorithm 2=20
> [8/8] [UUUUUUUU]
>        bitmap: 0/1 pages [0KB], 1048576KB chunk
>=20
> Regards
> EW
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/gG9YnT1IqddGZkxZqhSVA=s
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFABqjnsnt1WYoG5AQLWKQ/8CrcP6Qo1+nu0Wn+6jhBljTWPmnZD2aWE
Ru0zF07LMnqQgcJjvqEpQvvIoWC6mFA8WtHeT45m/ldaDhsCoznHxtF+tMX1CYc2
2qKEg8qRXaobSirpS5CByFrCVJAH43GrQIDLmYkH54cV2tkfxwB8sAyiBlHTrH0I
vAMIC6CpHmXxHdmGWUQqJ86ltSURVExQCd265ziJ0HUjkGiKN0MdzZOqLGaPwiOu
wx1QdzmcER1AGmZhbLFtVWgcATy/03yyw2VtHjbU3mlCYf6cKyC5V4g0koOyN2pN
LJbCuQIIsLWP2LQaRdlgBrZvum0JzMcVXf9S2lpuZcjrbDJ+lQLZmLjF7jlyWgy/
ILHowb2xg4toJ3CcRsbnZppIhw3q+g6RkvuHV8p9fFnA8tyOb4WSYo8GTO2/QqXI
wvI2r6i8YHfqjoeflYmXuQuRLpdB2fS1ONGSNB8M33cApwKjwT05zxvP5WOlMy3X
5BknDGiy1pw1Ht/l7MBYl9wUrhmIQQRYAq1YSa8ecot37GeWU3cqF55T7CeF7boi
gpxkGMFteUSVvY2s5yJWuy3ZEkVl60EJqe7svrZ3qfC0ww9mAJnaLAlY30WvM3U1
sfml2DRUChB6VcIdjNAzrKKy1aQYiBa4Pyh8LHpzHr4lZjnwiHdNtMwylNjLB5zi
/opcwQhw/mM=
=DvhR
-----END PGP SIGNATURE-----

--Sig_/gG9YnT1IqddGZkxZqhSVA=s--
