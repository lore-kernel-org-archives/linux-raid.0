From: NeilBrown <neilb@suse.de>
Subject: Re: Compiler mdadm-3.2.5 error
Date: Mon, 21 May 2012 12:09:04 +1000
Message-ID: <20120521120904.2cc23e55@notabene.brown>
References: <201205210951075780388@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vbm9hzq._xniZM+vphYE.k6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205210951075780388@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Vbm9hzq._xniZM+vphYE.k6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012 09:51:19 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> Hi neil:
> 	I git-pull mdadm and compiled but met error like this:
>=20
> In file included from super0.c:27:
> sha1.h:29:22: error: ansidecl.h: No such file or directory
> make: *** [super0.o] Error 1

You need to install binutils-dev.  It provides ansidecl.h

Though maybe I could remove the #include, as you say it doesn't seem to be
needed.

NeilBrown

>  			=09
> uname -a
> Linux nfs-server.example.com 2.6.18-194.el5 #1 SMP Fri Apr 2 14:58:14 EDT=
 2010 x86_64 x86_64 x86_64 GNU/Linux
>=20
> gcc -v
> Using built-in specs.
> Target: x86_64-redhat-linux
> Configured with: ../configure --prefix=3D/usr --mandir=3D/usr/share/man -=
-infodir=3D/usr/share/info --enable-shared --enable-threads=3Dposix --enabl=
e-checking=3Drelease --with-system-zlib --enable-__cxa_atexit --disable-lib=
unwind-exceptions --enable-libgcj-multifile --enable-languages=3Dc,c++,objc=
,obj-c++,java,fortran,ada --enable-java-awt=3Dgtk --disable-dssi --enable-p=
lugin --with-java-home=3D/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre --with-cpu=
=3Dgeneric --host=3Dx86_64-redhat-linux
> Thread model: posix
> gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)
>=20
>=20
> I remove the ansidecl.h in shal.h.Then compile success.
> In shal.h:
> #include "ansidecl.h"
> So the ansidecl.h may in mdadm, not a system head-file.
> But I rewrite it:
>  #include <ansidecl.h>
> But compiled error too.
>=20
>=20
> --------------
> majianpeng
> 2012-05-21


--Sig_/Vbm9hzq._xniZM+vphYE.k6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7mjwTnsnt1WYoG5AQK00g/9HLfm6a2ukU058zO804a/e6zTVqTKoWCx
QCyrZKZlDxREEkm/A30VBRcGZypzONyFalwebQUvJ4NQRdiiNQBtj4HGjATn0m1E
oYBOKvRVPNN5T+ObXjVwt/uYHpQZmWnlL/awzwmR0unYeEeZPkZAGO+2AK7CWgYz
p/fkx0+w13a3YOrOBwWysMsAZRrU/z+zr0PaLQUsgMTWRJwS5flQZQ+p45NmNnC1
5Xfhw+hdGFi2j4ErtV0p85g7U1fRLUVsXgKZLBQqPXOFPVhrVFnJKLQJSosNgqGz
4WSv0TDQa2SfFwAjA0Be7GdrA0TMAUffl3AiDn9dTtUIfIGHOEzlvq2i5XhCO0oA
H68IwRFbj50usYWVogd+8LtJ0fqH8DmOa1tWABYM8OuVjpT+gw4E2YH6hBAsAnLq
AN5o+R3xEpR78FQhk+xPkGPdUFz07f4ZDNvqDiHSHh2p9+inl77fE2x71MhNRwiV
f6m25hUhXBEqXULzXrm8DKjpVGAc57KXDbtLeoQIwxJRyEniR+akyVPK+jmPqgU9
8qGrNXklOlQ/212+t+i5BMaatIhjFR4NW5s06g9Awn03Gum+MwWqRIqplYrB5/I8
H37QoiE3O6PkKQLhhikaVDiO8LrWepzK/UdkXvwZ7pOHe9q9TPr11kvfvgtB2Ulj
ThcQQIRq6wo=
=ni6o
-----END PGP SIGNATURE-----

--Sig_/Vbm9hzq._xniZM+vphYE.k6--
