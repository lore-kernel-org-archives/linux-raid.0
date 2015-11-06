From: Neil Brown <neilb@suse.com>
Subject: Re: [PATCH] md/raid5: remove redundant check in stripe_add_to_batch_list()
Date: Fri, 06 Nov 2015 11:42:32 +1100
Message-ID: <87vb9g9cw7.fsf@notabene.neil.brown.name>
References: <1446458813-6502-1-git-send-email-klamm@yandex-team.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446458813-6502-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 02 2015, Roman Gushchin wrote:

> The stripe_add_to_batch_list() function is called only if
> stripe_can_batch() returned true, so there is no need for double check.
>
> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> Cc: Neil Brown <neilb@suse.com>
> Cc: linux-raid@vger.kernel.org
> ---
>  drivers/md/raid5.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 45933c1..f829ebc 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -768,8 +768,6 @@ static void stripe_add_to_batch_list(struct r5conf *c=
onf, struct stripe_head *sh
>  	int hash;
>  	int dd_idx;
>=20=20
> -	if (!stripe_can_batch(sh))
> -		return;
>  	/* Don't cross chunks, so stripe pd_idx/qd_idx is the same */
>  	tmp_sec =3D sh->sector;
>  	if (!sector_div(tmp_sec, conf->chunk_sectors))
> --=20
> 2.4.3

applied, thanks.

(for future reference, public mailing lists like linux-raid aren't
usually mentioned on a 'Cc:' line in a patch.
Documentation/SubmittingPatches suggests:

  If a person has had the opportunity to comment on a patch, but has not
  provided such comments, you may optionally add a "Cc:" tag to the patch.
  This is the only tag which might be added without an explicit action by t=
he
  person it names - but it should indicate that this person was copied on t=
he
  patch.  This tag documents that potentially interested parties
  have been included in the discussion.

so it is primarily for third-party individuals
)

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWO/d4AAoJEDnsnt1WYoG5tZcQAJDKAZVyzCi8pVCccCQjou9F
wsXWBuY40+0Rhc6nbmJtbb/JU/uIPPkrWQyyHFNvE+V1NiR8Ta9eMK3RkJE2gXEL
B0aR16nqn0Nc97860sHYtJvkhFfWtxj1cz1I6GnMXnkFUTsLSfzykX7fX8HdBDdS
3AH3msQeeyNcTBRFvZzbITxR33nPmvcOz3O32WvlbDRecERJzAFR8PnAv6tDPXcD
+sxMRhGrfzDR3U+Llae09ir1bu2/WjU9mzg1KjLLZ4Go9BZNxjzvucbzaydL8Q/c
rFEYHSILJhWvWilQgTpkNy66BHvJyIx4Y564b1sgqLpAOaLpPTLQ7swUKy8+6R/5
vP7UUYLdYaAnE1/NLHJbwlZDmRE7Yol/pj0dhqhIlfzPIhXD+dsnAXNN32SLiuZz
iuEgjvGuGxxVxiTpzzIk381QZzH2XpT4jEum0kqbhUp12MOHkonl4zOBtZ3RTA4V
5k1EwySQegpp911dHUagRR4GkQX7k2qMXMZCjBlFAf8H7TYA6xuCtlThOr1HrfjS
ZBJqzCokuvmn/IxCbNdAgPjmqBFZ0j02V+qu0rL/Ul/TqlQjenk6mTf4TRnPcRu/
shLh0rux6Z6pp8N8KAF96PfAQunXcRDH1P6w3lxq7jWsCKzQO8KMBigotZLPCo92
qwwy62bw+O7BdRdp9Dg0
=h0e2
-----END PGP SIGNATURE-----
--=-=-=--
