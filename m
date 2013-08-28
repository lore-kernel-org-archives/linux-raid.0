From: NeilBrown <neilb@suse.de>
Subject: Re: [patch v3 2/5] raid5: fix stripe release order
Date: Wed, 28 Aug 2013 13:41:50 +1000
Message-ID: <20130828134150.678a5e1e@notabene.brown>
References: <20130827095038.303090029@kernel.org>
	<20130827095438.580030408@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OcbUK+mxjLu=FfbEo1f+cf6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130827095438.580030408@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

--Sig_/OcbUK+mxjLu=FfbEo1f+cf6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


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

This is somewhat longer that necessary.

struct llist_node *llist_reverse_order(struct llist_node *head)
{
	struct llist_node *new_head =3D NULL;

	while (head) {
		struct llist_node *tmp =3D head;
		head =3D head->next;
		tmp->next =3D new_head;
		new_head =3D tmp;
	}

	return new_head;
}

I think that is short enough to just open-code in the top of
release_stripe_list.

Are you OK with that?

NeilBrown

--Sig_/OcbUK+mxjLu=FfbEo1f+cf6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh1xfjnsnt1WYoG5AQJk7BAAp6rozjh3/5u4v8eqcQInmJLJgBbtDEFk
BBLNzbe17GOZewAz7wg8W011dvrPlTu2JEPQB8qXiZnVW5RVtciZvXkOsupXYkb0
No76GJrsTKsczeGyZIag+MKqdU7hWKajwr4GgfLhBE0Rbg0kKG+9/v47DPOE0OXi
9T0iSVF6x24CbRtVmyDk8GA0U2yyEnNPU5on21j7ADvQiJ427Esshf/xZ4eaO0gw
FWnOJQ0clUHL0cZ3NKM3n51W9d9VKmF4NdiJ9nQVIM4NRDnt1GXh5jhhwqaBJbwm
uhH/+4JMXnNTdfq6o1L/vvgLFRasqAofnGudgg9D6fb1GpvcwjoNEUZzbfMoeHDr
GpVPOeKwcYxoBUlX2gA9/y5JXftY/gKbFAxxEHrbinMF0tXErlc+nqc+P9R6tYgM
QBJBMgenFG8nIwGpA0eIBvDYgcW7p5vu1tNOih+V/qSYq/nCarPp5i7QBPhg2wKU
lZAtkYk/U0LO0g35QxeEd88lqqyQQf3AroVeflCYc/1hPIG4SOSN/utNHGHp4J7o
HEMW6MO0DyHPniE0pSNTC13nG4paiBsYVAiZdjFWY/gPu173+vP07USMH49HW87g
87PDnRLbRJbXe9AQbe7iWvX+0/jkmRCmoGN5D4twOBST0m2mnfKVF5BN3lyRJK4i
LrHGRtV1Hi8=
=Vaw6
-----END PGP SIGNATURE-----

--Sig_/OcbUK+mxjLu=FfbEo1f+cf6--
