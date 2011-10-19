From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md.c: trivial comment fix
Date: Wed, 19 Oct 2011 17:23:49 +1100
Message-ID: <20111019172349.499b746b@notabene.brown>
References: <20111019054826.GA30603@onthe.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/O9IOz2iv3JcBveJCCD_HIVt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111019054826.GA30603@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/O9IOz2iv3JcBveJCCD_HIVt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Oct 2011 16:48:26 +1100 Chris Dunlop <chris@onthe.net.au> wrote:

> Trivial comment fix
>=20
> Signed-off-by: Chris Dunlop <chris@onthe.net.au>
> ---
>  drivers/md/md.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5c95ccb..1a9bbfc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -744,8 +744,8 @@ static void mddev_unlock(mddev_t * mddev)
>  	} else
>  		mutex_unlock(&mddev->reconfig_mutex);
> =20
> -	/* was we've dropped the mutex we need a spinlock to
> -	 * make sur the thread doesn't disappear
> +	/* As we've dropped the mutex we need a spinlock to
> +	 * make sure the thread doesn't disappear
>  	 */
>  	spin_lock(&pers_lock);
>  	md_wakeup_thread(mddev->thread);

Thanks.  Applied.

NeilBrown


--Sig_/O9IOz2iv3JcBveJCCD_HIVt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp5s+jnsnt1WYoG5AQJccBAAwoORV9hhjhyxBbnAc5+TBrtoYOA0Tr+J
NxE0aMRFT49YXrFiHtJc1g++zKRzC7yQlBgihd9KrCeCcW5CRDe+E1Fi9kNTM/Gk
4cgIkMOKjrvnZ2Xy6wKyoxbyNhtcTxZ3OCDY8MQTOBslvQAtvSkOiYfSpxrTl8fI
cBqjZmunXWTSnf6sXgrQm6QSglLIh0aajR5Ma0Ij6U+jeozmoveyV/WZZgNMZSuK
KZlvYYOrgTqwie3aT+d8VCjhQ0G9U+0zkfj4I+oQq5ATe4Egp1YwcDQJSISMLzrk
S+QHOfVsA6nVMQ6mkpC5i3OVMuFs2ZVhou2I52mJMem844RtU1Jw83cULTCo5DTy
Nk1qF+E+SKBkwqvMiUpNoSLL21iDuSP90lHxnCBBrJAbhCZeSzs/DmcUEpGbIU+r
7Cf306JF/83iyxV7sJc4vt4RKaFGjZI2ZrEKN9vFzO+ScELKqa52n4akLs45vtMi
3yLEVnSCbleGt6kQFpkMDMYPzBdpP8Q+r2QE+EWLyLP9gQelybiHGL/bE+6ktAFW
BLYxXa1T3prOwnJc7FJ9il7j97OlPVFc8fdxlHuHCNKpaj7jtAYh/FvXB2BThW2b
oH82AJJAq7aCifpUT1WN4aYbAPGDPq0YL9Y1ISx2ZZSHGVSMPafyCqpFIpcGJ+Ej
X2asIlWe+eo=
=nZF6
-----END PGP SIGNATURE-----

--Sig_/O9IOz2iv3JcBveJCCD_HIVt--
