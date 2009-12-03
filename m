From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: /etc/cron.weekly/99-raid-check
Date: Thu, 3 Dec 2009 09:53:09 +0000
Message-ID: <20091203095309.GA31212@cthulhu.home.robinhill.me.uk>
References: <lfarkas@lfarkas.org>
 <200912021538.nB2FcgM8003851@wind.enjellic.com>
 <f19d625d0912030111t6fa5ab9ep8e3c2dd14e99ad9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f19d625d0912030111t6fa5ab9ep8e3c2dd14e99ad9b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Dec 03, 2009 at 12:11:29PM +0300, CoolCold wrote:

> > The current RAID/IO stack does not 'pin' pages which are destined to
> > be written out to disk. =A0As a result the contents of the pages may
> > change as the request to do I/O against these pages transits the I/O
> > stack down to disk.
>=20
> Can you write a bit more about  "the pages may change"? 'Who' can
> change page contents ?
>=20
My understanding of this is:
    - An application maps a file to memory.
    - It makes some modifications.
    - The kernel flags the md layer to write these changes to disk.
    - The md layer writes to one copy of the RAID1.
    - The application makes some more modifications.
    - The md layer writes to the second RAID1 copy (getting different
      data).
    - The kernel flags the md layer to write the new changes.
    - The md layer writes both copies.

The second set of writes can go to a different section of the disk, so
you're left with the (now unused) blocks being different on the disk.
There's no data problem, as the kernel always flags the md layer to
write _after_ the data's changes, and the md layer always writes the
data _after_ the kernel notifies it.

Note: I've not looked at the code for any of this, so I don't _know_
that this is what's happening, but that's my understanding from what
I've read on here in the past.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksXioUACgkQShxCyD40xBJZDwCfQSZ04a9avk0PuTv8Hvq1v6vf
u0UAn2wercnTZ2tV6JeQjpCSWHcJAped
=KhFz
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
