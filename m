From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] query udev dir via pkg-config
Date: Tue, 14 Aug 2012 09:47:59 +1000
Message-ID: <20120814094759.51b8e2c2@notabene.brown>
References: <1344879862-23299-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7zeItxB.1x0UI8AesO7J0u."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1344879862-23299-1-git-send-email-vapier@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-raid@vger.kernel.org, Samuli Suominen <ssuominen@gentoo.org>
List-Id: linux-raid.ids

--Sig_/7zeItxB.1x0UI8AesO7J0u.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 13:44:22 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> From: Samuli Suominen <ssuominen@gentoo.org>
>=20
> Since udev is moving its internal dir around, query it via pkg-config
> rather than hardcoding the old path.  This should work with new/old
> versions.
>=20
> Signed-off-by: Samuli Suominen <ssuominen@gentoo.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  Makefile |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/Makefile b/Makefile
> index 72f609e..a3e4027 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -57,6 +57,8 @@ else
>   DEFAULT_METADATA=3D1.2
>  endif
> =20
> +PKG_CONFIG ?=3D pkg-config
> +
>  SYSCONFDIR =3D /etc
>  CONFFILE =3D $(SYSCONFDIR)/mdadm.conf
>  CONFFILE2 =3D $(SYSCONFDIR)/mdadm/mdadm.conf
> @@ -96,6 +98,11 @@ MAN4DIR =3D $(MANDIR)/man4
>  MAN5DIR =3D $(MANDIR)/man5
>  MAN8DIR =3D $(MANDIR)/man8
> =20
> +UDEVDIR :=3D $(shell $(PKG_CONFIG) --variable=3Dudevdir udev 2>/dev/null)
> +ifndef UDEVDIR
> + UDEVDIR =3D /lib/udev
> +endif
> +
>  OBJS =3D  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib=
.o \
>  	Manage.o Assemble.o Build.o \
>  	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
> @@ -255,7 +262,7 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
>  	$(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
> =20
>  install-udev: udev-md-raid.rules
> -	$(INSTALL) -D -m 644 udev-md-raid.rules $(DESTDIR)/lib/udev/rules.d/64-=
md-raid.rules
> +	$(INSTALL) -D -m 644 udev-md-raid.rules $(DESTDIR)$(UDEVDIR)/rules.d/64=
-md-raid.rules
> =20
>  uninstall:
>  	rm -f $(DESTDIR)$(MAN8DIR)/mdadm.8 $(DESTDIR)$(MAN8DIR)/mdmon.8 $(DESTD=
IR)$(MAN4DIR)/md.4 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5 $(DESTDIR)$(BINDIR)/md=
adm


Applied - thanks....

So where is /lib/udev being moved to?

NeilBrown


--Sig_/7zeItxB.1x0UI8AesO7J0u.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCmSLznsnt1WYoG5AQIqKBAAgT7IzYXuInu+k1LEKpwohkFzny/MbgxG
T8xMed7+6jcxoLCJANGYGeIO59lbCwkEFC6Xe0hv0h2Ua+qeLNxCsCKjHzoBWRSY
+ZlBpgPN6r3C+fMzNtD2x6HF8diPojDDdzTG5tr1TzLJUoqNx3OjhDcdC9WDBWGk
vOt2X2RiubENKO/m51Be5b/EDWlv+xPUWZ9UTscrNeXNrwtn2GeOBes8Fhcbi7IV
YIW7d3JV8lPNVWTePzuuBD9RcbUfSmdxenkNu5JVmSJVPCzjb7b/N9jTPG4L7bkz
/WEZPgGuXh2m0bcn1pgWBXdBLtqTXOOrzUzkIr48QfPmy4gBAD7NHE6HoYvtJOSU
AKzbPLd8+qLz8N0BoWdv3dj0B2JyvjV2CRzHvkPbig4SJKpwsTycp4IcIFV5Tg4A
oexM/jCgPPPs6uBlTkpYqM+hXDZ7cO87DvVk+mGUmFJqel7ROsitEUnXaeCOcmW4
tWmCFCIizWFcZjFZ2xFy7yrK++QMa+Kiov0paLGbozu+NDaScnF9KK6L5TbNkQzt
3/qtKCeex5PFOKSuqQVRaNPe/au81DjysQ5/YOgODfj4lLOLD0fnN01BPxBL+Lnc
HuWkm3NTyiQxhKTpGF6uYOoQRyKXg50+e8vKiDTAfbIwQf9pKhN2DymO4CbJk3U8
AvWN8j0HP9E=
=nfwO
-----END PGP SIGNATURE-----

--Sig_/7zeItxB.1x0UI8AesO7J0u.--
