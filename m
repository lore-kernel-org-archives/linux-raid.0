From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: fix stripe release order
Date: Mon, 29 Jul 2013 15:47:05 +1000
Message-ID: <20130729154705.10bd14d4@notabene.brown>
References: <20130725082642.GA6985@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=HJppE3dVf6aEeYgAVx7vAs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130725082642.GA6985@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, ying.huang@intel.com
List-Id: linux-raid.ids

--Sig_/=HJppE3dVf6aEeYgAVx7vAs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jul 2013 16:26:42 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> patch "make release_stripe lockless" changes the order stripes are releas=
ed.
> Originally I thought block layer can take care of request merge, but it a=
ppears
> there are still some requests not merged. It's easy to fix the order.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c    |    1 +
>  include/linux/llist.h |    1 +
>  lib/llist.c           |   27 +++++++++++++++++++++++++++
>  3 files changed, 29 insertions(+)
>=20
> Index: linux/include/linux/llist.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/include/linux/llist.h	2013-07-24 09:09:41.014384439 +0800
> +++ linux/include/linux/llist.h	2013-07-25 15:09:03.109026773 +0800
> @@ -172,4 +172,5 @@ static inline struct llist_node *llist_d
> =20
>  extern struct llist_node *llist_del_first(struct llist_head *head);
> =20
> +extern struct llist_node *llist_reverse_order(struct llist_node *head);
>  #endif /* LLIST_H */
> Index: linux/lib/llist.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/lib/llist.c	2013-07-24 09:09:41.062383834 +0800
> +++ linux/lib/llist.c	2013-07-25 16:08:40.096054565 +0800
> @@ -81,3 +81,30 @@ struct llist_node *llist_del_first(struc
>  	return entry;
>  }
>  EXPORT_SYMBOL_GPL(llist_del_first);
> +
> +/*
> + * llist_reverse_order - reverse llist order
> + * @head: list head
> + *
> + * Return reversed list head
> + */
> +struct llist_node *llist_reverse_order(struct llist_node *head)
> +{
> +	struct llist_node *second, *third;
> +
> +	if (head =3D=3D NULL || head->next =3D=3D NULL)
> +		return head;
> +	second =3D head->next;
> +	head->next =3D NULL;
> +
> +	do {
> +		third =3D second->next;
> +		second->next =3D head;
> +
> +		head =3D second;
> +		second =3D third;
> +	} while (second);
> +
> +	return head;
> +}
> +EXPORT_SYMBOL_GPL(llist_reverse_order);
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2013-07-25 15:02:38.289865404 +0800
> +++ linux/drivers/md/raid5.c	2013-07-25 15:35:33.201040089 +0800
> @@ -247,6 +247,7 @@ static int release_stripe_list(struct r5
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


Makes sense.
Applied- thanks.

NeilBrown

--Sig_/=HJppE3dVf6aEeYgAVx7vAs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfYB2Tnsnt1WYoG5AQJvRw//U4zT3+JNWZ0hV7AWK13Eg61zSjpwoi3q
Ryz9R4WzzpGPm2xGkAWjNazXYKz5I/YYs6BdIsnsikKaRT16dDSn6GOqkq8tNQ9z
d2Qg5CIeq+IC5FpMUXPMySzotyclDDZfz64IKnEoimWW8NEknTj/szf/r3WECYn9
j5MsM31Wh1LvuNZX7nRsQb/mXBa2XWdoOu00bhPKV85vam4bYf+6KNraYhW0FJ32
1X/dfKSAevGAWPtHJXdfRbfT0ORQ0mfUB9CyEKOYoUB7tgi60uAdecXYyu4P1C9H
Aei61Unrg5uF7Cxcuc+B+u1Irxb/TkmulQGVaywo1sK1vwYpMpE4aqEOWZvZKS9w
jHuzDFtCeqWj8vKEwKQaMs/By7FjGbAH4ZYvfjnG853kuekfAuaiZKUSbz5j1eKo
6R1fY3zuY77YR8kQ20rSDhJcEA/ZxXFerLSV4kt5qc6GhckcKzLUFm6ebMcD8JL8
/BzLBh6ohaRlXNhuNktpYU2L4Gp0aWyHsaPbQmTK8B5NEVmiJrMQa+bT6BUHw6Wr
2XBmYrmFKkfyO9g7j1pDbRIYl3uSM6c27ydRwYFmUpbTvWBpXdOnZKUmbtjKpegN
INF1pcUG6zAm2DrhDzs/pO/2+cq3BQ4ZGGZAhk1M/JLlqviE26yRDp28roo7faj0
cIUnmiiE/ys=
=HmjI
-----END PGP SIGNATURE-----

--Sig_/=HJppE3dVf6aEeYgAVx7vAs--
