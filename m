From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 1 vs Raid 10 single thread performance
Date: Thu, 11 Sep 2014 10:31:10 +1000
Message-ID: <20140911103110.42449c9e@notabene.brown>
References: <CAEp_DRAVPBvA34kgdjWqO6f6489SbmHQf-dFXC_SwSQd8e0C2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ewWaeXQIlRIcOmK+BpYk4L1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEp_DRAVPBvA34kgdjWqO6f6489SbmHQf-dFXC_SwSQd8e0C2w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bostjan Skufca <bostjan@a2o.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ewWaeXQIlRIcOmK+BpYk4L1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Sep 2014 23:24:11 +0200 Bostjan Skufca <bostjan@a2o.si> wrote:

> Hi,
>=20
> I have a simple question:
> - Where is the code that is used for actual RAID 10 creation? In
> kernel or in mdadm?

Depends on exactly what you mean ... probably in mdadm.

>=20
>=20
> Explanation:
>=20
> I was dissatisfied with single-threaded RAID 1 sequential read
> performance (basically boils down to the speed of one disk). I figured
> that instead of using level 1 I could create RAID level 10 and use two
> equally-sized partitions on each drive (instead of one).
>=20
> It turns out that if array is created properly, it is capable of
> sequential reads at almost 2x single device speed, as expected (on
> SSD!) and what would anyone expect from ordinary RAID 1.
>=20
> What does "properly" actually mean?
> I was doing some benchmarks with various raid configurations and
> figured out that the order of devices submitted to creation command is
> significant. It also makes raid10 created in such mode reliable or
> unreliable to a device failure (not partition failure, device failure,
> which means that two raid underlying devices fail at once).

I don't think you've really explained what "properly" means.  How exactly do
you get better throughput?

If you want double-speed single-thread throughput on 2 devices, then create=
 a
2-device RAID10 with "--layout=3Df2".



>=20
> Sum:
> - if such array is created properly, it has redundancy in place and
> performs as expected
> - if not, it performs as raid1 and fails with one physical disk failure
>=20
> I am trying to find the code responsible for creation of RAID 10 in
> order to try and make it more inteligent about where to place RAID 10
> parts if it gets a list of devices to use, and some of those devices
> are on the same physical disks.

mdadm uses the devices in the order that you list them.


>=20
> Thanks for hints,
> b.
>=20

NeilBrown


>=20
>=20
> PS: More details about testing is available here, but be warned, it is
> still a bit hectic to read:
> http://blog.a2o.si/2014/09/07/linux-software-raid-why-you-should-always-u=
se-raid-10-instead-of-raid-1/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ewWaeXQIlRIcOmK+BpYk4L1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBDtTjnsnt1WYoG5AQJ9ww/+KAWTJwuGzc7uSICr83vL7nsXtfpVHN3V
+vKf9fAyJamZ/bqy6iURkkIIKGOcc9p0jCFgpKEqiJ+2I5Iz+kPuXwHHK6Wp1G0u
9QN/8Vi8wWYAes8mlJTWW2TGA01zQ9vjiT54ir+SzBkdpLJvskUanZHuqB6cQVJX
IVqlWJe68qIwLFAFq52CK4LW6+FEwPeLyRFUAqHJqOxxefu2H0xp5vmS3OTsP4cL
GBfh/oqIF2UPZ8gyVnK0vrkp182PfS89yokndP/68oS7rcivDZyJayXvrI74sY4n
jB6WEGIbrOLdlLHtt6tRWzjoxF5PCsljdnfANFITvyvMM3134n4F9GrAxWIYp6a6
uJ4gzPbQUtNtTeXz5M0/pdc1rr3I0PAOKEILejjcij56HvRto9qpUMAtPezMeOmB
YHrTe4uz7H1M0cb+o2aalhVKUCqthQPRQKwAVLgVplDr7mXr+yyW1ejB98kbNa1X
Qk50MKiv+PBcOctKo97H8IvjCySbPdBdl+SmFsiZWYiYcemBfGunDnw2A7hyXN1S
ZLEPWBCz0smk6K3bS09G+mP4GIYtH+4gBFYxqPgYPGlHft17dd9lMfMuFkH8JB/s
jOy+YPzKORHuh+yaZCmkIyAqI8DCyFA8EJBeiP+kyuaC1HScpzzqPubLV5gEcjX8
TqAM4SyTKU0=
=hrAP
-----END PGP SIGNATURE-----

--Sig_/ewWaeXQIlRIcOmK+BpYk4L1--
