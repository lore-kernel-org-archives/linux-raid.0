From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid0: remove empty line printk from dump_zones
Date: Mon, 25 Apr 2016 08:42:56 -0700
Message-ID: <20160425154256.GA108964@kernel.org>
References: <20160424181145.41aae9dd@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160424181145.41aae9dd@sauron>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Micha=C5=82?= Pecio <michal.pecio@gmail.com>
Cc: Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 24, 2016 at 06:11:45PM +0200, Micha=C5=82 Pecio wrote:
>=20
> Remove the final printk. All preceding output is already properly
> newline-terminated and the printk isn't even KERN_CONT to begin with,
> so it only adds one empty line to the log.
>=20
> Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
> ---
>  drivers/md/raid0.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f8e5db0..3e51f4d 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -70,7 +70,6 @@ static void dump_zones(struct mddev *mddev)
>  			(unsigned long long)zone_size>>1);
>  		zone_start =3D conf->strip_zone[j].zone_end;
>  	}
> -	printk(KERN_INFO "\n");
>  }

applied, thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
