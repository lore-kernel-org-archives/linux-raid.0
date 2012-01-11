From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: Monitor sometimes crashes
Date: Thu, 12 Jan 2012 10:40:34 +1100
Message-ID: <20120112104034.15168a26@notabene.brown>
References: <20120111100408.686.15194.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EbGHlM7cvw+jIa/OOJw7rAz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120111100408.686.15194.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/EbGHlM7cvw+jIa/OOJw7rAz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jan 2012 11:04:08 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> The "char cnt [40]" buffer is sometimes too small to hold all message
> - in such case monitor crashes.
> The buffer must be larger to be able to hold all message.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Monitor.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 8bc8824..4352a0d 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -563,7 +563,7 @@ static int check_array(struct state *st, struct mdsta=
t_ent *mdstat,
>  		struct mdinfo *sra =3D
>  			sysfs_read(-1, st->devnum, GET_MISMATCH);
>  		if (sra && sra->mismatch_cnt > 0) {
> -			char cnt[40];
> +			char cnt[44];
>  			sprintf(cnt, " mismatches found: %d (on raid level %d)",
>  				sra->mismatch_cnt, array.level);
>  			alert("RebuildFinished", dev, cnt, ainfo);

Applied, thanks.
Plus I changed it to "snprintf" and made the 'cnt' even larger.
Should probably use asprintf there...

Thanks,
NeilBrown

--Sig_/EbGHlM7cvw+jIa/OOJw7rAz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTw4d8jnsnt1WYoG5AQJt3xAAs34un1IT6RRTH5/Fr2ucI1MUdPd4pPha
2D+cHDCDHKC7S41xE8gOsJUQnR0DPfF7z0uJBx5M/TzBBoXlAsGp/6TjWf9hYRUO
XdAfYeAki23jwdGgk1gZYIr7sfFPQfPaGcpHafX5wyXuBf5EGoqbUlWYL24n8cws
SW67FH0iPNGoUovauI5X8eiiGz8ceWKbEinZtLXaRGHU28ikUKSMt2ZmK9wN3iqL
xHoUW4UFya3sWIBF0inqP+o71l9Kff9D/QvjqmNJ/40E7ve4vid5AKUNhfc6Ui96
WLtjoQmkycMu4WPvntsdPx5rkiCpyMqKEvFawvBJrl4p4u+gBX/bNc32y1vikLJl
j4h2XYRXP3HA/qCzH0FPt87qaC9xi9dt6sYpt/UHttQeI6dlHwLIUr6lyJupsNF6
5ZByYbYdT225sfyPGoA+uUbZTV39IZUsM+tfyhi8JALvGt6DiWQEZ+w983JPh1mU
KHGBAL0N+Le/2p1dFaQkt6FImwBY9eXqxu8L5YZySj/mXba+5ep2BkeH+xNpIEi5
FT29p9cv79144Bw3vmVCjLJEkkIfRzg62CsvzIQiCx4ACkyKPN7x/bRN94cTqKAG
XtSEzgLo7JXnlR8mb/KRNWH/6qwqV2xgaCK5Oh3WsJBkm/GSAZr+dpdnIOdvoL6P
LAhqYSOKjnk=
=ErcE
-----END PGP SIGNATURE-----

--Sig_/EbGHlM7cvw+jIa/OOJw7rAz--
