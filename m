From: NeilBrown <neilb@suse.de>
Subject: Re: clustered MD - beyond RAID1
Date: Tue, 22 Dec 2015 15:13:59 +1100
Message-ID: <87wps72k8o.fsf@notabene.neil.brown.name>
References: <56742652.5040304@nasa.gov> <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov> <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov> <8737uv4fz6.fsf@notabene.neil.brown.name> <5678A908.6070401@bnl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5678A908.6070401@bnl.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Tejas Rao <raot@bnl.gov>
Cc: Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org, "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 22 2015, Tejas Rao wrote:

> Each GPFS disk (block device) has a list of servers associated with it.=20
> When the first storage server fails (expired disk lease), the storage=20
> node is expelled and a different server which also sees the shared=20
> storage will do I/O.

In that case something probably could be made to work with md/raid5
using much of the cluster support developed for md/raid1.

The raid5 module would take a cluster lock that covered some region of
the array and would not need to release it until a fail-over happened.
So there would be little performance penalty.

The simplest approach would be to lock the whole array.  This would
preclude the possibility of different partitions being accessed from
different nodes.  Maybe that is not a problem.  If it were, a solution
could probably be found but there would be little point searching for a
solution before a clear need was presented.

>
> In the future ,we would prefer to use linux raid (RAID6) in a shared=20
> environment shielding us against server failures. Unfortunately we can=20
> only do this after Redhat supports such an environment with linux raid.=20
> Currently they do not support this even in an active/passive environment=
=20
> (only one server can have a md device assembled and active regardless).

Obviously that is something you would need to discuss with Redhat.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeM4HAAoJEDnsnt1WYoG503kP/iDsCT87QrTyESOQOKvA621h
0FiS+fuccQ+bMToMSha+rtTCO6WFL6JlioLZ0QZPhG0RQCT1/ZDYbprpueWGsefH
dDoiDH6C3iad9Fai23ZZw5fp0yNzO/1VtJHtLnvf6RvWGKp6Mqb/pjkZxJYkJWvi
CKiUHmPQsbsstYia7aR4U9tWBDyjP8CJ33SGCrZmkVg9KSQc9WZFpN9J2uiwWQEu
9aDYvpHYCjUjiHBjOv/q6nGL94wxOy/Be19DQ/kQu3t+QFgKPexShOL2PDbCjCv3
H6zo9Plm8LAuysINgyWS/NhCxoCXfaxRJiID0BFFgaoyH32SFSoTtAHNSj3hG4db
SoylfOC76VYzupVQygost0lARo8lGROdxSBh4NtjCz7VDkTgIJGOoLUylu247j6u
eRZ9/rLsW2Eo+MESIQTHDX6iTBUb8zu9Pf/m7qOEAH9E9gp/BntOLHx9ZSBmZjwc
QDdSsTjcf7rQB4chddOgcFvBNTYpVmLyYG8lNooDA6mBr2cfau1r0/zsjrygAx1F
ECWmGfgzYQdGr/QVul+X2LoEdO+UxlZvaOGa4r+phGwH1U5j0T5b3dZJvUF8aH80
FxfJwlnXyqj8zNFrklCP8V3tNgPsngYvNqym9tqGlI5yzSeF4isFarM4Fyaaw9DQ
31UJeWfV+h7C7FmRUYQZ
=FW/B
-----END PGP SIGNATURE-----
--=-=-=--
