From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v3 2/5] raid5: fix stripe release order
Date: Wed, 28 Aug 2013 16:37:27 +1000
Message-ID: <20130828163727.76de453d@notabene.brown>
References: <20130827095038.303090029@kernel.org>
	<20130827095438.580030408@kernel.org>
	<20130828134150.678a5e1e@notabene.brown>
	<20130828062905.GA17163@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XUnfdjBNkU2qjvc0aXQYofd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130828062905.GA17163@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/XUnfdjBNkU2qjvc0aXQYofd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Aug 2013 14:29:05 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Wed, Aug 28, 2013 at 01:41:50PM +1000, NeilBrown wrote:
> >=20
> > > +struct llist_node *llist_reverse_order(struct llist_node *head)
> > > +{
> > > +	struct llist_node *second, *third;
> > > +
> > > +	if (head =3D=3D NULL || head->next =3D=3D NULL)
> > > +		return head;
> > > +	second =3D head->next;
> > > +	head->next =3D NULL;
> > > +
> > > +	do {
> > > +		third =3D second->next;
> > > +		second->next =3D head;
> > > +
> > > +		head =3D second;
> > > +		second =3D third;
> > > +	} while (second);
> > > +
> > > +	return head;
> > > +}
> > > +EXPORT_SYMBOL_GPL(llist_reverse_order);
> >=20
> > This is somewhat longer that necessary.
> >=20
> > struct llist_node *llist_reverse_order(struct llist_node *head)
> > {
> > 	struct llist_node *new_head =3D NULL;
> >=20
> > 	while (head) {
> > 		struct llist_node *tmp =3D head;
> > 		head =3D head->next;
> > 		tmp->next =3D new_head;
> > 		new_head =3D tmp;
> > 	}
> >=20
> > 	return new_head;
> > }
> >=20
> > I think that is short enough to just open-code in the top of
> > release_stripe_list.
> >=20
> > Are you OK with that?
>=20
> It's ok. Other patches can still apply with hunks.
>=20
> Subject: raid5: fix stripe release order
>=20
> patch "make release_stripe lockless" changes the order stripes are releas=
ed.
> Originally I thought block layer can take care of request merge, but it a=
ppears
> there are still some requests not merged. It's easy to fix the order.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2013-08-28 13:51:39.586914255 +0800
> +++ linux/drivers/md/raid5.c	2013-08-28 13:53:25.429582150 +0800
> @@ -239,6 +239,20 @@ static void __release_stripe(struct r5co
>  		do_release_stripe(conf, sh);
>  }
> =20
> +static struct llist_node *llist_reverse_order(struct llist_node *head)
> +{
> +	struct llist_node *new_head =3D NULL;
> +
> +	while (head) {
> +		struct llist_node *tmp =3D head;
> +		head =3D head->next;
> +		tmp->next =3D new_head;
> +		new_head =3D tmp;
> +	}
> +
> +	return new_head;
> +}
> +
>  /* should hold conf->device_lock already */
>  static int release_stripe_list(struct r5conf *conf)
>  {
> @@ -247,6 +261,7 @@ static int release_stripe_list(struct r5
>  	struct llist_node *head;
> =20
>  	head =3D llist_del_all(&conf->released_stripes);
> +	head =3D llist_reverse_order(head);
>  	while (head) {
>  		sh =3D llist_entry(head, struct stripe_head, release_list);
>  		head =3D llist_next(head);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Applied, thanks.

NeilBrown

--Sig_/XUnfdjBNkU2qjvc0aXQYofd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh2apznsnt1WYoG5AQJlCg//Q6ILTpey/tnwIxJb12zW43TGAfGyNXaA
M1hSUqbrB0+JaxgXsQ9/itfBntLQRbiNqMmgqz8OEHnEd8VQ0mcUsVs/YGEmVnn+
4p9g8Dz7IT+kg8WKS3IH1pgwohjLc7+0tjU8NTFRmJG5Fcp2qOMegKRVDNtnm9du
XRKz9faH10DQorw/0uOq/MxUWIi31rfJ2NofB8eydBYRYMHyEsbU1CFr5QnGo88y
hyua4b2NYMcto/2C9pulqH9atJsyAW7g02ERhatJwCOO5uo0XZ6TIJ4qfb/r321u
V+pgrPbSga2LLsgVAVEJElUu3Je7WQhtnsQYSKPzdH6Qf6MYlNK+NA3Gu3A0tLCR
aTG/NOOgvv6YcIIi2OhfrYgBboo4RJaCHlxilEVeRjjURPLJRl95vhbM/YiAHNXP
WRph3uQ7cFXzqvlhJvfQ5JHZZnpwz+xLpH754ttoi6QmnbEx8APP6CI647HyQMPU
y37lYhv1en86UXETAVJeMl14x8s+oxJSbUi8tL7+QTrsfYrUwHiOWNeoKpxLtCfX
mJPurHremNiVrvkLL2dBelEkhMviEvFoauskIyhbu970tQD8oJNUmW6JzPe7Muyb
4rWtvPJNI5PnYR/jHdXLmjGSEjKOzeToSpzBCDZpE+dBO6nBMJJSE0ljtYH9yEZE
vED2hKjzkx4=
=ks3o
-----END PGP SIGNATURE-----

--Sig_/XUnfdjBNkU2qjvc0aXQYofd--
