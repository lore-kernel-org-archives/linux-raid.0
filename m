From: NeilBrown <neilb@suse.de>
Subject: Re: [Trivial PATCH] removing doubled description for sync_max,
 merging it within sync_min/sync_max
Date: Thu, 27 Jun 2013 09:40:29 +1000
Message-ID: <20130627094029.655d90b6@notabene.brown>
References: <CAGqmV7qzdY8=sN0qOyD7gEKb3df3CQ1v3JR4HsgPVBSWWoc8LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//S1HgHT3xZeiJoKr/SLBbBf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qzdY8=sN0qOyD7gEKb3df3CQ1v3JR4HsgPVBSWWoc8LA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//S1HgHT3xZeiJoKr/SLBbBf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Jun 2013 19:46:58 +0400 CoolCold <coolthecold@gmail.com> wrote:

> After last md.txt edits for sync_min/max, sync_max description became
> doubled. Removing 1st copy, merging details into common
> sync_min/sync_max section.
>=20
> Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
> ---
>  Documentation/md.txt |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
>=20
> diff --git a/Documentation/md.txt b/Documentation/md.txt
> index e0ddd32..d2e4071 100644
> --- a/Documentation/md.txt
> +++ b/Documentation/md.txt
> @@ -566,13 +566,6 @@ also have
>       when it reaches the current sync_max (below) and possibly at
>       other times.
>=20
> -   sync_max
> -     This is a number of sectors at which point a resync/recovery
> -     process will pause.  When a resync is active, the value can
> -     only ever be increased, never decreased.  The value of 'max'
> -     effectively disables the limit.
> -
> -
>     sync_speed
>       This shows the current actual speed, in K/sec, of the current
>       sync_action.  It is averaged over the last 30 seconds.
> @@ -592,6 +585,12 @@ also have
>       You can use 'select' or 'poll' on "sync_completed" to wait for
>       that number to reach sync_max.  Then you can either increase
>       "sync_max", or can write 'idle' to "sync_action".
> +
> +     The value of 'max' for "sync_max" effectively disables the limit.
> +     When a resync is active, the value can only ever be increased,
> +     never decreased.
> +     The value of '0' is the minimum for "sync_min".
> +
>=20
>=20
>  Each active md device may also have attributes specific to the
> --
> 1.7.2.5
>=20
>=20
> --
> Best regards,
> [COOLCOLD-RIPN]


Applied, thanks.

NeilBrown

--Sig_//S1HgHT3xZeiJoKr/SLBbBf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUct77Tnsnt1WYoG5AQKEKA/8DhdCKEynW6RRiveIBUw4Yr0t6S3Lhh05
AXCSzqQaKMo2gm78GmRyoPaszjV07GcuObJWZB7qIkf5I1pwMsujZ/PJFlipPzG8
c7jQPSD+EWaCPqo3l//nfio5kmPQL7t1WYh/biIU+NAlQUWbLv7ObQN8UORrHB7X
g/Jf5UK26bTN6DJCQZMgB732SXilGZcYpiFLozclHVzytbxWK1l6aqWfRKUIDJs2
y9GaXBuP9vSSLZ5rWZuvcEFKKG4eJhTUfvtu7johs0NweAVrOaJ0MsZs/FV2jJuh
9mBFUNRKzjEoDynObxO/eNbBJwKjKHUEGGdXicWOVbmYOTqoeCdMNPD0GpVHF++z
Q/haSgs2yk48iDgZHxL17DQj18RNzB23ZDD6JfDwT2GhAQDuVmvaRKEXc3U7rpmg
ye3tpwoWQfN4S38c8shP5F/87F5rz7NXhvzbmmuAUqQ50VUe77+zEANXJgi8nPFT
/BX5+Bsg4mf/FN+kRdhTMYBpsxaZA9yqGzcq6NmuULOKPNf6eZ3pcSGEQgTEC9CQ
Su3hM010r1Kt2bXuw9+iEiaeMqHvDAvIgMov6woZHs35pmSObFw2iCgbf76MMwD3
1iokTkFwtIoafzFpfvyf8Nb6Zp08YzDOl1seEzSqmSpa6uL5Hee2vQEugM1arcxx
qTLVz4DXvWg=
=FhY0
-----END PGP SIGNATURE-----

--Sig_//S1HgHT3xZeiJoKr/SLBbBf--
