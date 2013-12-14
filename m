From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] drivers: md: Mark the function btree_insert_fn() as
 static in btree.c
Date: Sat, 14 Dec 2013 12:44:15 -0800
Message-ID: <20131214204414.GK17601@leaf>
References: <20131214125929.GA8200@rashika>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131214125929.GA8200@rashika>
Sender: linux-bcache-owner@vger.kernel.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 14, 2013 at 06:29:29PM +0530, Rashika Kheria wrote:
> This patch marks the function btree_insert_fn() as static in
> bcache/btree.c because it is not used outside this file.
>=20
> Thus, it also eliminates the following warning in bcache/btree.c:
> drivers/md/bcache/btree.c:2220:5: warning: no previous prototype for =
=E2=80=98btree_insert_fn=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/md/bcache/btree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 5e2765a..dc6e2be 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -2217,7 +2217,7 @@ struct btree_insert_op {
>  	struct bkey	*replace_key;
>  };
> =20
> -int btree_insert_fn(struct btree_op *b_op, struct btree *b)
> +static int btree_insert_fn(struct btree_op *b_op, struct btree *b)
>  {
>  	struct btree_insert_op *op =3D container_of(b_op,
>  					struct btree_insert_op, op);
> --=20
> 1.7.9.5
>=20
