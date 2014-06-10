From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/1] raid5: speedup sync_request processing
Date: Tue, 10 Jun 2014 11:10:23 +1000
Message-ID: <20140610111023.7a2e6ecd@notabene.brown>
References: <EC0B81A7-E03B-442F-B523-4B7154ABDC34@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+8bMCJVgV2JQChVy9mEJi8t"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EC0B81A7-E03B-442F-B523-4B7154ABDC34@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+8bMCJVgV2JQChVy9mEJi8t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jun 2014 17:06:19 -0700 Eivind Sarto <eivindsarto@gmail.com> wrot=
e:

> Ignore previous email.  Forgot to attach patch.
>=20
> This is a trivial patch that improves rebuild/resync speed of raid5 array=
s.
> Instead of having the resync-thread handle the stripe, it now just sets S=
TRIPE_HANDLE and
> releases the stripe.  Allowing the resync-thread to return immediately an=
d schedule more operations.
>=20
> The speedup will increase with more drives in the array.  And it will inc=
rease further if additional
> kworker threads are enabled.  But, it improves with just the default raid=
5d() running.
>=20
> Note: I posted this patch a while back, but nothing happened.  Not accept=
ed, not rejected.
>=20
> Trying one more time.
>=20
> -eivind

I looked through my mail and found you posted much the same patch on 11th
February.
I replied as below.  You never resent (or if you did, I never got it).  You
did reply with some numbers, but that isn't the same as resubmitting the
patch with a proper description at the top.

Your new patch does mention some performance numbers in the comment so that=
 I
a lot better.  I've applied it.

Thanks,
NeilBrown


Hi,
 thanks for the patch.
 When you include a patch as an attachment, I find it easier to work with if
 it is "text/plain" rather than "application/octet-stream".

 As your patch is justified as a performance improvement, please include
 some measurements together with a rough description of the hardware (one or
 two sentences).

 Also, the performance improvement requires that multi-threading is enabled,
 which isn't the default.  Please measure the effect of the patch when
 multi-threading not enabled.
 Maybe we should make the change you suggest be conditional on threading
 being enabled, but we can't know without numbers.

Thanks,
NeilBrown


--Sig_/+8bMCJVgV2JQChVy9mEJi8t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5Za/znsnt1WYoG5AQKyNg/8C7HHN4AtUzc3W92+V/jZGUOcY/fwo/xz
X+u00YGe7ic8V167Bk2Y62zh9hqGOjkhwITzoHEeKAq56DNNNBnugHUfr3X4gMgK
lEU2iHstJ0jPBdP5Od+YLqffKef2/iIBkOVcpyNeYir1EbsE9HgLXxuoaY2nA9Ji
iD1Qk3WIQMItHiY8PcL5ruDom5jFMKPjEVU6bhI1RrX5eAXa2UAtBjIMtoPhEkHc
cw3UZZJrjQtJZkyJpxAVy+xktese+fYu0GP8uF0enFpe315D8PoG5kqgx/Z7o2Do
vOJfjH4LJ5Kn5RBEMr2c7Qn044yu/MTs/XdpbbzGcfM8O8QQqEz0OGxVFHN11/Z8
yD5cxUbjELTWelxbw6dR8K3sheLOyD7UESdWZNs1Z2W0ivRgxVpLnFPyvDQC6Wnr
n86spZkoDfjLqtMKn2drBCEB4qdBrD5fas64S7gWPnm3eXjfTutCU6r1PQEcLS9C
EloSzqsBGLmWmb7WYbeumVf6tvMIigsHEMlFeqnaUVrNZeem2ZwR6fbeAm4JAcXt
uEzUWISZrwIvvFW5/tuCigBZPVRVVOfzkNyT+WGNrQXAQ5RdcqRH15fEuvUlmd+S
rFuPfqwMKLrZZ03VQdR3mtQDmwa/jGYR+UNb34eWFCWe7e5VC1Jf/E5F4JVKokgh
9wuVU8yOH9M=
=ZieU
-----END PGP SIGNATURE-----

--Sig_/+8bMCJVgV2JQChVy9mEJi8t--
