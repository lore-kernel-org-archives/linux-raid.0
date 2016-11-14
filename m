From: NeilBrown <neilb@suse.com>
Subject: Re: "creative" bio usage in the RAID code
Date: Mon, 14 Nov 2016 20:43:49 +1100
Message-ID: <87shquiega.fsf@notabene.neil.brown.name>
References: <20161110194636.GA32241@infradead.org> <87shqvj83r.fsf@notabene.neil.brown.name> <20161114085151.GA8405@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161114085151.GA8405@infradead.org>
Sender: linux-block-owner@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14 2016, Christoph Hellwig wrote:

> On Mon, Nov 14, 2016 at 10:03:20AM +1100, NeilBrown wrote:
>> I would suggest adding a "bi_dev_private" field to the bio which is for
>> use by the lowest-level driver (much as bi_private is for use by the
>> top-level initiator).
>> That could be in a union with any or all of:
>> 	unsigned int		bi_phys_segments;
>> 	unsigned int		bi_seg_front_size;
>> 	unsigned int		bi_seg_back_size;
>>=20
>> (any driver that needs those, would see a 'request' rather than a 'bio'
>> and so could use rq->special)
>>=20
>> raid5.c could then use bi_dev_private (or bi_special, or whatever it is =
call).
>
> All the three above fields are those that could go away with a full
> implementation of the multipage bvec scheme.  So any field for driver
> use would still be be overhead.  If it's just for raid5 it could
> be a smaller 16 bit (or maybe even just 8 bit) one.

We currently store 2 counters in that field, and before
commit 5b99c2ffa980528a197f26 one of the fields was only 8 bits,
and that caused problems

We could possibly use __bi_remaining in place of
raid5_X_bi_active_stripes().  It wouldn't be a completely
straightforward conversion, but I think it could be made to work.

We *might* be able to use bvec_iter_advance() in place of
raid5_bi_processed_stripes().  A careful audit of the code would be
needed to be certain.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYKYdVAAoJEDnsnt1WYoG5BS8QAKPVGrUyJWwKjXUzAq2m3wh9
O+pacsr0kYXhNK9X+GlK+gD1RdgWCGvt1SGwA9lvaZdnQFGUf9LT1I11WT+io7vT
VobSXb5tt405TnEQnUPG9rsFRtA8z+LeDZYCwpjNRkG8MVkuTjUBabyGO8THy/Fk
xWfAEkOeVawHg4Lg3KN8QMkREkAwHR9Qo/pf8eNg0Eiq1rYexxYi+DCXMkU4rbXa
LRomrDnhxd6aL4n1eth+KAttGeenYvafLMg4yB0aGdIrnkts+sgW1QTNJ5i/KvkS
pq41+35mOC1k+4JS5DlZlLlcCdO66IPcL8JZDge7397tP/B81KGw62wquJxhh6m+
j0ULdWwB8ADu9CnHDszBZu3OYjdzY6YJUr9prsvL4JL0z8Kgvc6fm46XYXSzvVap
hSafzqGf67obRObBxEZgikSyMi78THGdblhruU4E/vhYNYi7f198dAUQ/YO1tA+L
hjPSr4WRG7KIKAoIcv1l7P6U8NfemEFjg7t01NM0zOjs3a0+UzJfffLHleKux+cY
FHXK+Lr+7dQsZN0bgvj6qEcWn3/k2SJ+/I5dn7tzxAfUQS05yMu7VRG4jSEKE/zi
Pg22HG6qUyFrPWgTS2p5/SK+t2oxC1y1UM2N7EjQd7FJH1f0QZxdJ6B1bgG0YXF5
Zn9CYwK09IV0Z3fLrTrv
=kX83
-----END PGP SIGNATURE-----
--=-=-=--
