From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mdmon: allow disabling "@dmon" command name at
 compile time
Date: Wed, 28 Aug 2013 15:15:05 +1000
Message-ID: <20130828151505.222eaa0a@notabene.brown>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
	<1376677320-12816-7-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lrF.xwe+USmuZzIrXo86HAx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-7-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lrF.xwe+USmuZzIrXo86HAx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Aug 2013 20:22:00 +0200 mwilck@arcor.de wrote:

> mdmon sets its command name to "@dmon" on distributions using systemd
> to tell systemd not to kill it during shutdown.
>=20
> Some older tools (e.g. the anaconda loader on RHEL6 during installation)
> look specifically for "mdmon" and won't work with "@dmon". They can't be
> fixed any more. So, this patch introduces the macro SYSTEMD to disable
> changing the command name. Default is to assume that mdmon is started
> by systemd.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  Makefile |    4 +++-
>  mdmon.c  |    2 ++
>  2 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/Makefile b/Makefile
> index e8da3a5..5970b90 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -77,11 +77,13 @@ MAP_PATH =3D $(MAP_DIR)/$(MAP_FILE)
>  MDMON_DIR =3D $(RUN_DIR)
>  # place for autoreplace cookies
>  FAILED_SLOTS_DIR =3D $(RUN_DIR)/failed-slots
> +# set SYSTEMD to 1 for distributions where mdmon is started by systemd
> +SYSTEMD =3D 1
>  SYSTEMD_DIR=3D/lib/systemd/system
>  DIRFLAGS =3D -DMAP_DIR=3D\"$(MAP_DIR)\" -DMAP_FILE=3D\"$(MAP_FILE)\"
>  DIRFLAGS +=3D -DMDMON_DIR=3D\"$(MDMON_DIR)\"
>  DIRFLAGS +=3D -DFAILED_SLOTS_DIR=3D\"$(FAILED_SLOTS_DIR)\"
> -CFLAGS =3D $(CWFLAGS) $(CXFLAGS) -DSendmail=3D\""$(MAILCMD)"\" $(CONFFIL=
EFLAGS) $(DIRFLAGS)
> +CFLAGS =3D $(CWFLAGS) $(CXFLAGS) -DSendmail=3D\""$(MAILCMD)"\" $(CONFFIL=
EFLAGS) $(DIRFLAGS) -DSYSTEMD=3D$(SYSTEMD)
> =20
>  VERSION =3D $(shell [ -d .git ] && git describe HEAD | sed 's/mdadm-//')
>  VERS_DATE =3D $(shell [ -d .git ] && date --date=3D"`git log -n1 --forma=
t=3Dformat:%cd --date=3Dshort`" '+%0dth %B %Y' | sed -e 's/1th/1st/' -e 's/=
2th/2nd/' -e 's/11st/11th/' -e 's/12nd/12th/')
> diff --git a/mdmon.c b/mdmon.c
> index f0b0623..132b469 100644
> --- a/mdmon.c
> +++ b/mdmon.c
> @@ -298,6 +298,7 @@ int main(int argc, char *argv[])
>  		{NULL, 0, NULL, 0}
>  	};
> =20
> +#if (SYSTEMD =3D=3D 1)
>  	if (in_initrd()) {
>  		/*
>  		 * set first char of argv[0] to @. This is used by
> @@ -306,6 +307,7 @@ int main(int argc, char *argv[])
>  		 */
>  		argv[0][0] =3D '@';
>  	}
> +#endif
> =20
>  	while ((opt =3D getopt_long(argc, argv, "thaF", options, NULL)) !=3D -1=
) {
>  		switch (opt) {

Can you help me understand?  What is anaconda even looking for mdmon?
Does it need exactly "mdmon" or would "@mdmon" be OK?

Does "started by systemd" mean that "systemctl start mdmon@mdXXX.service" w=
as
used to start it?  In that case can't we put something in
systemd/mdmon@.service to make the right thing happen?

I'm going to hold off on this one for the moment.

All others applied.

Thanks,
NeilBrown

--Sig_/lrF.xwe+USmuZzIrXo86HAx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh2HWjnsnt1WYoG5AQJbHRAAiEbkn6+KWsMMpJ5a/hX35U3KgpmtAdCC
K7FO+/zeNXPKcKWtUwashMgkbdGlNQiAlD40uiVBl2CFgwoRAhkjrTsyeMvX6A/d
nahNuIAbRx6TmOQU6ejZ5inZcEw4PzqN/YT1EdXwXaJV8suAssJcyYEOnPSnD7K4
7YIZAXEvVTgJr9DefDs820HmCRKW1wBnBywRX54+/nDjshwki5S65htZC59SHt39
0ECQiXa9JRZjmQsEKPAGXMA9dQMz6nk1hbisEuhwavW3lV1/DeS0RsQZoiVy1+bd
sGYyFYkh1Vr3iZUCxVxBz0X3FfPwurF693iwi0jvXOW1m5Q0YjVSynDASdGh8iiH
vLrbqpC2fJ9G66glMt5wzUd41g1wkGF0EOP7Y1cMLPAAApYX185pG+d/kwLPUi0J
lDWgFv6PfKkRsClRy4Xkn7lnZtSqnyksfmTNbNY7IXT2bCPkcvZB0cp3oXhC8Rs4
Smj+l2ZLCRgucBNYLf+yFABX1GPf/8R+u45cjhPz08EZyBd90sruSPU4IOCIdv61
VIC5buxCTBQiNeVFnJxAm5OyIoFKe9MWRw+hLO8CXNhTR++NKYMWiQbJEQh8TpTJ
2GVsmJIQYoBj45s+9wcygZBTpjHQLkLV77JOVbQGkMDv6UQV4UeZ4HY5EDOWd35M
OiUXJloVZC0=
=yxoZ
-----END PGP SIGNATURE-----

--Sig_/lrF.xwe+USmuZzIrXo86HAx--
