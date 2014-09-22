From: NeilBrown <neilb@suse.de>
Subject: Re: Please advise, strange "not enough to start the array while not
 clean"
Date: Mon, 22 Sep 2014 13:19:40 +1000
Message-ID: <20140922131940.58f97093@notabene.brown>
References: <CAAOsTSkaFdum4LD8aOkOsG-f45fTjRSUPb=EqguJi4yaNjcSdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4V18C6a50WTtUMnpl8WU=og"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSkaFdum4LD8aOkOsG-f45fTjRSUPb=EqguJi4yaNjcSdQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?UTF-8?B?SG9ybsOtaw==?= <patrik@dsl.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4V18C6a50WTtUMnpl8WU=og
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Sep 2014 04:11:20 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:

> Hello Neil,
>=20
> I've got this situation unfamiliar to me on RAID6 array md1 with importan=
t data.
>=20
> - It is RAID6 with 6 devices, 5 are partitions and 1 is another RAID0
> array md101 from two smaller drives. One of the smaller drives froze,
> so md101 got kicked out from md1 and marked as faulty in md1. After
> while I've stopped md1 without removing md101 from it first. Then I
> rebooted and assembled md101.
>=20
> - First I tried mdadm -A --no-degraded -u UUID /dev/md1 but got
> "mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started."
> so I stopped the md1.
>=20
> - Second time I started it with -v and got:
>=20
> mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
> mdadm: added /dev/sdi1 to /dev/md1 as 1
> mdadm: added /dev/sdh1 to /dev/md1 as 2
> mdadm: added /dev/sde1 to /dev/md1 as 3
> mdadm: added /dev/sdk1 to /dev/md1 as 4
> mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
> mdadm: added /dev/sdg1 to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started.
>=20
> - On third time I tried without --nodegraded with mdadm -A -v -u UUID
> /dev/md1. This is what I've got:
>=20
> mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
> mdadm: added /dev/sdi1 to /dev/md1 as 1
> mdadm: added /dev/sdh1 to /dev/md1 as 2
> mdadm: added /dev/sde1 to /dev/md1 as 3
> mdadm: added /dev/sdk1 to /dev/md1 as 4
> mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
> mdadm: added /dev/sdg1 to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 5 drives - not enough to start the
> array while not clean - consider --force.
>=20
> Array md1 has bitmap. All drive devices have all same Events, their
> state is clean and Device Role is Active device. md101 has active
> state and lower Events.
>=20
> Is this expected behavior? My theory is that it is caused by md101 and
> I should start array md1 without it (by for example stopping md101)
> and then re-add it. Is that a case or is it something else?
>=20
> Thanks.
>=20
> Best regards,
>=20
> Patrik


The array is clearly degraded as one of the devices failed and hasn't been
recovered yet, so using --nodegraded is counter productive, as you
discovered.

It appears that the array is also marked as 'dirty'.  That suggests that it
wasn't shut down cleanly.
What does "mdadm --examine" of some device show?

You probably need to re-assemble the array with --force like it suggests,
then add the failed device and let it recover.

NeilBrown


--Sig_/4V18C6a50WTtUMnpl8WU=og
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVB+VTDnsnt1WYoG5AQIlEhAAnfxK9+0ORcOmPPZ4bcVw7QTNQHtsyRV4
XunEkMUtAg+BmyIu7FZJrBIyItlA55WZ/07lR/8olrb7h6wRaGuByo4PpgaPiIbk
x7ChFP5VXzRcg9CGQr+ar7APwd2+kfHyV5Bwxn7kwPJdZQZBGRkCxNObFyhoNzJJ
7/qVh/PjokR8nggPP1KDVCVx05FJLYaGsW0eWlkZJpj+UD6HZrr/KjrvMxmXvj2u
CKXzRJz7B8reYShjFFQdz0L5I84EYuNKi0YWJJ0jBUBjAzGy2KcQNb6u8q32CwNk
9o/k40/svRrlfE2ybhvTignJZaYv3CCD+l1gCq6r3uytvEozbGOaK9/oNCDnUNc9
2hdQyJV1RInnhqIbrnIt+8VDx3s5Jb76fITnfWQ/4cX14Z1/RjjM0g0ZDTBbBYeA
4bh9DfKi9jycCbUU/UZGLcedzurbyAy2uxX752OhaPIkIRVIugm4Gx7JKbnlIiqI
kvGeGvhUIyNQeKbcDRJMPljaSRqJHP2xzCyybSTcl/lakvQJ3qG8Dmfqt6D2JPPN
O6nLb2qRpTyvSHck7FzHWqJkmjthSXK7URftjk4A9ORH+NHkY4i4PzRJB9RZ+E6E
mwRhc1qaI3drsH1eObTLnPhW7g2Ij0AfVCyg2QDg01zUvBmWAXzE4wpJ2SinHlgF
+wvDFjf+gb0=
=UUDh
-----END PGP SIGNATURE-----

--Sig_/4V18C6a50WTtUMnpl8WU=og--
