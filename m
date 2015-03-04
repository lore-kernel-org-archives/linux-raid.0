From: NeilBrown <neilb@suse.de>
Subject: Re: Last working drive in RAID1
Date: Thu, 5 Mar 2015 10:26:22 +1100
Message-ID: <20150305102622.016ec792@notabene.brown>
References: <54F7633F.3020503@gmail.com>
	<20150305084634.2d590fe4@notabene.brown>
	<54F78BD9.403@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DIyDPcudOxUpEzyDPh//BbU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F78BD9.403@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/DIyDPcudOxUpEzyDPh//BbU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 04 Mar 2015 15:48:57 -0700 Eric Mei <meijia@gmail.com> wrote:

> Hi Neil,
>=20
> I see, that does make sense. Thank you.
>=20
> But it impose a problem for HA. We have 2 nodes as active-standby pair,=20
> if HW on node 1 have problem (e.g. SAS cable get pulled, thus all access=
=20
> to physical drives are gone), we hope the array failover to node 2. But=20
> with lingering drive reference, mdadm will report array is still alive=20
> thus failover won't happen.
>=20
> I guess it depends on what kind of error on the drive. If it's just a=20
> media error we should keep it online as much as possible. But if the=20
> drive is really bad or physically gone, keeping the stale reference=20
> won't help anything. Back to your comparison with single drive /dev/sda,=
=20
> I think MD as an array should do the same as /dev/sda, not the=20
> individual drive inside MD, for them we should just let it go. How do=20
> you think?

If there were some what that md could be told that the device really was go=
ne
and just just returning errors, then I would be OK with it being marked as
faulty and being removed from the array.

I don't think there is any mechanism in the kernel to allow that.  It would
be easiest to capture a "REMOVE" event via udev, and have udev run "mdadm" =
to
tell the md array that the device was gone.

Currently there is no way to do that ... I guess we could change raid1 so
that a 'fail' event that came from user-space  would always cause the device
to be marked failed, even when an IO error would not...
To preserve current behaviour, it should require something like "faulty-for=
ce"
to be written to the "state" file.   We would need to check that raid1 copes
with having zero working drives - currently it might always assume there is
at least one device.

NeilBrown


--Sig_/DIyDPcudOxUpEzyDPh//BbU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPeUnjnsnt1WYoG5AQIGaQ/7Bu6l2VcaMcPE+Lte1BRzgl3kVUxdMyem
p06HjYkdMCwOAW4Q7w6o2mXhpE5Fr8SLd8EG7Omh7s+sqmS4YGTHkwwDZmXWYwXb
fvdwokZFIMfSvFYOEP0Rsb0a3+ofC/6mAGyfy0z1+p2Gpq1qaZ2KXQXJL2/zswAL
Gz6OjGL9VbC0SgNFJz0Q0dEcwsFDXj4q1QzU9MImEb0cfN6RPadzJKd9r77WHmqT
peiO/c05/4Oi9sOIxdtnMW3T3Mqkkqi2F7NvzVORYB4lMozaGz5o9McNejgOs8aH
ajp/QguG+dPbE1VwesNb4xRhZdUhgCsfUvRKZvNB/fOS1ks1L37wksL90HVMi9g/
wg+1MjD87AZKHOtV44zTL9sGIoJ5xFJckuZ2n8SdUnOHshBYfiJa8rNW5bpJJduG
6oSi7E9msRqf0izZqf1Kw/qzWh+QgpoypmlETTvFMIYMq+3863slZYp75qJ2aZpe
nKGsvLBm1Vla/U+rbztOjwfMN1+R+Eqjb85EziCLbS25y1KSzO84AB4DoLMWOyui
YUohJMPTBsM/uwNn2YrgsWcIBaThFr+1aKzEDueBaTKKWn48HrMzW8webjoKS0ym
5EE8Bxb0r9QAdvJoSXQUPopVcalmTLriZu5BQ3wcDF9Op0/BAC9gZg7nQXmCt40Y
dsep4LJYQ6s=
=ckFo
-----END PGP SIGNATURE-----

--Sig_/DIyDPcudOxUpEzyDPh//BbU--
