From: NeilBrown <neilb@suse.de>
Subject: Re: build-sys: do not depend on check_rundir for executables
Date: Sun, 5 Oct 2014 07:58:09 +1100
Message-ID: <20141005075809.5a72700e@notabene.brown>
References: <1412443628.428300.8315.nullmailer@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YowEtf25Ub/HkWQ8mbmD/hX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1412443628.428300.8315.nullmailer@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YowEtf25Ub/HkWQ8mbmD/hX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 04 Oct 2014 21:27:08 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> The problem is that the link lines will always be executed
> even if the executables are up to date.
>=20
> If anything, this check_rundir should be a dependency of
> install target, or some other "phony" target like this,
> since check_rundir is phony by itself.
>=20
> Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
>=20
> --- a/Makefile
> +++ b/Makefile
> @@ -172,7 +172,7 @@ everything-test: all mdadm.static swap_super test_str=
ipe \
>  # mdadm.uclibc and mdassemble.uclibc don't work on x86-64
>  # mdadm.tcc doesn't work..
> =20
> -mdadm : check_rundir $(OBJS)
> +mdadm : $(OBJS)
>  	$(CC) $(CFLAGS) $(LDFLAGS) -o mdadm $(OBJS) $(LDLIBS)
> =20
>  mdadm.static : $(OBJS) $(STATICOBJS)
> @@ -195,7 +195,7 @@ mdmon.O2 : $(MON_SRCS) $(INCL) mdmon.h
>  	$(CC) -o mdmon.O2 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -DHAV=
E_STDINT_H -O2 -D_FORTIFY_SOURCE=3D2 $(MON_SRCS)
> =20
>  # use '-z now' to guarantee no dynamic linker interactions with the moni=
tor thread
> -mdmon : check_rundir $(MON_OBJS)
> +mdmon : $(MON_OBJS)
>  	$(CC) $(CFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -Wl,-z,now -o mdmon $(MON_OBJ=
S) $(LDLIBS)
>  msg.o: msg.c msg.h
> =20
>

Thanks for the report... I might fix it like this.

NeilBrown

diff --git a/Makefile b/Makefile
index f058a22ee2dc..a7d8c5c1b7fa 100644
--- a/Makefile
+++ b/Makefile
@@ -153,7 +153,7 @@ ASSEMBLE_SRCS +=3D $(ASSEMBLE_AUTO_SRCS)
 ASSEMBLE_FLAGS +=3D -DMDASSEMBLE_AUTO
 endif
=20
-all : check_rundir mdadm mdmon
+all : mdadm mdmon
 man : mdadm.man md.man mdadm.conf.man mdmon.man raid6check.man
=20
 check_rundir:
@@ -172,7 +172,7 @@ everything-test: all mdadm.static swap_super test_strip=
e \
 # mdadm.uclibc and mdassemble.uclibc don't work on x86-64
 # mdadm.tcc doesn't work..
=20
-mdadm : check_rundir $(OBJS)
+mdadm : $(OBJS) | check_rundir
 	$(CC) $(CFLAGS) $(LDFLAGS) -o mdadm $(OBJS) $(LDLIBS)
=20
 mdadm.static : $(OBJS) $(STATICOBJS)
@@ -195,7 +195,7 @@ mdmon.O2 : $(MON_SRCS) $(INCL) mdmon.h
 	$(CC) -o mdmon.O2 $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -DHAVE_=
STDINT_H -O2 -D_FORTIFY_SOURCE=3D2 $(MON_SRCS)
=20
 # use '-z now' to guarantee no dynamic linker interactions with the monito=
r thread
-mdmon : check_rundir $(MON_OBJS)
+mdmon : $(MON_OBJS) | check_rundir
 	$(CC) $(CFLAGS) $(LDFLAGS) $(MON_LDFLAGS) -Wl,-z,now -o mdmon $(MON_OBJS)=
 $(LDLIBS)
 msg.o: msg.c msg.h
=20


--Sig_/YowEtf25Ub/HkWQ8mbmD/hX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDBfYTnsnt1WYoG5AQICsg//XyHgrIUgjagaNiysHfKPsT92SgKRifL5
uU4jrtI7LnV1ubCfMn7RG9M3mDiQK+pTxHVLJIjL1XQfTk2JsDUPJn4Mgztsx1N/
Hp+sU1dq77QRr88LNaWC/njhM7WWcGgu3vugOz8bdk7S8w4csfOrTxEvxKkkecbg
a2hXxEdh7zBeQS4D1siuaK4FY789HHUViFmlW2nTeQXubmgAZbICQ3fIYjFRXBMu
yiPS+V90x//C0t7CJaWP61IV6qlK1wP6x4Mjk4j54QmPK5LWffD1/6pcGg80rPFE
sV2Ceaz836PMKZczVV9jYag35wVU16Tg6e2pM+TKjdWrNqWnV/O0DTjJyg3bSOX/
YeZ0NCRzDjbFT/u39e7DQ+YVbohRFKtkHgk/IXKja4cGNU3YKwZXDLPKcs/4W4S+
KWXPAAlpsIMeF/WZFdxlcj7kW/TsyYkTeX/GcEHT4YTkqtVb7UOpRXkmmO86I2yo
PEZI/xadZ2A1I/3nBthpSlX96pzlU76x4MQ7SZ9dJdhEgkM1ffSDCvrrk3jM94yt
cdRlg7YF44VQHknEkp+24JfbqHtonnRaMue6lHBeol35pBo6kfngnRHRFNnkWdt+
jzocDO63xkOcWh5BhtxMFhjjxVGqcTi3UbphWfukahbZf/Z7k6SBnxNid+q8+LFp
J6iPaDLaJ0o=
=1Fep
-----END PGP SIGNATURE-----

--Sig_/YowEtf25Ub/HkWQ8mbmD/hX--
