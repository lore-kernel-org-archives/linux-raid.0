From: NeilBrown <neilb@suse.de>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Fri, 9 Dec 2011 07:59:31 +1100
Message-ID: <20111209075931.29b26b5e@notabene.brown>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
	<20111208075709.587ac227@notabene.brown>
	<654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
	<20111208091651.2a56dd5b@notabene.brown>
	<2866C99D-B573-4EF3-8FD0-0A40B0C20118@ucsc.edu>
	<20111209065140.107aa286@notabene.brown>
	<46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/syXvnAZwUd2gm=d=AC=N3Sw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46200D05-2D7F-44F8-9323-DCFF720776D2@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/syXvnAZwUd2gm=d=AC=N3Sw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Dec 2011 12:39:10 -0800 Eli Morris <ermorris@ucsc.edu> wrote:

>=20

>=20
> and here is the verbose assemble output:
>=20
> [root@stratus log]# mdadm --verbose --assemble /dev/md5 --force /dev/sda1=
 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev=
/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1=20
> mdadm: looking for devices for /dev/md5
> mdadm: /dev/sda1 is identified as a member of /dev/md5, slot 0.
> mdadm: /dev/sdb1 is identified as a member of /dev/md5, slot -1.
> mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 2.
> mdadm: /dev/sdd1 is identified as a member of /dev/md5, slot 3.
> mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 4.
> mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 5.
> mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 6.
> mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 7.
> mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot -1.
> mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 9.
> mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 10.
> mdadm: /dev/sdl1 is identified as a member of /dev/md5, slot 11.
> mdadm: /dev/sdm1 is identified as a member of /dev/md5, slot 12.
> mdadm: /dev/sdn1 is identified as a member of /dev/md5, slot 13.
> mdadm: /dev/sdo1 is identified as a member of /dev/md5, slot -1.
> mdadm: no uptodate device for slot 1 of /dev/md5
> mdadm: added /dev/sdc1 to /dev/md5 as 2
> mdadm: added /dev/sdd1 to /dev/md5 as 3
> mdadm: added /dev/sde1 to /dev/md5 as 4
> mdadm: added /dev/sdf1 to /dev/md5 as 5
> mdadm: added /dev/sdg1 to /dev/md5 as 6
> mdadm: added /dev/sdh1 to /dev/md5 as 7
> mdadm: no uptodate device for slot 8 of /dev/md5
> mdadm: added /dev/sdj1 to /dev/md5 as 9
> mdadm: added /dev/sdk1 to /dev/md5 as 10
> mdadm: added /dev/sdl1 to /dev/md5 as 11
> mdadm: added /dev/sdm1 to /dev/md5 as 12
> mdadm: added /dev/sdn1 to /dev/md5 as 13
> mdadm: no uptodate device for slot 14 of /dev/md5
> mdadm: no uptodate device for slot 15 of /dev/md5
> mdadm: added /dev/sdb1 to /dev/md5 as -1
> mdadm: added /dev/sdi1 to /dev/md5 as -1
> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
> mdadm: added /dev/sda1 to /dev/md5 as 0
> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to sta=
rt the array.
>=20
>=20

Thank.

I know what the 'busy' thing is now.
sdo1 appears the be the 'same' as some other device in some way.

Also it looks like you might have turned some drives into spares
unintentionally, though I'm not sure

Could you pleas send "mdadm --examine" output for all of these drives and
I'll have a look.

Thanks,
NeilBrown




--Sig_/syXvnAZwUd2gm=d=AC=N3Sw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuElMznsnt1WYoG5AQKIuhAAj0zg0V7RMu0py/dOWXoNyh9cdqN0tcyy
MPxOvAvuE9vmf24EHWerEZGezXdNHo0V068UGxpU1lerT+C4unrehZ6xyU84gHJ4
APQCoY0O0lyQ8EVpOwl/Te5AECgWTyd5wCmvV30a/PpCTNixiRfHat1szAbE0ElH
IK7cqjqurfmTBYEvOZY99qzEm7R60zjvhF/OmdsfJo/LeV/wlbuCJPcmXkSaCXYT
L3mShry5d31fhxgCAWYz6h+mqEEi/RW7LPpMFdQ67i/kXqYfgHZluC4/Ns3Y4Gny
fGpuz3bt3mqr17qd84UNAV33lUjXETFcDSYAlpJrk52iO9/B02G9BHusjMY08cw6
8fbkBhWktuckUaUJIlQ6MQKbo8o+cK5Rt+dhjkJ2vps1I6yih0ByKPIBieGWroLv
sPNKbP9GHH7dDDcaRKky2UFMxv1Cqkhh4XHMrsej33ZbYgnIuHyCOBHdeGD7BnN8
7UgBr4ULVWCdTQ12QXOsq12322R9ZeSIoLChW9BKvRyOdwtg4i0CUnzi4Wuba6dl
exCoUA5yG3zl1AgjmG0FGZ/Eh5JlXNQNNm7fayG/rGB1AIqvZ9o3PZCeGGejdSiR
bzgkwCgWJFjQ0yXZTi8QkGVPI/h/J+7Fn+Cpi9XYZ5HJcVMKyTUC793PQBbtQsum
MiEMf7RaK04=
=kkOa
-----END PGP SIGNATURE-----

--Sig_/syXvnAZwUd2gm=d=AC=N3Sw--
