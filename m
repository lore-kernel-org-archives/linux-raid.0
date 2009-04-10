From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 21:59:42 +0100
Message-ID: <20090410205942.GC21242@cthulhu.home.robinhill.me.uk>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 10, 2009 at 01:45:00PM -0700, Timothy D. Lenz wrote:

> Great, for every bit of nudge forward I end up a step or two back. Not
> I have to figure out this copy stuff. Is there any easy way to do some
> sort of compair after cp/rsync to see if/what was missed? Creating yet
> another botable disk to get the copy over to the array would be a bit
> of a pain. Might be easyer to pull the hda from one computer, stick it
> in another or usb case and copy to a temp storage area. on the other
> computer. Then put the drive back and copy from the temp storage to
> the array over then network. Nether computer has any ftp or web
> servers or a desktop. The older computer with the 3 sata drives does
> have mysql installed because I started to mess with setting up mythtv
> but never finished.
>=20
The easiest option is to use a bootable CD - there's plenty of linux CDs
around (have a look at http://linuxiso.org - my preferred one is GRML)).
Otherwise, yes, putting the drive into another system and doing the copy
there would work fine.

> As for the other reply, the sata drives each have 3 primary partitions
> all set to type fd and formated with ext3. I was going to try ext4 for
> the main storage of the newer system but I found there is a problem
> with kernels .27 and newer on nforce2 and newer boards. some sort of
> problem with the bios and apci. How do I find out which superblocks
> version is used?
>=20
Either "mdadm -D" on the array, or "mdadm -E" on one of the partitions
will show you the version.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknfsz0ACgkQShxCyD40xBIGSgCgjf0d65B/onXGCE5YCtzzKMBi
ZBMAoMSrGwSiJVkSWVX3hiQAKr6LCwY0
=B+XI
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
