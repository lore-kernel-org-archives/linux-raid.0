From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Do not set default 'before.layout' when reshaping from
 RAID4 to RAID4
Date: Thu, 12 Jun 2014 17:35:14 +1000
Message-ID: <20140612173514.279a6118@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918CE9@IRSMSX105.ger.corp.intel.com>
	<20140602123021.1184b461@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F07925A6B@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u1Mv.2naxOpH_EV.avVCY4u"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F07925A6B@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/u1Mv.2naxOpH_EV.avVCY4u
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jun 2014 15:18:44 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> > On Monday, June 02, 2014 4:30 AM NeilBrown wrote:
> > To: Baldysiak, Pawel
> > Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> > Subject: Re: [PATCH] Do not set default 'before.layout' when reshaping =
from
> > RAID4 to RAID4
> >=20
> > On Fri, 30 May 2014 14:38:09 +0000 "Baldysiak, Pawel"
> > <pawel.baldysiak@intel.com> wrote:
> >=20
> > > Commit fdcad551e9a54c4aa8c4b63160b76e2c539a0441
> > > brings some changes to reshape process.
> > > Setting 'before.layout' when reshaping from RAID4 to another RAID4 is
> > > not really necessary.
> > > If reshape is restarted 'before.layout' will be compared with
> > > 'info->array.layout' in reshape_array(). Changes brought by mentioned
> > > commit will cause this comparation return as false, becouse 'array.la=
yout'
> > > is always set to 'ALGORITHM_PARITY_N' in analyse_change() for RAID4,
> > > so reshape will not be continued after reboot/stop.
> > > This patch reverts unnecessary changes.
> > >
> > > Signed-off-by: Pawel Baldysiak pawel.baldysiak@intel.com
> > > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > >
> > > ---
> > > Grow.c | 1 -
> > > 1 file changed, 1 deletion(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 487111e..9dc157a 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -1338,7 +1338,6 @@ char *analyse_change(char *devname, struct
> > > mdinfo *info, struct reshape *re)
> > >
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (re->level) {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 4:
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re->before.layout =
=3D 0;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re->after.layout =
=3D 0;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 5:
> >=20
> > Applied, thanks.  Though you seem to have forgotten how to make patches
> > properly.  That one was totally white-space damaged.
> >=20
> > NeilBrown
>=20
> Hi Neil,
> Sorry for this white-space damage one again...

(it seems that git doesn't like "Return" characters at the end of each line
either ... fortunately they are easy enough to strip out).

> There is mistake in patch applied to your repository - wrong line is remo=
ved.
> Below is the patch, which fixes this issue:

Thanks.  Applied.

NeilBrown


>=20
> Pawel Baldysiak
>=20
> From: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Date: Wed, 11 Jun 2014 16:54:59 +0200
> Subject: [PATCH 1/1] Grow: fix removal of line in wrong case
>=20
> Commit 18d9bcfa33939cee345d4d7735bc6081bcc409c8
> removed wrong line (in case RAID0->RAID4).
> This patch corrects this mistake
> (line should be removed in case RAID4->RAID4).
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Grow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 12730e2..a2f4f14 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1324,6 +1324,7 @@ char *analyse_change(char *devname, struct mdinfo *=
info, struct reshape *re)
> =20
>  		switch (re->level) {
>  		case 4:
> +			re->before.layout =3D 0;
>  			re->after.layout =3D 0;
>  			break;
>  		case 5:
> @@ -1339,7 +1340,6 @@ char *analyse_change(char *devname, struct mdinfo *=
info, struct reshape *re)
> =20
>  		switch (re->level) {
>  		case 4:
> -			re->before.layout =3D 0;
>  			re->after.layout =3D 0;
>  			break;
>  		case 5:


--Sig_/u1Mv.2naxOpH_EV.avVCY4u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5lYMjnsnt1WYoG5AQIDuA//Y1XmPcU1BywNLkkCEuPUPF835ZCUZMGR
LbfZaTCDo5yS93W88GeEexJRBx8EvDWpak9oH8TbdwZa5JB0zdHYaWKPPzZ5IkOX
RKYxuLurbtQWb3MidLN9or4qCVDoBkWMFGn5R5bHUtrIGZwjA+71dNWbXl65uzj5
RunQgoAQD9hJ7RkuGcqJ1TbXHSzuLDorWgSZsedgCsY9/ijFiICjuIYJxk81urvY
OLAichfb3MgUxcvugnsnqLyxxI7WCkPLDbnuGyEs6TvS8F+QsRjhkDBP0HbUQ5o0
7OHgFu+xEs3TvYdp1ZBeJWU2p205F9XJwdmAJW77X7NoQDNuwVb/Ki2d/kTGevY6
odFEfrtH++UZ0PM0VvT2p6rwJp1gyQgwNsq1NQP+8dJoEUGeLGbmTnW9tM34NGZi
0VWLrrKXEA2pjNa9tO0cUg8NCO1R6tzYTtyLZFM3V1MLLMmg4aDbYJgHJ2OSyBHC
YNUS39Or17sKClpDyFiq9/tYrIkghL+cOMdyaxkY3B/bf8T8TYp0Dr69P7lOZWZV
bC7QmgkpMgUVsVYpYqhecix72ZsKIKp0NvhhZANqBiGzIN1q9zVaNoAA+T4VKeov
s2R67PKKo6RGzbuoPtxdLdNHKl/1+uPxT3U8/SMvkr3aV/fqtp9952v+gXT1ytR+
JwGCbtdGmcw=
=WPfH
-----END PGP SIGNATURE-----

--Sig_/u1Mv.2naxOpH_EV.avVCY4u--
