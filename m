From: NeilBrown <neilb@suse.de>
Subject: Re: Clone failed
Date: Mon, 11 Aug 2014 12:59:09 +1000
Message-ID: <20140811125909.3e936159@notabene.brown>
References: <192555642.20505182.1407722576334.JavaMail.zimbra@redhat.com>
	<270921245.20505628.1407722766562.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GqrvP_e7kTIXu2JiwjUsfN6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <270921245.20505628.1407722766562.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GqrvP_e7kTIXu2JiwjUsfN6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Aug 2014 22:06:06 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:

> Hi all
>=20
>    Could you help me about this? I tried to git clone git://git.neil.brow=
n.name/md.git.
> But it always failed. I tried to search the way to resolve this, but I do=
n't find the=20
> right method.
>=20
> [root@dhcp-12-129 aprilava]# git clone git://neil.brown.name/md
> Initialized empty Git repository in /home/neil/md/.git/
> remote: fatal: Out of memory, realloc failed
> remote: aborting due to possible repository corruption on the remote side.
> fatal: early EOF
> fatal: index-pack failed
>=20
>    What should I do? Could you help me?
>=20

You would probably be more successful if you cloned linux from some local g=
it
tree and then just 'fetch'ed or 'pull'ed from my tree.

It seems that fetching the full tree now requires over a gigabyte of memory
on the server, and my VM only had that much.
I've added some swap so it should cope now if you really want to clone
entirely from my tree.

NeilBrown

--Sig_/GqrvP_e7kTIXu2JiwjUsfN6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+gxfTnsnt1WYoG5AQI9NA//S6ab8RO084mWmoPPMLgEAmFzCpDOJTMG
rgK7CxM+T0slutfhIzQ7WVvMG0kygw35x2Js34f2KdV7kUO5usEKGAF9QcQwZSsI
NMIxCbPFIoJwv9vmSXe0Pz9h9yWfEnVltl0xT0qlfAqvE9kgSRxY86ZOlC9OMoDk
R5aU0SDab1ER3s5DywtUTk05xubQcDitRRVZxgCjTGfpS0VlN8aiOVj5Ui4pbFcj
i02o5D+QFKFBo0huanGqnl8QW+6RIwrbv56HwoSNPP+3q9MvOQXie0PKqI7SvdcR
h6LIRy8zb8/ucAdWM3jYlGRqybgNUIbRes7XcH6roLeqJj3catiWindnt1XTGIJ6
PT25xNs7v4CsVpwF4T4/yMtzwNoru0eHFLI49kvgy35sU/+mZL03sb2OJXrn3vIc
1TPzN29p+eRFJpa2bFv2OcwAhd59gnE034GkE3V3FXMfNl0sH/adocIuqCpIhPKv
4pYMh/1EBoz6izdhgzuqGo6Xr/KKijGS7mWQiFnElO5Y6/HcKofX4Y6PczY5BYCN
/Mzd7uIeLj6ITtx6SJLhXGfJTt5pNSlfFFmaqkGs30lqzeEbIFcWMsnzIuQKTqXD
ihm1BBKGyzwAoBy0ZX2pszWYaB+LignFwDaKKR84EDyLF4mVomCiSt0JrxnOlRr4
LQ6a5b+fhDM=
=9rPE
-----END PGP SIGNATURE-----

--Sig_/GqrvP_e7kTIXu2JiwjUsfN6--
