From: NeilBrown <neilb@suse.com>
Subject: Re: REALLY Fix bug in [md PATCH 02/15] md/raid5: simplfy delaying of writes while metadata is updated.
Date: Wed, 22 Mar 2017 13:35:48 +1100
Message-ID: <87a88eavi3.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711228.18641.2048575896322496918.stgit@noble> <87tw6may1v.fsf@notabene.neil.brown.name> <87inn2avsj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87inn2avsj.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Mar 22 2017, NeilBrown wrote:

> Using r1_bio->sector in call_bio_endio is more
> obviously-correct than bio->bi_iter.bi_sector,
> though both should have the same value.
>
> The inc_pending() call in handle_read_error() was missing.
> One should always accompany a bio_inc_remaining.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>
> Sorry, I left an unused variable...
> NeilBrown

Sorry again - I replied to the wrong email (not a good day...)
and gave the wrong subject.
This should be
  REALLY Fix bugs in [md PATCH 10/15] md/raid1: stop using bi_phys_segment

:-(

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR4wQACgkQOeye3VZi
gbnZgA//dPfqspRI2lD3zr3bu6EpyAUVeFF8PagiBew9zYY93xJkd1bgIJIwtrI+
ulfJCO6L+/YLX2XpzJH9HaRMCyKL11vVBCk2Yt6DiLkn8eCaTx4nZQKC0ouF0KF4
saPlH9/mepFLIozv0MsADysdMBQnOWsE+gWNqPj2vkvjSHrmhFhMzLrWhFiKCfLQ
qBlcjEA2kUI6CEjTFgiJqVgErI8BzkNuUOOxawtuzHREXdgdTAKT+6azlp6JH2Py
ZXiMrAULVaI0pzZxb2Y+8w95qDwJ6oQV6ucIRvtyPq/0IjBeeu5/JpnVrWUNcf2c
u78w50LT8s0MU9lavqN58ijfYA21WMjsZlXfy4tSVWHvfNCoP4iUXyftGS6WGikF
+XNYr9OkjpgzDe5OOm35Aj5SL7iV6j3nijPCHuC95FjKwmG726Z8YxoJQqbI6wm0
rErDOAgbSbiOFBocWYCoWp+U74XMhP+kC6iJkeGRxMEqZhAEcvnyGvZBvZdnfZSB
IVl0PGTLvkWd3WSMq0E2enHhEJRIbQ+stOH3dK9z6r3jFuGoqt09JT912ycSnIZM
lzAG6m7Kbem3ViaD0ZmXFgX+DnVqjBbqAIKOS1HjWCSgxJ2Kw5N8aBbZnoXBNklW
6dFxr8Rm1mrCsWA8POe/49CVceca74Gzrby0rgrg4CvMsfxncUU=
=Nczn
-----END PGP SIGNATURE-----
--=-=-=--
