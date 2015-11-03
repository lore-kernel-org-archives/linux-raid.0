From: Neil Brown <neilb@suse.com>
Subject: Re: performance issue
Date: Tue, 03 Nov 2015 12:34:25 +1100
Message-ID: <8737wnkgri.fsf@notabene.neil.brown.name>
References: <1092031595.20151015153830@oudeis.org> <87si5bvcj4.fsf@notabene.neil.brown.name> <43246687.20151024181541@oudeis.org> <20151024213139.5b20dec6@natsu> <16514313.20151025202337@oudeis.org> <87a8r6g188.fsf@notabene.neil.brown.name> <5637E9C9.70600@oudeis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5637E9C9.70600@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer =?utf-8?Q?F=C3=BCgenstein?= <rfu@oudeis.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 03 2015, Rainer F=C3=BCgenstein wrote:

> On 25.10.2015 21:08, Neil Brown wrote:
>> mdadm --grow /dev/md0 --bitmap=3Dintermnal --bitmap-chunk=3D256
>
>   not sure how to specify the chunks size:
>
> [root@alfred ~]# mdadm --grow /dev/md0 --bitmap=3Dinternal --bitmap-chunk=
=3D256
> mdadm: failed to create internal bitmap - chunksize problem.
> [root@alfred ~]# mdadm --grow /dev/md0 --bitmap=3Dinternal --bitmap-chunk=
=3D256M
> mdadm: invalid bitmap chunksize: 256M

I guess you have an mdadm version earlier than 3.2

try
   --bitmap-chunk=3D262144

which is 256*1024.  The number is in K.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOA8hAAoJEDnsnt1WYoG5chsP/jrdr7OWtv+lDHYoVnel3lAs
TMKnjQjzx6NUNZnvj3T+COLSqLgmb8AIPMQl0l1Q0yezI8jo9A6VmbqHd9w/7yUL
HralN1D/RI533B28lsIwPQsdPPd2XONVkNMb8ym78lZ2OPw+RdR+BOUrW6tRRQIf
gEBikVS7osirbq1agGmbaoFzmnit6wp39C2ASY6FHiEkpk14XXzbyaX9rv5XcTiU
gO+UVsprsB2CWvJWTPXUXr4dTPShw2dyPRdCx4XQRBJCJ5HXRk44dISw29BAng9I
PC1iiWLrBCVLSQCjg8pRtEMC4/vUMUIQSNjhkrRVn4joNx0iDiqlG9HrOEXK2der
TZTXwQBqN27PByoZIE3fztg67uxApw32V4IqLBeTxx1DQ2+t0zAdfOONoQSIJ/3L
RmkmaOhjShZx989Tn2DT0QeJKifqWm+OhM2Psj5R8ZdB6PGEAiM7W9RNlW1sTI0e
qn/VMT1/9doOj+xeb94nCGL1IEuxsGHMfBDPtgUq6TD7dW4Pg4DaV9/bTOy0PcHh
LHAsEsl2XuoZu3GH8IOgLgdQWLfEiJhNJUGXaV0RwrpN74eJEr80tYL2gchVM3ee
adE/03Tlv1fK0e0gp3IndkQGtxgMMGeTjauevNu6WGKkwDVDW3ArbizNI1k/LpQd
auUnaOodib9f8HwWyYrF
=41Cc
-----END PGP SIGNATURE-----
--=-=-=--
