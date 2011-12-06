From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Possible changes to bio cloning and some related stuff
Date: Tue, 6 Dec 2011 16:36:28 +1100
Message-ID: <20111206163628.7ab8545f@notabene.brown>
References: <20111206051101.GA8171@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dKV8au/ohyohmTKAjzl5iD8"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111206051101.GA8171-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

--Sig_/dKV8au/ohyohmTKAjzl5iD8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 21:11:01 -0800 Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
wrote:

> So, I finally got around to debugging various bcache on md issues, and I
> ran into a rather sticky problem:
>=20
> bio_alloc() can fail if nr_iovecs > BIO_MAX_PAGES. That itself is not a
> problem, but then when a bio is cloned it's always done by cloning the
> _entire_ original bio vec, from 0 to max_vecs - not the range from
> bi_idx to bi_vcnt.
>=20
> Basically, whenever bcache generates some io internally it uses a single
> bio to describe the entire io - regardless of whether or not the bio
> would be too big for the underlying device; it then splits the bio as
> many times as need be when it's actually submitted.
>=20
> This works beautifully for dumb drivers - I'm actually planning on
> making my code generic and integrating it with the block layer so that
> the same approach could be easily used by other code that generates
> bios, it would allow a _lot_ of code to be deleted from the kernel.

Sounds promising.

>=20
> But for stacking drivers, the mere existence of a bio with max_vecs >
> BIO_MAX_PAGES breaks things, regardless of how many pages are actually
> being used in this bio.
>=20
> So, IMO __bio_clone(), bio_clone_mddev(), and whatever other code ought
> to be changed to only copy bi_idx to bi_vcnt from the original bio -
> it'd make it consistent with how bios are used elsewhere. Thoughts? The
> actual patches should be trivial, it'll mostly just be a matter of
> grepping around and finding everything, I think.

I'm not against this.  There are a few places where md assumes there is a 1=
-1
mapping between original and cloned bios.  It probably wouldn't be too hard
to find those and adjust them to your new scheme.

So if you write patches I'll help make sure they work on md.

Thanks,
NeilBrown

--Sig_/dKV8au/ohyohmTKAjzl5iD8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt2p3Dnsnt1WYoG5AQIAxRAAhbnamCNN23v05BW09oDPLR1vV1JTCq/3
g9AHEJzv8Ipn1PT6QHAJ7oS7HiJyHRQF2DmHqVv/egIHzqR/rSUb3CtR9zxmMHUc
bvlgS7lO6ncwQwEzocCtVfZxBHeq8Y/eRiwJO/DiVS24M8oNmI1bx3rGYiGkYfNN
OqDIUEr6VUtymHSYQsLCu4e59mbOv1q8a9fuIOjWauTfeX6DTeJ7w0pLGVWtXk0Z
nQ2uixpcp3vQ6ccJ9WUk0rgIrb++5f+avBnMrpYMuK864nZ8oc9ewVATcJG87xTW
yPQDnqoZTtpc33upFLyesk37Rg2+nZzXvVKHQWDeNLAQtrajLE/n5vOMPBvLiHBn
Lw+RNQgdX9yTKh7MFxf7AeviqVZwc2AwbjySHLGxIAeA9cWvnR7aKsEGRl9UEN9y
W2MLKGHcUQw03NX50PbbsNy8rRgLIEo+kmh3l5dG8Wi+43zsDs1LuXeYknB5M4p5
JKoAC8PJ2axip8wqRq1JMg5D8mtM1GtA1BicDt2b3CofwlfUf6SLXu1v2ZOgl+2O
i6LJm3J7LkoqJj28EOcLBVg6JBidsOKTaZji/DmcP+1baCMeDFydDY1FM4oJpdSD
lzPTRE2KVJWkJpZEf6axAe4dmOWENt/MShB6BOpzc0xXfCLIUBbXq8E6BCficRwZ
w2tw85W28x0=
=0gxG
-----END PGP SIGNATURE-----

--Sig_/dKV8au/ohyohmTKAjzl5iD8--
