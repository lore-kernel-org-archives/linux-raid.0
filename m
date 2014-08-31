From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Seeking help to get a failed RAID5 system back to life
Date: Sun, 31 Aug 2014 12:15:48 +0100
Message-ID: <20140831111548.GA25561@cthulhu.home.robinhill.me.uk>
References: <CAGgRf0Qe1EU6wZm4BbWqs0diwwnBCeStiVAXaOdHV88Ttn=vfw@mail.gmail.com>
 <20140829074627.GA8321@cthulhu.home.robinhill.me.uk>
 <CAGgRf0TZG28nGAHsvZzLkPhYv422GC=r5-km=6OL5-5EXJZQjQ@mail.gmail.com>
 <20140829091018.GB8321@cthulhu.home.robinhill.me.uk>
 <CAGgRf0RXPcmzN3Bk2uj3UJyNzRxy2p2ijBwgaG=xns=CeC8Nfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGgRf0RXPcmzN3Bk2uj3UJyNzRxy2p2ijBwgaG=xns=CeC8Nfg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Fabio Bacigalupo <info1@open-haus.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Aug 31, 2014 at 11:12:44am +0200, Fabio Bacigalupo wrote:

> 2014-08-29 11:10 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
> > You'll need to use --assemble --force in order to get the array going
> > again afterwards (as the event counts are different on the two disks).
>=20
> I finally got my RAID array back up and running. Thank you for your
> guidance, Robin. There is one last question. The third drive just to
> be /dev/sda3 which is now occupied by the system disk. If I add
> another disk (a new one) into system it will be /dev/sdd. What do I
> need to do to add this to the RAID array? Can it fill the unsed slot
> [_UU] or do I have to add it as a new drive to get something like this
> [_UUU] ?
>=20
You'll need to copy the partition info over from one of the existing
array members, then just use --add to add it into the array - it will
fill in the unused slot. md doesn't care what the kernel disk
order/naming is at all, it uses the RAID metadata to figure out which
disk goes where in the array.

Glad to hear you've got it all back up and running anyway.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQDA+MACgkQShxCyD40xBLH+wCgrWi9LmOPNyiJIqS1vo/A5Vl4
OjYAn0E9wJW8pywkTiKSO64XXgA4VfVv
=dJu2
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
