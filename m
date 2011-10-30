From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid use after free
Date: Mon, 31 Oct 2011 10:43:58 +1100
Message-ID: <20111031104358.24632497@notabene.brown>
References: <1319831451-26704-1-git-send-email-Jes.Sorensen@redhat.com>
	<1319831451-26704-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nqDvMb.tHzUWUKv_ZWcgyNm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319831451-26704-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

--Sig_/nqDvMb.tHzUWUKv_ZWcgyNm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2011 21:50:50 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> If picking just one spare disk from the container, jump out of the
> loop once freeing the list. Otherwise we end up accessing the list
> that we just freed.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  util.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/util.c b/util.c
> index 2cf617d..1bbd87f 100644
> --- a/util.c
> +++ b/util.c
> @@ -1766,6 +1766,7 @@ struct mdinfo *container_choose_spares(struct super=
type *st,
>  			if (get_one) {
>  				sysfs_free(*dp);
>  				d->next =3D NULL;
> +				goto out;
>  			}
>  		} else {
>  			*dp =3D d->next;
> @@ -1773,5 +1774,6 @@ struct mdinfo *container_choose_spares(struct super=
type *st,
>  			sysfs_free(d);
>  		}
>  	}
> +out:
>  	return disks;
>  }


Hi Jes,
  I dont' think patch is needed.
  The while loop that it jumps out of is
    while (*dp)

  at the place you put the goto,
     dp =3D=3D &d->next
  As d->next was just set to NULL, *dp will be NULL, so the loop will
  exit with the need for a goto.

 I have applied the second patch - the GPT stack overflow one, thanks.

NeilBrown


--Sig_/nqDvMb.tHzUWUKv_ZWcgyNm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq3hPjnsnt1WYoG5AQKUtw/9GZPcNles3kQleMFGJKLqO6gk8cav5xPQ
Jitk/RakcN5u3ZtpFdpOonn27bzhnYPSpDzkmTTNhLhO+WkBN7r8Q7w/BUp4BWbC
JwqLilXPnkeJfXthXcpk/1uuLqlEG7lU04a5AwNjS88mqKcWWmJDztEepFaQd3fh
GpjlshgVbeVyrQfs2GmAss93u7YVEoP3wHCClaXyGqvbmGnfeJVuI6gT5k+SHyYg
frG1rajnHccLx4779yO+O6IYYSeM8OmQTHaBBoTaFGfOzJZw2Q0oSBiNRaLpicJa
z/FoUfA0ch/2Q0xMY15OFJVViQUV2N8TgDibGm7a7eDG/KdBFmtwchoZk+NsVzP8
xMpyl6VTNrYr2dp0bDcp1qNP3j/xWrPwLfUz06rmXf3GPicJXMN+7fzxGDikCeZ0
B2rvH1srFoZ7YcCPiG9zQ4tgj8mZryVsJhZPHifMZMU+LE7REclIhJHuoY7VPdEW
Qy8zfCiz/0rlzRIJ8Ghc/xMGheFi86qVhska0kHCL27hMzy6012+g8hnc89V20Hd
Uk2rCQxTbg5r/cHkQuRvzylKyB5ZQ0tO8mw1qqzTj5QaQgfazZpy0eq8KbY6/MzX
pLrvY2izSQu90eZA743DjxSbzCUZurF2avL5WYszQACK1Az4U57bfoi5V7iDLDzn
NgZcnyw4a0s=
=uEe2
-----END PGP SIGNATURE-----

--Sig_/nqDvMb.tHzUWUKv_ZWcgyNm--
