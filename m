From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] RFC: Use /dev/md/X as default name
Date: Thu, 19 Feb 2015 08:37:08 +1100
Message-ID: <20150219083708.2ab46006@notabene.brown>
References: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
	<wrfjsie36qdi.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ewTpMwX.ZWzkHPfv=/DDKWn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjsie36qdi.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ewTpMwX.ZWzkHPfv=/DDKWn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Feb 2015 13:12:09 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> Jes.Sorensen@redhat.com writes:
> > From: Jes Sorensen <Jes.Sorensen@redhat.com>
> >
> > I have received some issues for when creating an array using a
> > /dev/mdX name, the matching symlink in /dev/md/X isn't
> > created. Whereas if you create /dev/md/X, /dev/mdX is created
> > automatically.
> >
> > I was trying to see if there was a better way of dealing with this,
> > but I couldn't find one. If you have suggestions for a better solution
> > I am all ears.
> >
> > Thoughts?
>=20
> Hi Neil,
>=20
> Any thoughts on this one?

Thanks for the reminder....

I'm not sure that I really see the problem.

  "I ask it to create /dev/mdX and it doesn't create /dev/md/X".

Well ... no.  You didn't ask it to.  If you want it to create /dev/md/X,
then ... ask it to.

/dev/mdX is the canonical name.  It always gets created.
/dev/md/X is a convenient alias.  It gets created if requested.

Is there really a problem here worth solving?

Maybe I missed something.

NeilBrown

>=20
> Cheers,
> Jes
>=20
> >
> > Jes
> >
> > Jes Sorensen (1):
> >   mddev_create(): choose /dev/md/ name over /dev/mdX
> >
> >  mdopen.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ewTpMwX.ZWzkHPfv=/DDKWn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOUGBDnsnt1WYoG5AQI0FhAAkBUYlmNpdB7HwTc7ZtRUQf4X9qqADO/C
dg9vAobjMGqpmTPT8UrhdR+ITTATLLST2wQ2cMD47JDprGNSMl0Ud8fOmYLYLJ7Y
12/nTrUn0gXU2Av3VlEfcA014XK94RbjiUU/Hfzjjnm4/KZU13p+bR9XxXxI59xQ
nRYct50UnVw7/qhY+OnybaYWVE0M20CFcLZHxG96hWqEgMM69+TjbOBRiChdPt+u
8O56+7gDduQAeW0RwIwEIbRoQepy72D4ptoUIB9zN7hGdXeyvehCP0Ngd9NbxQmO
FPz6G1ow6Xv0oco1nr9/4Mf9GBkNAM1K83m1Sw3hJggoHMX6/FukHeH4XuORi33d
YjQh+IsLxuKhlUyXbNND80z5SSi2EaMDfSOxWTJzxFvbIWWxENu7xx5ZEqqUv8gx
T7iQvxIPvGQj3LCBo4hpggEOO3RwW3uXh73Dfp0B8PBeM9TPzWSfTzvoWWQd9tQ4
LlAG/b0UlbUoY32xEYXhobB0zSO5xlSR84/ewhJ+x5uLgTP1lEYdTMUCOAJjFEVI
7DC35sr5qklyCQW4IBlUYFDgD+kI3QzS51XWqzJZ4FttPqMUiDcl8wTsvEJhF2SF
1GiYoQ342+yG8+nhM8uocoLdFLkCz03e1wBoy/YF9CWuMa+/IjA2SBZNYfAlunYN
wcAlO1TxJyo=
=3k+f
-----END PGP SIGNATURE-----

--Sig_/ewTpMwX.ZWzkHPfv=/DDKWn--
