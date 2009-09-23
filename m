From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 17:10:45 +0100
Message-ID: <20090923161045.GD9409@cthulhu.home.robinhill.me.uk>
References: <20090923152927.GC9409@cthulhu.home.robinhill.me.uk>
 <840059.86859.qm@web38806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <840059.86859.qm@web38806.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Sep 23, 2009 at 08:44:41AM -0700, adfas asd wrote:

> --- On Wed, 9/23/09, Robin Hill <robin@robinhill.me.uk> wrote:
> > > My goal is to have two large drives in the HTPC and
> > two out in the
> > > garage NASed, in RAID10 so that if my HTPC is stolen
> > or there's a fire
> > > I'll still have my data.  But no one here seems
> > to know how to specify
> > > the HTPC drives as one side of the mirror and the
> > garage drives as the
> > > other. =20
> > >=20
> > You have two drives in RAID10 currently, and you want to go
> > to four.
> > Are you meaning to increase the capacity as well or do you
> > just want the
> > two remote drives to be a mirror of your current two
> > drives?
>=20
> Both more capacity, and remote storage.
>=20
Okay, so you want the local drives to be (effectively) a RAID-0, and
then mirrored to the remote drives?

>=20
> > > Needless to say I'd like performance to be good, but
> > that's starting
> > > to look hopeless.
> > >=20
> > I'd recommend getting two smaller drives, and having two
> > separate
> > mirrored pairs - the smaller array for the OS and database
> > and the
> > larger one for recording.  Keep one of each size
> > within the HTPC and one
> > of each in the garage.  You can also use the
> > write-mostly option to make
> > the kernel read from the local drives where possible.
>=20
> But what I'm saying there doesn't seem to be a way in mdadm to specify
> --one side-- of the mirror here, and the other side, there.
>=20
I've no idea what you mean here.  You specify two block devices for the
mirror - what difference does it make where (or what) they are?  And if
you want RAID10 then (in the create order) drives 0 and 2 are local and
1 and 3 remote.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq6SIQACgkQShxCyD40xBJNdQCgjq+urWSGIo1XbAdcPcOrqLVx
EkEAoLpVHTKncdqXWJJP+wZnX3rsfNap
=fXO3
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
