From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] bcache: Use setup_timer and mod_timer
Date: Thu, 30 Jun 2016 20:11:26 +0800
Message-ID: <cb7cfc00-b3f6-d2c5-6c0f-eb81f78f797c@suse.de>
References: <20160630114520.GA8025@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160630114520.GA8025@amitoj-Inspiron-3542>
Sender: linux-bcache-owner@vger.kernel.org
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>, kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
List-Id: linux-raid.ids

=D4=DA 16/6/30 =CF=C2=CE=E77:45, Amitoj Kaur Chawla =D0=B4=B5=C0:
> Convert a call to init_timer and accompanying intializations of
> the timer's data and function fields to a call to setup_timer.
>=20
> The Coccinelle semantic patch that fixes one part of this issue
> is as follows:
> @@
> expression t,d,f,e1;
> identifier x1;
> statement S1;
> @@
>=20
> (
> -t.data =3D d;
> |
> -t.function =3D f;
> |
> -init_timer(&t);
> +setup_timer(&t,f,d);
> |
> -init_timer_on_stack(&t);
> +setup_timer_on_stack(&t,f,d);
> )
> <... when !=3D S1
> t.x1 =3D e1;
> ...>
>=20
> Also convert calls to add_timer and intialisation of timer's expire
> field to a call to mod_timer which is more compact.
>=20
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
> ---
>  drivers/md/bcache/stats.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
> index 0ca072c..094d6d6 100644
> --- a/drivers/md/bcache/stats.c
> +++ b/drivers/md/bcache/stats.c
> @@ -233,9 +233,6 @@ void bch_cache_accounting_init(struct cache_accou=
nting *acc,
>  	kobject_init(&acc->day.kobj,		&bch_stats_ktype);
> =20
>  	closure_init(&acc->cl, parent);
> -	init_timer(&acc->timer);
> -	acc->timer.expires	=3D jiffies + accounting_delay;
> -	acc->timer.data		=3D (unsigned long) acc;
> -	acc->timer.function	=3D scale_accounting;
> -	add_timer(&acc->timer);
> +	setup_timer(&acc->timer, scale_accounting, (unsigned long) acc);
> +	mod_timer(&acc->timer, jiffies + accounting_delay);
>  }
>=20

This patch uses new setup_timer() and mod_timer() interface to
initialize acc->timer. No change in functionality. It is OK to me.

Reviewed-by: Coly Li <colyli@suse.de>

Coly
