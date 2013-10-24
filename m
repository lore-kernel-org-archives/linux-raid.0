From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/2]raid5: set bio bi_vcnt 0 for discard request
Date: Thu, 24 Oct 2013 12:58:50 +1100
Message-ID: <20131024125850.76eff7da@notabene.brown>
References: <20131019065028.GA10670@kernel.org>
	<yq14n88h0lk.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/STaXOmByzoNdu2udApmvL56"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq14n88h0lk.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--Sig_/STaXOmByzoNdu2udApmvL56
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Oct 2013 04:07:19 -0400 "Martin K. Petersen"
<martin.petersen@oracle.com> wrote:

> >>>>> "Shaohua" =3D=3D Shaohua Li <shli@kernel.org> writes:
>=20
> Shaohua> SCSI layer will add new payload for discard request. If two
> Shaohua> bios are merged to one, the second bio has bi_vcnt 1 which is
> Shaohua> set in raid5. This will confuse SCSI and cause oops.
>=20
> A discard bio does not have a payload prior to the SCSI command being
> prepared so vcnt should indeed be 0.
>=20
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
>=20

Thanks Martin.  I'll be sending this to Linus shortly.

NeilBrown

--Sig_/STaXOmByzoNdu2udApmvL56
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmh+2jnsnt1WYoG5AQJ4bxAApwl33HV+6IHCh3YgxGj80Zhyi0eCzZB2
ItP6NPhpHdbDPJN2hOWfp/AsDNDKodrszjA+JBO5OghZY7Yw6tskGHTstSa82lxD
1fgS7sn3RdVMmu3T1wB4gUkL9Mw02hbJHVQosLWKZGVWUzMdEbgmi/PrJJGu/rqZ
FOo3xXd7mC/qU0tP+OdX13xesqWi1k5mBOM39of7baAvtw+DsMonmKhHKv/WA/XY
0TZtnUsZDY7AnYcgQll5EsW8/RvGcX1HBLJST/7xQjfhCK+SpavOg8vdovaBdwyy
HtK5BFtD4MPd93TM2SvqU8sH77G98GlkSqiFCV0x3g8f6+5B5dKPEttEfNgOcbbP
TdKJbs0gOE6Ff2XSSDcmcZrHIUYotXn4RuRAOYjjhHJauLfnvWdB9ggIBn6X6grD
bT0t8lLO2a3hmBpCZuwfonWscSHFU88WvFQI37ZKDAjQsw1grWpjO/AL4rqgX84F
q3yWAXdgqKhw+hQXneuw5pw+X/D1hpjiCoins38c0fX9bxL3lfR+4iSljuqFy5Ia
iZP8PQlWwyttjDJ3pBxt/qawBhFF5jGDVhnVOYnr2NIyiNYWwcQxFQ8JIjAo6KFL
CfZ8on7Dhwx3eGGKzpyhAfc8bQnFeDW0ehti8WdJz4ALJjI1Og7YhJhG7wEKX4C2
VX9eDaXxuYk=
=M/ld
-----END PGP SIGNATURE-----

--Sig_/STaXOmByzoNdu2udApmvL56--
