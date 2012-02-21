From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Print correct md device name if write_init_super fails
Date: Wed, 22 Feb 2012 06:53:35 +1100
Message-ID: <20120222065335.268c8aae@notabene.brown>
References: <1329827402-12124-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GbGHyYhTIHSyfid07NXaYa+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1329827402-12124-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: meyering@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GbGHyYhTIHSyfid07NXaYa+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Feb 2012 13:30:02 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> This avoids a segfault in case one tries to create a raid from a non
> existing device (like a loop device).
>=20
> Reported by Jim Meyering in
> https://bugzilla.redhat.com/show_bug.cgi?id=3D795461
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  Create.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 90ff3ed..702ac34 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -926,7 +926,7 @@ int Create(struct supertype *st, char *mddev,
>  			if (st->ss->write_init_super(st)) {
>  				fprintf(stderr,
>  					Name ": Failed to write metadata to %s\n",
> -					dv->devname);
> +					mddev);
>  				st->ss->free_super(st);
>  				goto abort_locked;
>  			}

Hi Jes,
 this doesn't seem right.  You message would print e.g.

    mdadm: Failed to write metadata to /dev/md1

but one doesn't write metadata to an array, one writes it to the member
devices.
Each ->write_init_super function should print out a message if a write
fails.  So I think we just remove the error message here, and make sure
each ->write_init_super does print an error in each case (there might be a
couple of holes).

Could you try that approach instead?

Thanks,
NeilBrown

--Sig_/GbGHyYhTIHSyfid07NXaYa+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0P2Pznsnt1WYoG5AQLRBhAAwIx22ZtlqKHnfqtoEc7tkPQEb+2Ybr6m
TZJRWajnkt7u9/PqLQxUmhX0uMbiLXA8otyXjfMYM6zR04r0nYbH8UU2p0vl9wbc
ebcQsJa0f+oYcIsF8ojnygm0wK3WDIzbfSrc8k0bdP+uIZzUIlRQ85iukvky/gJI
Lvgl0Mj0XiHDdMKnCRFLTLxFxTuv/R9l7Kpq7gd9NICBC/7GRRNrKHZZ+ut5TTMJ
zyaZ63K/JN4vXO5SESD7GatgMsxnhYTiHjn1mAqLu7GZfLEIDFVCgeWAUaaMuKJF
+gY0gneDUJRftFalmbLydJFIvD9gIF19vsdDr24PV5SCivuYXeMTdCgZRYsa/ria
flmq65X30aOG6tX0VeM+KUmR4Sxoq9hpVw7yHQz2a/pUMWgLt7O3QKgzFEeNpr7L
pNc1nXphubtF0wAQMe3zC/qKp/xRu9wmlxkOopB1YXLcNSgoUq+DBCGZh+BEm7fB
Ky49E+rnH0UlZZSNiE8SZrjX+NOdJVK0wLXABbnKYjmDAPsYVa1u/03bBrMYYv4A
BGVlxGm+WVGUIKNo/+LSeogfwQ/ChPzQMbB+jLEgAPwI6cpY/+GuIzr1EPHqjvDb
uWAEzBwHqwAZ2MgQQVQl5+k7RPdSOxKwrnNoU+BAWDnvYcaH/pZ2nQaYHCuVzvHa
gVYx3+Bojpg=
=vfMG
-----END PGP SIGNATURE-----

--Sig_/GbGHyYhTIHSyfid07NXaYa+--
