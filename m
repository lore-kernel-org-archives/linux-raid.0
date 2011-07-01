From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Fri, 1 Jul 2011 12:29:16 +0100
Message-ID: <20110701112915.GB22611@cthulhu.home.robinhill.me.uk>
References: <4E0C5539.4030000@gmx.de>
 <4E0C5E47.5090604@anonymous.org.uk>
 <4E0C6CC4.3030506@turmel.org>
 <4E0C7196.1070307@gmx.de>
 <4E0C7B4B.7090404@turmel.org>
 <4E0C8685.3020806@gmx.de>
 <20110701072855.69ee763b@notabene.brown>
 <iujspj$jgg$1@dough.gmane.org>
 <20110701085044.GA22611@cthulhu.home.robinhill.me.uk>
 <iuk70t$emh$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <iuk70t$emh$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jul 01, 2011 at 12:18:22PM +0200, David Brown wrote:

> On 01/07/2011 10:50, Robin Hill wrote:
> > On Fri Jul 01, 2011 at 09:23:43 +0200, David Brown wrote:
> >
> >> What's the difference between a "resync" and a "recovery"?  Is it that=
 a
> >> "resync" will read the whole stripe, check if it is valid, and if it is
> >> not it then generates the parity, while a "recovery" will always
> >> generate the parity?
> >>
> >  From the names, recovery would mean that it's reading from N-1 disks,
> > and recreating data/parity to rebuild the final disk (as when it
> > recovers from a drive failure), whereas resync will be reading from all
> > N disks and checking/recreating the parity (as when you're running a
> > repair on the array).
> >
> > The main reason I can see for doing a resync on RAID6 rather than a
> > recovery is if the data reconstruction from the Q parity is far slower
> > that the construction of the Q parity itself (I've no idea how the
> > mathematics works out for this).
> >
>=20
> Well, data reconstruction from Q parity /is/ more demanding than=20
> constructing the Q parity in the first place (the mathematics is the=20
> part that I know about).  That's why a two-disk degraded raid6 array is=
=20
> significantly slower (or, more accurately, significantly more=20
> cpu-intensive) than a one-disk degraded raid6 array.
>=20
> But that doesn't make a difference here - you are rebuilding one or two=
=20
> disks, so you have to use the data you've got whether you are doing a=20
> resync or a recovery.
>=20
Yes, but in a resync all the data you have available is the data
blocks, and you're reconstructing all the P and Q parity blocks. With a
recovery, the data you have available is some of the data blocks and some
of the P & Q parity blocks, so for some stripes you'll be reconstructing
the parity and for others you'll be regenerating the data using the
parity (and for some you'll be doing one of each).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk4Nr4sACgkQShxCyD40xBKg7wCbB3+44XAq7r+1qC5zGdKGZmRs
bKcAmgKhHmA8CTPaxOPaLAn7ebVQ1P1B
=C4pL
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
