From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 06/10] monitor: read_and_act: log status when called
Date: Wed, 31 Jul 2013 12:59:33 +1000
Message-ID: <20130731125933.0d6f0c6c@notabene.brown>
References: <51F82D3B.6060104@arcor.de>
	<1375219114-5626-7-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CwvbvVyYmCkv.NgpGS21Z=d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375219114-5626-7-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CwvbvVyYmCkv.NgpGS21Z=d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Jul 2013 23:18:30 +0200 mwilck@arcor.de wrote:

> From: Martin Wilck <mwilck@arcor.de>
>=20
> read_and_act() currently prints a debug message only very late.
> Print the status seen by mdmon right away, to track mdmon's
> actions more closely. Add a time stamp to observe long delays
> between read_and_act calls, e.g. caused by meta data writes.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  monitor.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/monitor.c b/monitor.c
> index 67b40b1..b208168 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -234,6 +234,7 @@ static int read_and_act(struct active_array *a)
>  	struct mdinfo *mdi;
>  	int ret =3D 0;
>  	int count =3D 0;
> +	struct timeval tv;
> =20
>  	a->next_state =3D bad_word;
>  	a->next_action =3D bad_action;
> @@ -257,6 +258,17 @@ static int read_and_act(struct active_array *a)
>  			mdi->curr_state =3D read_dev_state(mdi->state_fd);
>  		}
>  	}
> +=09
> +	gettimeofday(&tv, NULL);
> +	fprintf(stderr, "%s(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s =
start:%llu\n",
> +		__func__, a->info.container_member,
> +		tv.tv_sec, tv.tv_usec,
> +		array_states[a->curr_state],
> +		array_states[a->prev_state],
> +		sync_actions[a->curr_action],
> +		sync_actions[a->prev_action],
> +		a->info.resync_start
> +		);

I hope this was meant to be "dprintf" ???

I've made that change.

NeilBrown


> =20
>  	if (a->curr_state > inactive &&
>  	    a->prev_state =3D=3D inactive) {


--Sig_/CwvbvVyYmCkv.NgpGS21Z=d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfh9lTnsnt1WYoG5AQKLmBAApJdBwEWL7XEMdf2RdNZ5AlLT8g02nonB
ah96xHtjK2VgwZn7PCUL6o7qRbGoXwYkJPMaUeAPeW1vj7X5zgy5jE9+FOd1XDVK
U9CVeuHf0LP46qhKKAP2TCunBcsh+r6QUXwnReEpyj5LhwjOzunTaI0Du2LlhnCX
z7Z0aYdJzJgNxGF1D4S/+Lz34EEmgkZ8QhOn6nQJuaMi1MPn0r2tEtM8MZPBnUwo
nflOssuD/Ggm3AXP9WVFrHoGRgrjoPBICi3n8y7nfQ/4JcsJClwb3vY5mAMNsyQz
1TDb5HC0dMUQn9/4aJsiJDWxxWVGBMeH2A4KHasxhpTN4clOlvz21a4o91JyUSmN
dyG1Y9u+mjpcAnNhDSv8AayfOC81HBo+BnlymiMiEWUjSMObGunAi+735rES22QQ
CA9VTAZoyfUVThIlrK0OgHa7U75pYF1MmXWCz8sbtsllL+oMQJvGiL72rHjHf6yU
TA3qSR8X61vAgg/eUKxNVOImQb/Cc7bhKbGKWUt2oHHL+GB37r9ShyRxRpT6f1l2
SzR4BZ8LeJnbI9zrOLzMXFITm0UVbRP3FoxfSX2hOYZ/+1An5cz2XVCm/576SP33
tTw+vaK4D+De3DuVjhNemg6lVvIpbyGH144RHXUE0k5MWvqhcDFzyOVsBYMy7qSa
IO1b15a0UJU=
=Dk0/
-----END PGP SIGNATURE-----

--Sig_/CwvbvVyYmCkv.NgpGS21Z=d--
