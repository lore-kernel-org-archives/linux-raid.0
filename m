From: Ian Kumlien <ian.kumlien@gmail.com>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
Date: Mon, 20 Jan 2014 19:27:18 +0100
Message-ID: <1390242438.587.16.camel@localhost>
References: <1390168823.587.1.camel@localhost>
	 <20140120113851.3b476ed8@notabene.brown> <1390178957.587.9.camel@localhost>
	 <20140120143748.33bb52d2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140120143748.33bb52d2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On m=C3=A5n, 2014-01-20 at 14:37 +1100, NeilBrown wrote:
>=20
> Thanks - that extra info is quite useful.  Knowing that nothing else =
unusual
> is happening can be quite valuable (and I don't like to assume).
>=20
> I haven't found anything that would clearly cause your crash, but I h=
ave
> found something that looks wrong and conceivably could.
>=20
> Could you please try this patch on top of what you are currently usin=
g?  By
> the look of it you get a crash at least every day, often more often. =
 So if
> this produces a day with no crashes, that would be promising.
>=20
> The important aspect of the patch is that it moves the "atomic_inc" o=
f
> "sh->count" back under the protection of ->device_lock in the case wh=
en some
> other thread might be using the same 'sh'.

I have been unable to trip this up, so this was it!

Tested-by: Ian Kumlien <ian.kumlien@gmail.com>

I hope this hits stable ASAP ;)

> Thanks,
> NeilBrown
>=20
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 3088d3af5a89..03f82ab87d9e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -675,8 +675,10 @@ get_active_stripe(struct r5conf *conf, sector_t =
sector,
>  					 || !conf->inactive_blocked),
>  					*(conf->hash_locks + hash));
>  				conf->inactive_blocked =3D 0;
> -			} else
> +			} else {
>  				init_stripe(sh, sector, previous);
> +				atomic_inc(&sh->count);
> +			}
>  		} else {
>  			spin_lock(&conf->device_lock);
>  			if (atomic_read(&sh->count)) {
> @@ -695,13 +697,11 @@ get_active_stripe(struct r5conf *conf, sector_t=
 sector,
>  					sh->group =3D NULL;
>  				}
>  			}
> +			atomic_inc(&sh->count);
>  			spin_unlock(&conf->device_lock);
>  		}
>  	} while (sh =3D=3D NULL);
> =20
> -	if (sh)
> -		atomic_inc(&sh->count);
> -
>  	spin_unlock_irq(conf->hash_locks + hash);
>  	return sh;
>  }


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
