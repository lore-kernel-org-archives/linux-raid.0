From: NeilBrown <neilb@suse.de>
Subject: Re: Data corruption after resizing partition, when using bitmaps
Date: Wed, 20 May 2015 15:31:04 +1000
Message-ID: <20150520153104.7ac99de1@notabene.brown>
References: <20150519141239.GA5309@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/RJ9K6VRRdb.uCOwAXIryxV3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150519141239.GA5309@psychosis.jim.sh>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Paris <jim@jtan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RJ9K6VRRdb.uCOwAXIryxV3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 May 2015 10:12:40 -0400 Jim Paris <jim@jtan.com> wrote:

> I had a raid1 mirror consisting of big partitions on two disks.
> The first disk was 2TB, partitioned like this:
>=20
>   [--sda1(128M)--][-------sda2(~2T)--------------]
>=20
> The second disk was 3TB, partitioned like this:
>=20
>   [--sdb1(128M)--][-------sdb2(~3T)------------------------------------]
>=20
> sda2 and sdb2 were part of the array, which was only ~2TB in size due
> to the smaller disk.
>=20
> I realized that I needed to add a BIOS boot partition to the 3TB disk,
> so I removed sdb2 from the array, and repartitioned sdb like this:
>=20
>   [--sdb1(128M)--][--sdb2(1M)--][-------sdb3(~3T)----------------------]
>=20
> Then I added sdb3 to the array.  And lost all my data. :(
>=20
> What happened was that the last sector of the big partition did not
> change location.  So the metadata (0.90) at the end was still present.

This is one of the big reasons why 1.x was invented.

> Adding sdb3 to the array was considered a "re-add" because the UUID
> and array sizes still matched the array, even though the partition
> itself shrank.  And the resync was thus guided by an out-of-date
> bitmap, which caused very little data to actually be written to sdb3,
> so half the reads from the array started returning junk.  Once the
> filesystem got involved, the result was rapid corruption.
>=20
> If I had not been using write-intent bitmaps, everything would have
> worked fine.  I only recently started using bitmaps, and never had any
> problems with adjusting partitions like this before that.
>=20
> Perhaps mdadm can be more careful here -- for example, maybe checking
> the actual device size and not just the "used dev size" when
> determining whether to trust the bitmap.

It is perfectly acceptable to have the various devices in an array of
different sizes.  Unfortunately I don't think there is anything that mdadm
can usefully do here.

Thanks for the report anyway,
NeilBrown


>=20
> I wrote a script (attached) to recreate what happened, using some loop
> devices.  It works fine if BITMAP=3Dnone, and fails with BITMAP=3Dinterna=
l.
>=20
> Jim


--Sig_/RJ9K6VRRdb.uCOwAXIryxV3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVwcGTnsnt1WYoG5AQKfCw//f8un5mFRa9OFwDCL80yI+quQKlQI55pE
bv0CZK5+M9aHVrL8SklRc1zpWE5i7O66u9aMYfjZrCYpUJJ/11n85Uxrc9/dmQpq
b0LU0UzS7uzXuR+vGzCpcR84vTklUIP+mxgCuqORQXliCbNQKhpTZTIxJWErY5Pc
JML/Pq7/wDaRO5R1ILENrfN2U8maMu58AbhQjZcs72RO5PBUG4YOMwsAyDKk7F86
qcEfggsvAkyeKOCYirw8+vzjSQ0diWU4hnCrxxomrq0S942ccFeS2j10RR4VDke1
36l6NBrPgi5AB1TyegV6Wf18ortlYpvmzp/2NGnV097TGtOn4YAUUTAxpFeM6dh6
r4pV0S/SzDczjda6ymJkAqgzr8RPD+nS9arVermsZCEonYHdgFVyiFFNsP2e+WU/
a6DbdryfELfMxzGuyOMRukBKx8TrXYAzxwr0GSDBZOsX8gxRkOCdWq6bRw3x2oCt
ZI3sMz7GSthbZxBLIjGsGMVxBaxUwJHtE2DS0UcjZkq75eDLFR+P49Gmm7ZUIcQx
/OnWTRCiEwXSHK9L5quhkk8gGGKg2VjME5+a+4k6aefgY3daiaF0X4Xke6CIt4Za
5TOuxSyIH8lki2GeFP8oL3SSXLyFuNzJYV3NMbVAr1sR823g0FsuIRiS78HIKQl/
aCXeub6tfiE=
=mc4J
-----END PGP SIGNATURE-----

--Sig_/RJ9K6VRRdb.uCOwAXIryxV3--
