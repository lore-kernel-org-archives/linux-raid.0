From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 - data integrity issue - data mis-compare on rebuilding
 RAID 6 - with 100 Mb resync speed.
Date: Thu, 13 Mar 2014 17:19:02 +1100
Message-ID: <20140313171902.2a767027@notabene.brown>
References: <13688C12F44C7C428726663F950CA253094ADEC6@venus.in.megatrends.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8T89ykSf9hKvC0yIil=Kj_t"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13688C12F44C7C428726663F950CA253094ADEC6@venus.in.megatrends.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manibalan P <pmanibalan@amiindia.co.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8T89ykSf9hKvC0yIil=Kj_t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Mar 2014 13:09:28 +0530 "Manibalan P" <pmanibalan@amiindia.co.in>
wrote:

> >
> >Was the array fully synced before you started the test?
>=20
> Yes , IO is started, only after the re-sync is completed.
>  And to add more info,
>              I am facing this mis-compare only with high resync speed
> (30M to 100M), I ran the same test with resync speed min -10M and max -
> 30M, without any issue. So the  issue has relationship with
> sync_speed_max / min.

So presumably it is an interaction between recovery and IO.  Maybe if we
write to a stripe that is being recoverred, or recover a stripe that is bei=
ng
written to, then something gets confused.

I'll have a look to see what I can find.

Thanks,
NeilBrown

--Sig_/8T89ykSf9hKvC0yIil=Kj_t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyFN1jnsnt1WYoG5AQKSNg//Q4CfeIPKaANj/Vk+Fvd4n9SFt6yM4N2x
Dr+CTvLCbiUllbbJ7qnPXoKi6RnEBXkej4abRrfaRtY4X0cT5KZIvKjTlRdFsRG6
o/6/bF888mze0pJ97jj9HHaCxgL4Rfzzl4QHbFJQpAPkBu2TNHUo525kPN2a9Yrc
ZjosVooxP3JBbL9fUgIPvownkuK8ogs5j+atkl+08S9Q1YtTqMXVC1i2GrVdHp+U
vPHc6NUkLbmQRKBCbkfrfFbAH6iS/HLtDSsZZKrMtSqwdAd7GjeEFf9ot+FjkVyb
RGGp8Jpy+ofFIurrylPsydNpWa1Bx45mQojrEM8gkcxudGrJ8Bdz3oKo4acF6RBn
ub3aPgXkROqHKyJ82Jrf2+U/isI2Ptm+q2pTbZGjdt7lbSKYW8ebUBYUX5a6B7qt
EBvJaBmdxmSUwwh9GDCAxhSc+aDsWCx9+1NXwaknQPQWE785k9oM6fv5N+e3f5hS
3QC+pVA4kDsTka/tZZqvx/sUpWoIh6UOI6r3H0iUkqzQM0FxJBwCH3+QHUYF0ndl
5Hx/I8hfXtqd3vus5x68ylXovm9lYUKxYvDIAcO/0KmGbJCKcYcISs+4qlfJyfu+
GzCsCSKFGkSmJ1W+S9y4Cy7/VPmhsTVeBfmuVJ7KrkecxcaTG3bgFugFTSidDvzw
xF7FoR/pn/E=
=9Xy2
-----END PGP SIGNATURE-----

--Sig_/8T89ykSf9hKvC0yIil=Kj_t--
