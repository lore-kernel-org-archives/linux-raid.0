From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 02/14] md: move two macros into md.h
Date: Mon, 27 Mar 2017 20:52:24 +1100
Message-ID: <87wpbb6o87.fsf@notabene.neil.brown.name>
References: <20170316161235.27110-1-tom.leiming@gmail.com> <20170316161235.27110-3-tom.leiming@gmail.com> <87tw6j8be6.fsf@notabene.neil.brown.name> <20170324165325.nek4kb4yezz2xmow@kernel.org> <20170327091553.GF6879@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170327091553.GF6879@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 27 2017, Christoph Hellwig wrote:

> On Fri, Mar 24, 2017 at 09:53:25AM -0700, Shaohua Li wrote:
>>=20
>> I had the same concern when I looked at this patch firstly. The number f=
or
>> raid1/10 doesn't need to be the same. But if we don't move the number to=
 a
>> generic header, the third patch will become a little more complicated. I
>> eventually ignored this issue. If we really need different number for ra=
id1/10,
>> lets do it at that time.
>
> Which brings up my usual queastion:  Is is really that benefitical for
> us to keep the raid1.c code around instead of making it a special short
> cut case in raid10.c?

Patches welcome.

They would need to handle write-mostly and write-behind.  They would
also need to avoid the assumption of a chunk size for RAID1.
Undoubtedly do-able.  Hard to say how beneficial it would be, or how much
it would cost.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljY4NkACgkQOeye3VZi
gbmpVxAAqKNg+kIzJKQ41rcH8t7TAe9n0SXc223FGYgxY+bEpkLmEUrPIE5rhijj
CkfmNko7+JuJcmdHxf7p42iWGngfJvULpqZ4g/SWD3G0bUyOwvaSEg3ayJYoyj5H
tMY7QGyAgS9xAdfOwRem0Z35paLJEw9AFZcoRR/CBtpZY9D6QfLeiqhHEhkbhedW
YHxbbBPbB441mxf57h4Ap7duKDXD6XGmgjKGCpwI2Css8PMsvzA3uitpvTjcX8px
x727GdeKwa+uWt6ag9fqFBAHPrz37RVPRhOrD2Ew88ZwQEWbgwjOS9Kas02jw9VY
p5npEpybzvjcT3ZzqMTWgIac7ZFojLAeaqDsRBW2MHoJjM/w17qlcmc47/F3vJcb
KALHxj7ji0rG4IbrNZa9QoAd+zvXdQs4S/r9AsEajRf+vg9lqCrw9HqJlJPzXgac
AwSCOF/B/aKBf7vm5dBnot7xU87wTlRSM0jQ8uyx9uTAHv5hefAFGo86c1r3Z1IQ
b3pIyhQiq+QWIMFsiz6eaHNfZrkBR0zreOwQbmn4BqC03KVdxkTdiNOoD3MdLMvR
AdvXRmKYAr2BTIaz8WRIVxldbtGnoNbNHUbB/BrXqrR0bkXsYxdZzvPZTdXJSTnZ
jqSnaLVyZvbbBYuzsZRTbjB/4PYkcahARe/FmZ2GhkP+vOiTOng=
=hQbl
-----END PGP SIGNATURE-----
--=-=-=--
