From: NeilBrown <neilb@suse.de>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Mon, 5 Nov 2012 16:22:27 +1100
Message-ID: <20121105162227.7bc5c103@notabene.brown>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R2yV1GOCrZNhkI6jyWRsDrr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/R2yV1GOCrZNhkI6jyWRsDrr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Nov 2012 05:51:18 +0100 (CET) Mikael Abrahamsson <swmike@swm.pp.s=
e>
wrote:

>=20
> Hello.
>=20
> I have an ubuntu 12.04 system, (running ubuntu kernel 3.2), and I have a=
=20
> drive I want to swap out that has a lot of offline uncorrectable block on=
=20
> my raid6 mdadm-raid with superblock v1.2, the drive is failing.
>=20
> I remembered Neil announcing the "replaceable" option, and it seems this=
=20
> came in 3.2 according to <https://lwn.net/Articles/465048/>.
>=20
> Has this function as implemented in 3.2 received a lot of testing and can=
=20
> be considered safe for production use, or is it still as said in the=20
> email, for testing only?
>=20
> My kernel:
>=20
> 3.2.0-32-generic #51-Ubuntu SMP Wed Sep 26 21:33:09 UTC 2012 x86_64 x86_6=
4 x86_64 GNU/Linux
>=20

Try it.  If it works for you, we can be more confident that it is stable :-)

Seriously I think it is safe to try but I won't promise that nothing will go
wrong.  I do promise that if something goes wrong (which is fairly unlikely=
),
I'll do my best to help you fix it, and think it is extremely unlikely that
the experiment will cause data loss.

One thing to be aware of:  if you need to reboot during the replacement
process, the mdadm you have installed will not be able to put the array back
together properly (it will leave out either the failing device or the
replacement).  The mdadm in the 'master' branch of my git tree can do this =
so
if it comes to that, there is a way forward.

NeilBrown

--Sig_/R2yV1GOCrZNhkI6jyWRsDrr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJdNEznsnt1WYoG5AQLUnRAAqdTVOQmu5IL2W9oK8W2it72/Y115JS6I
azVEjoEf2pMNzbyW6yN9lDnmP+UbCGO65dg2t2QsfsY72G4x1fRkzkUaW79dMAWA
ySA3VkNmz3R62SolsuukivXA8rErWReGJSn92jADThuA6Q8F7/tPC0g62wze6rFY
vcXKe48IMDMf7NTLQJhoG7pXNLzwz7JNh8bd9DA22zqJMmqRJOTrVCQ8mSFB+ufI
JGJ+/d5Nl6hfrdqeqmiaHGctNMtMpkyGeJSdQ9DY3WJgv0OC95Kgl27paPDRo8YC
7m7i54vlHJ6bFk1DyItWc1hEJhWNWGpjyTv2LFc0bdKADll62R1oDcRsxR6DQsKI
kNCQYiHUSQD0cJWo3N29pq2RdFcacDLt8XzNqezcdXU+NmX66xoU6INOAjcVxiwb
YQf+aK/3O5vzF4nKNJP0YYoQtZ4t9Ai/OUhuw8iVXfYp5WhBOyeIUjX/YxyWqWXI
jPPtkStqeBNVPXiuN+QaScU/FgHbPSAMvIIOcPSV/n7ngGff9SmqOJXL+EivRMFz
2wDK3gwdvL+vD3YVyRJE9/nodvEILvCgEX2oy/ukzqyBU4+ijNavTZ9oD5FD92Q9
Xuo3sD2rw93ZmGQaIYSG1FGlb1VFpxo5UFJ3NPnGKGMLoImZEvzcUYx3d2KcbT8E
WmlczfqfMMw=
=JosN
-----END PGP SIGNATURE-----

--Sig_/R2yV1GOCrZNhkI6jyWRsDrr--
