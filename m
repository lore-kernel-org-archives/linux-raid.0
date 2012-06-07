From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/8] raid5: add a per-stripe lock
Date: Thu, 7 Jun 2012 16:35:22 +1000
Message-ID: <20120607163522.71c68e23@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080300.519377228@kernel.org>
	<20120607105410.415d9fe6@notabene.brown>
	<20120607062939.GA779@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UeBpQbwLqb55l5_LgFUa77k"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120607062939.GA779@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/UeBpQbwLqb55l5_LgFUa77k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jun 2012 14:29:39 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Jun 07, 2012 at 10:54:10AM +1000, NeilBrown wrote:
> > On Mon, 04 Jun 2012 16:01:53 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > Add a per-stripe lock to protect stripe specific data, like dev->read,
> > > written, ... The purpose is to reduce lock contention of conf->device=
_lock.
> >=20
> > I'm not convinced that you need to add a lock.
> > I am convinced that if you do add one you need to explain exactly what =
it is
> > protecting.
> >=20
> > The STRIPE_ACTIVE bit serves as a lock and ensures that only one proces=
s can
> > be in handle_stripe at a time.
> > So I don't think dev->read actually needs any protection (though I have=
n't
> > checked thoroughly).
> >=20
> > I think the only things that device_lock protects are things shared by
> > multiple stripes, so adding a per-stripe spinlock isn't going to help r=
emove
> > device_lock.
>=20
> This sounds not true to me. both the async callbacks and request completi=
on
> access stripe data, like dev->read. Such things are not protected by
> STRIPE_ACTIVE bit. Thought we can delete STRIPE_ACTIVE bit with stripe lo=
ck
> introduced.

Please give specifics.  What race do you see with access to dev->read that =
is
not protected by STRIPE_ACTIVE ?

NeilBrown

--Sig_/UeBpQbwLqb55l5_LgFUa77k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9BLqjnsnt1WYoG5AQJziQ/+KXbVDBE/A0xGkVZxrygbPqymfujrQ3g9
/nRS54enK6U5lamBd0rPmrPCfK3dkYlt4fP2S5zUDZV7FvykS0PpPl78N9qdIjmT
faRkkLbND6l/OmgwtN7zc0Zt2e0WAVrW+zh+ChZyO/sZg+xNisLOMMJZ9eSg/jeC
YXVD4Nf8pHnu7VwI5LdqZ+AiH+tb8TA0fDC7zzT4t6Sm2e5nOzUuEZjrwfSgM5gr
dUFRHlgIpY1T7e6gBfqgu5yq1xAuU0wE7f6KXRmWjuxsI+0YIgogzkam/PAJEsFT
mLCrhv63hwm5mQeletpVOvYzyqQ1kZw2hFxvuYsD+3gl7wFL4D18BlXY6QT8Uk0g
Do/TqehSXIxCbjJYtaAJwZw4sCJ0nkTY/48vc6/sJ+mSrH+kcc6+Fib7rmVQmzl0
UvDoPCUc+n0GyEOq7LhVLZOHgR+SUs7KftUoNmLVt5NoK62qCFkAkUyszMIm0h84
Nb081LpNaUoaxgxAzDOlo1IGLGqT6VNolFCDZgneRKxbOI8p+qpGG/SsUeFa2rlB
ht+axvfqX0Juq4z+9N3ky4fbVU6SmKVKAEOWQZfcWIv4hkd4FMtecNyOdY2OI7W+
gL1hg2Z4/O36vOvI2ZDa7Y81UUSLD4iiPbkeURAKCzglkXwEaCsfrHXveGVnevIa
kP/ME6zi0IE=
=gXIu
-----END PGP SIGNATURE-----

--Sig_/UeBpQbwLqb55l5_LgFUa77k--
