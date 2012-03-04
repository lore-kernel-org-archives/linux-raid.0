From: NeilBrown <neilb@suse.de>
Subject: Re: md raid5 fsync deadlock
Date: Sun, 4 Mar 2012 20:20:13 +1100
Message-ID: <20120304202013.78a2f65c@notabene.brown>
References: <4F4EB53C.6060901@redhat.com>
	<20120301125325.2b17e5f8@notabene.brown>
	<4F4F3753.80505@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Mz68EeOHjYr7iSCw2UcJvXS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4F3753.80505@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Mz68EeOHjYr7iSCw2UcJvXS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Mar 2012 09:46:11 +0100 Milan Broz <mbroz@redhat.com> wrote:

> On 03/01/2012 02:53 AM, NeilBrown wrote:
> > On Thu, 01 Mar 2012 00:31:08 +0100 Milan Broz<mbroz@redhat.com>  wrote:
>=20
> > Are you certain it is a deadlock?  No forward progress at all?
>=20
> Seems so, it was for several hours in this state without progress.
>=20
> > What is in md/stripe_cache_size?  Does it change?
>=20
> > What happens if you double the number in stripe_cache_size?  What if you
> > double it again?
>=20
> stripe_cache_size was 256, I doubled it to 512, now
>    stripe_cache_active is 390
>    stripe_cache size is 512
> and no progress.
>=20
> With stripe_cache size 1024 it survived few iterations of fio run, now it=
 is
> locked up again:
>    stripe_cache_active is 921
>    stripe_cache size is 1024
>=20

That definitely looks like something getting stuck inside RAID5.  There are
390 (or 921) stripes that should be being processed but they are blocked
waiting for something.

I would suggest modifying the 'status' function in raid5.c to print out some
details about the stripes in the stripe cache.
You would need to spinlock device_lock, then walk through each chain from
stripe_hashtbl and print out the 'state' and 'count' for each stripe-head a=
nd
flags and various bio pointers from each dev.

That might be helpful.

NeilBrown

--Sig_/Mz68EeOHjYr7iSCw2UcJvXS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1MzzTnsnt1WYoG5AQJYRw//eUf7VpP+yL+fUA1O291/YoQqx+yZB2US
5d+5B76bTG6yM/cubAPr3fSv0wpXvwYB0sUKNVw/ncMD1VHry+XcTVZEF3nra0VI
yNIC3HDfwOvRGtRrWrzcKBbTDBiRtvJrt5uhtZrzcLoxt/ka1Y/4W/IA23Ao/Dyi
09gw6VQQQdkQwRcyuSOY8TNFxyGTKoS6+asj9IaagXODuYFEkLD7Z1XvsyXjpjsg
5c2+Qq4bNriozPZGBrTafkZ3QTRM0scUAKMxgiV3cYlqweeXUjhQHI5LylQQpHFj
T3rxpm1/fPPSN31ugsVI+O5Kn0e/eIPbsAFoRZBiaeb665XJ1nqe+bOwSb0nxXWw
MZ3UEPk5agwL6n5iiH6L9TgwJRMXYHbrW7tJkE2E4JKhw+ynEqd5paPD8L9u7gzI
FnvRVAp/g8VUSExavV0AVcnbEKA8VyBxlemrUtjvF+b47O1hjq95NYGk2++NT4Tx
BRC6h3MUmjyW0/ikKEpqhtztDh1+K5wAv4EkDiThXRxzwEnZam+wfhTsO5ddvPoo
K3eAUEENiQX75wMTVVcITYZdGyGuPVRMkwkQn6x2BeOJOJlvksXB3LRHDTSzWWcW
GgBtizZ7f3bZnw5RxyFAi+Jw79y980SINdgaTbssfk3CbOD9DvIZorXKHSNut7/U
UOGII0okrks=
=fO2V
-----END PGP SIGNATURE-----

--Sig_/Mz68EeOHjYr7iSCw2UcJvXS--
