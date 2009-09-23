From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 16:29:27 +0100
Message-ID: <20090923152927.GC9409@cthulhu.home.robinhill.me.uk>
References: <20090923075710.GA9409@cthulhu.home.robinhill.me.uk>
 <9510.91067.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9510.91067.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Sep 23, 2009 at 07:52:59AM -0700, adfas asd wrote:

>=20
> --- On Wed, 9/23/09, Robin Hill <robin@robinhill.me.uk> wrote:
> > > Commercial flagging is writing like hell to the array,
> > according to
> > > iotop.  I don't know how else to assess what's
> > going on.  The drives
> > > are constantly hammering, and my Myth menu moves get
> > very slow during
> > > flagging, even with the latest 2TB disk drives and
> > RAID10.
> > >=20
> > Are you transcoding as well?  The flagging itself
> > shouldn't write, but
> > if you're transcoding as well (to cut the commercials) then
> > it will have
> > to write.  And slow menu moves would suggest
> > database/CPU holdups -
> > there should be no need to read from the recordings disk
> > (actually, it
> > may have to check the file exists, but that's it).=20
> > You didn't say
> > whether your database is on the array or not (if you're
> > booting from the
> > array then I'd guess so though).
>=20
> Not transcoding at the same time, just the standard commercial
> flagging.  The drive light is constantly on.  CPU is pretty busy
> (3GHz) reaching 180% when simultaneously flagging 2 videos.
>=20
> The database in in the / partition of the array, and the videos are in
> the /home partition on it.  No idea why the array is so busy.
>=20
If they're both on the array, then that's the problem.  The partitioning
doesn't make difference to the issue - the drive heads are having to
seek frantically between reading the data file and writing the database.

>=20
> > If your aim is to improve performance then I'd recommend
> > using a single
> > (relatively small) drive for the main OS and database, and
> > then one (or
> > more) drives for the recordings.
>=20
> My goal is to have two large drives in the HTPC and two out in the
> garage NASed, in RAID10 so that if my HTPC is stolen or there's a fire
> I'll still have my data.  But no one here seems to know how to specify
> the HTPC drives as one side of the mirror and the garage drives as the
> other. =20
>=20
You have two drives in RAID10 currently, and you want to go to four.
Are you meaning to increase the capacity as well or do you just want the
two remote drives to be a mirror of your current two drives?

> Needless to say I'd like performance to be good, but that's starting
> to look hopeless.
>=20
I'd recommend getting two smaller drives, and having two separate
mirrored pairs - the smaller array for the OS and database and the
larger one for recording.  Keep one of each size within the HTPC and one
of each in the garage.  You can also use the write-mostly option to make
the kernel read from the local drives where possible.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq6PtYACgkQShxCyD40xBIqYQCg0FentV3J3Y+UOooLlRtDrI6f
aswAn2sAHMBZbr1m+tle603mokVQmQy7
=jbYI
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
