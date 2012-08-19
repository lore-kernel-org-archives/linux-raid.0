From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Inexpensive RAID1 controller for home server?
Date: Mon, 20 Aug 2012 04:06:40 +0600
Message-ID: <20120820040640.5b4f77ac@natsu>
References: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com>
	<50306707.40302@hardwarefreak.com>
	<20120819153443.7f697ca6@natsu>
	<50315F39.2030404@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m42/BdWpBYh49xFz/i4I9C+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50315F39.2030404@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/m42/BdWpBYh49xFz/i4I9C+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Aug 2012 16:48:41 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> Yeah, you're right.  All Silicon Image ASICs suck.

"The only generic advice I can give you at this point) is to avoid
Silicon Image controllers, particularly their SATA controllers.  They
have a history of causing data corruption on Linux, FreeBSD, and
Windows, and some have reported other miscellaneous problems with them
as well."
http://lists.freebsd.org/pipermail/freebsd-questions/2008-October/185065.ht=
ml

> Roman has a beef with SiI.  It's unfounded and unsubstantiated

"I've had problems with XFS and EXT4 over the md device driver that turned =
out
to be a bug in the Silicon Image 3132 chipset.  It quietly corrupts data."
-- https://bbs.archlinux.org/viewtopic.php?id=3D115128

"...Sil3132 2-port SATA-card which couldn't handle heavy load on both ports.
Single port was fine, so preclear did not reveal any problems. I have one
working and one non-working coming from the same supplier and looking almost
exactly the same so it would be impossible to know before hand which card
make/model might cause problems. In this case random read errors were produ=
ced
for the two attached disks."
-- http://lime-technology.com/forum/index.php?topic=3D21052.0

"This might be the Sil3132 itself that's creating the problem. It's somewhat
notorious for corrupting data under high IO pressure. It's trivially easy to
trigger if you're using both ports at the same time, but I've seen similar
data corruption with just one port under active use."
-- http://arstechnica.com/civis/viewtopic.php?f=3D11&t=3D37779&start=3D1880

"There are confirmed problems within certain models of their SATA controlle=
rs
which cause silent data corruption and other issues, affecting Linux, FreeB=
SD,
and Windows. ... I'm not even willing to trust later revisions like the 312=
4;
not catching data corruption during QA/testing is simply unacceptable
regardless of what "class" of product it is.  I would be very surprised to
hear someone advocate use of Silicon Image controllers after reading the
above."
-- http://comments.gmane.org/gmane.os.freebsd.devel.hardware/6624

Etc, etc, etc. And here on this list:
http://comments.gmane.org/gmane.linux.raid/30629

> Believe who you wish.

Can fully agree with this. :)

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/m42/BdWpBYh49xFz/i4I9C+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAxY3AACgkQTLKSvz+PZwhEoACgjux9K9r5R918ZdlFZfs1cGlt
rHIAoJI1AaYKyq9KYZEKQr+dKZ91mH4U
=u5lq
-----END PGP SIGNATURE-----

--Sig_/m42/BdWpBYh49xFz/i4I9C+--
