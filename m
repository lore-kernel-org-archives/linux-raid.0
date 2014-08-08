From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10-reshape crashed due to memory allocation problem
Date: Fri, 8 Aug 2014 12:35:17 +1000
Message-ID: <20140808123517.0614287a@notabene.brown>
References: <201408072106.s77L6kKo009859@portal.naev.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/h7U=6FsGma1wFSj.OOdbLx3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201408072106.s77L6kKo009859@portal.naev.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Koch <mdraid.pkoch@dfgh.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/h7U=6FsGma1wFSj.OOdbLx3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2014 23:06:46 +0200 mdraid.pkoch@dfgh.net (Peter Koch) wrote:

> Dear readers,
>=20
> seems like memory is leaking when a RAID10-array is reshaped.

Only in Linux 3.14.
You need commit cc13b1d1500656a20e41960668f3392dda9fa6e2
which is in v3.14.16

So even though you didn't tell me what kernel version you were using, I
knew:-)

(always report mdadm version and kernel version).

NeilBrown


>=20
> Here are the details of what I did:
>=20
> RAID10-array consisting of 13 disks (2TB each) and one spare was
> grown into a 16 disk RAID10-array by adding two more spares and
> then doing  mdadm --grow /dev/md5 --raid-devices=3D16
>=20
> When the reshape operation reached 80% (after 20 hours) the system
> became unresponsive and crashed soon after. Console output showed
> something like "... could not allocate memory block ..."
>=20
> The machine has 32GB of RAM.
>=20
> After the machine was rebooted the reshape operation was running
> for 6 more hours and was followed by an 8 hour resync.
>=20
> Everything seems to be OK now, but according to /proc/meminfo
> only 15GB of RAM are available. Much too low for a system that
> is almost idle.
>=20
> I will reboot the machine at our next maintenance window and
> compare its available memory with the situation right now.
>=20
> Is restarting the reshape operation after a crash really safe?
> Should I check the correctness of my array somehow?
>=20
> Kind regards
>=20
> Peter Koch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/h7U=6FsGma1wFSj.OOdbLx3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+Q3ZTnsnt1WYoG5AQJTHQ//U7ctv1iiQ7DuyyCAzwvvs87yOiomybNx
/3ylir4UotmJLNGWIxJW4AnQ0aeZbew0c3oB53u1d67+1HtNQMtuV26tlu/8Uaos
quJT4+zmAAV4qK1y84A0XVAS19iK13dqobtLcK8c7prvVqgkKx+yYiqqj+ZOtbtJ
iWEtViRMyJcB4F993rfxPU54BCJUjtY6UpltpOGg/gRgDeTEO/RaKlGKRxUMDbM1
u/TgyVxnsNRyULIITHeWtHoMkD8xyFR9M+CR6OriLI08om5cTYvMvxuslt17tupV
GkjFqNCj6Spoh+x88g25Tf8AFj5Ks3xuPTqLnVssJLrXjkrTKE7mi8qbWy92Oi1m
x6NXvdNCXP5Fet74vVgeVD93vcE4apDjgbeDiBcB8DwUTgNLsDuxbXCBRvy1FEmX
naXugLkIOV/38+1HoQg/5WqL3kei86WicYlaUZlDqrCgLcTIATn1DEEra1RldQQn
Az2ZfcHb/Y5PjvvL62r0QR8xmiICjAeEklx858AMyWeKMQm9YbbzihWNcqODSf8Q
U6saBGT7z09tO+5oasdJyPY7s2dtWx7CkZo43i1L57nvyg+gTmlOWi/XAV4pzSDg
cskU6/AWYs2lIR4Y0XDd8RQBaKGRui6zwN4N3v6F+Xham4XjhkR62ObrtuHsre1W
TnKPw3Xli/c=
=4PO5
-----END PGP SIGNATURE-----

--Sig_/h7U=6FsGma1wFSj.OOdbLx3--
