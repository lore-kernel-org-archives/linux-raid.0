From: Doug Ledford <dledford@redhat.com>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 13:47:56 -0400
Message-ID: <1160502476.2917.134.camel@fc6.xsintricity.com>
References: <20061009125700.GA10191@piper.madduck.net>
	 <20061009134946.GA26122@harddisk-recovery.com>
	 <1160411520.2917.76.camel@fc6.xsintricity.com>
	 <20061010095524.GF7416@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C/CGpkNvmInrQsFywrme"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061010095524.GF7416@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Erik Mouw <erik@harddisk-recovery.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-C/CGpkNvmInrQsFywrme
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-10-10 at 11:55 +0200, Gabor Gombas wrote:
> On Mon, Oct 09, 2006 at 12:32:00PM -0400, Doug Ledford wrote:
>=20
> > You don't really need to.  After a clean install, the operating system
> > has no business reading any block it didn't write to during the install
> > unless you are just reading disk blocks for the fun of it.
>=20
> What happens if you have a crash, and fsck for some reason tries to read
> into that uninitialized area? This may happen even years after the
> install if the array was never resynced and the filesystem was never
> 100% full... What happens, if fsck tries to read the same area twice but
> gets different data, because the second time the read went to a
> different disk?
>=20
> And yes, fsck is exactly an application that reads blocks just "for the
> fun of it" when it tries to find all the pieces of the filesystem, esp.
> for filesystems that (unlike e.g. ext3) do not keep metadata at fixed
> locations.

Not at all true.  Every filesystem, no matter where it stores its
metadata blocks, still writes to every single metadata block it
allocates to initialize that metadata block.  The same is true for
directory blocks...they are created with a . and .. entry and nothing
else.  What exactly do you think mke2fs is doing when it's writing out
the inode groups, block groups, bitmaps, etc.?  Every metadata block
needed by fsck is written either during mkfs or during use as the
filesystem data is grown.

So, like my original email said, fsck has no business reading any block
that hasn't been written to either by the install or since the install
when the filesystem was filled up more.  It certainly does *not* read
blocks just for the fun of it, nor does it rely on anything the
filesystem didn't specifically write.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-C/CGpkNvmInrQsFywrme
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFK9zMTzP9PM7pjw8RAj+OAJ0cYIgAb8t7tKthJV4cB1OtNLKK4wCbB8WA
RdD+hTSuyLqjS/XqC4F8Cew=
=h+6y
-----END PGP SIGNATURE-----

--=-C/CGpkNvmInrQsFywrme--

