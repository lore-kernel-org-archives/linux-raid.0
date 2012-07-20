From: NeilBrown <neilb@suse.de>
Subject: Re: commit backport request
Date: Fri, 20 Jul 2012 12:58:34 +1000
Message-ID: <20120720125834.62c67b94@notabene.brown>
References: <20120709140230.3cf926ec@notabene.brown>
	<1342065131.25597.352.camel@deadeye.wl.decadent.org.uk>
	<CA+sTkh6Nnfx3OAF0CN0CfRCUHUg2XEtivY-DmTXrRGwnPLgY2Q@mail.gmail.com>
	<1342496902.11373.33.camel@deadeye.wl.decadent.org.uk>
	<CA+sTkh43mpEiL5bUhx=tak3gO+Mg1W3-3A3zbScR8op2iKKyXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zhxoYYd=W6hdwf98aVN7zhC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh43mpEiL5bUhx=tak3gO+Mg1W3-3A3zbScR8op2iKKyXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org, stable@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>
List-Id: linux-raid.ids

--Sig_/zhxoYYd=W6hdwf98aVN7zhC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Jul 2012 10:38:50 +0800 Igor M Podlesny <for.poige+lsr@gmail.com>
wrote:

> On 17 July 2012 11:48, Ben Hutchings <ben@decadent.org.uk> wrote:
> > On Tue, 2012-07-17 at 11:26 +0800, Igor M Podlesny wrote:
> >> On 12 July 2012 11:52, Ben Hutchings <ben@decadent.org.uk> wrote:
> >> > On Mon, 2012-07-09 at 14:02 +1000, NeilBrown wrote:
> >> [...]
> >> > Queued up for 3.2.y, thanks.
> >> >
> >> > Ben.
> >>
> >>    Hm, it looks like 3.2.23 misses it =E2=80=94 at least my during reb=
ase the
> >> cherry-picked fix applied again cleanly.
> >
> > I queued it up some hours after tagging that release.  I *announced* the
> > release later, but that's because uploading tarballs etc. involves a
> > round trip via Greg.
> >
> > Ben.
>=20
>    JFYI, 3.4.6 doesn't have it either...
>=20
> commit 1c8f63c2758096c3b6425f4ecb274901151d6f17
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Thu Jul 19 12:11:49 2012 -0700
>=20
>     Linux 3.4.6
>=20
> --


Yes it does.

commit 5bbbd747918d241b41f3220ff26323d7ed943c52
Author: Shaohua Li <shli@kernel.org>
Date:   Tue Jul 3 15:57:19 2012 +1000

    raid5: delayed stripe fix
   =20
    commit fab363b5ff502d1b39ddcfec04271f5858d9f26e upstream.

NeilBrown

--Sig_/zhxoYYd=W6hdwf98aVN7zhC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAjJWjnsnt1WYoG5AQLYAQ/9F+i/4CGqQecDjpexW6x73krfZ2IoNJFA
rqZnOmOsFKlxHeT2RPKA1eTLFr3JFNqNBeGOEFxjBJXyP5OM4beRhrxkSpw3Skdn
imLHyspJIbzUPuIUMxAzgKSlZiolqtQebW03+xHQUqVhUkD9Mc1rZLYEuzTi/UGH
SBb3xHsPY7XWb4AaYi5+u/vN/8+6JOove4bTAPzjW83BSNib5ut3VH7orJ6ssvI1
l3qNDIprUZChxc7tB//G2WLr74v203zVsxIyZMvA6ADU2YpiAnzdW+NG4LheR0lI
p53TxMGKW3HFWAX3l86B02cCwBSe5PDZxSJkDupJulxzoRvmBSFK5/HqJFe62Tvc
A4YBzdF8j86K1lAhJurJfWtlwR3QUxUXqMFdC6Sb0O71v3qqsyG8nZAOEGBiLYwH
pe6jcsq+1azVFaiCBItVup6LxkvGi3popmb21J9qHPC9fZ6OS5mqtY8rKUNKNGXV
DVrHlIURB+L32+j8xZsIT1t4JY1EBPRkRb5kS2dmOZmVSIml42DnYKOR301H3nMY
eL5N19UMa2S+49F75PaJHbpqt7yM2vVcct33fMNnk2Yxz+ZCmrGlDqmfsanubw+I
00aox7+QzLbP1wsJ98n1ZTpn4UtJjjR0MwFg4942CD9ghV15mXSxc6r4CUUdHsbv
onsJpzBcJEQ=
=QJFi
-----END PGP SIGNATURE-----

--Sig_/zhxoYYd=W6hdwf98aVN7zhC--
