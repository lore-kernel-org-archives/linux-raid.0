From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: devices get kicked from RAID about once a month
Date: Fri, 4 Jun 2010 14:50:31 +0100
Message-ID: <20100604135031.GA5092@cthulhu.home.robinhill.me.uk>
References: <628039470-1275491015-cardhu_decombobulator_blackberry.rim.net-326486810-@bda837.bisx.prod.on.blackberry>
 <876321o3lm.fsf@uwo.ca>
 <4C067AD6.7040700@anonymous.org.uk>
 <871vcpo0n6.fsf@uwo.ca>
 <4C069813.3010308@tmr.com>
 <87sk55mijx.fsf@uwo.ca>
 <4C07DA4E.70501@tmr.com>
 <87eigom5as.fsf@uwo.ca>
 <20100604073304.1d669f45@notabene.brown>
 <874ohjlyce.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874ohjlyce.fsf@uwo.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jun 04, 2010 at 09:30:09AM -0400, Dan Christensen wrote:

> Neil Brown <neilb@suse.de> writes:
>=20
> > On Thu, 03 Jun 2010 12:47:39 -0400 Dan Christensen <jdc@uwo.ca> wrote:
> >
> >> That could be useful.  And, as Neil said, if the SATA driver could be
> >> told to use longer timeouts, that might help.  Neil, if you think that=
's
> >> a good idea, maybe you could put the request in with the SATA folks?
> >
> > It might be a good idea.
>=20
> After thinking about it more, I'm not sure I fully understand the
> situation. =20
>=20
> If I was able to turn on something like TLER on the drives, so read
> errors failed more quickly, what would the raid layer do when it got
> a read error?=20
>=20
It reconstructs the data and attempts a write.  A write failure will
then fail the drive.

> If the raid layer handles this in a clever way (and I recall some
> discussions about this), e.g. by reconstructing the data and rewriting
> the sector allowing the drive to remap it, then what I don't fully
> understand is why it doesn't also do this when there is a timeout on a
> read.  Is it because timeouts can indicate more serious problems?  Even
> so, wouldn't it be reasonable for the raid layer to give the drive a
> second chance before assuming it has failed?
>=20
It does exactly the same on the read timeout.  The problem is that when
it sends the write, the drive is still busy attempting the read, so
ignores the write request (until it's free).  This then times out as
well, so the array assumes the drive has failed.

> These questions are motivated from the following logic.  Since it is
> generally recognized that quicker read errors (e.g. TLER) are good
> for drives in a raid array, *increasing* the SATA timeouts seems like it
> is going in the wrong direction.  Wouldn't it be better to have short
> timeouts, but have the raid layer treat a timeout less seriously?
>=20
As has been stated, the RAID layer doesn't have any timeouts.  It's the
SCSI/ATA layer which is timing out the read/write and reporting a
failure to the RAID layer.  If the timeout at this level is increased
sufficiently then either the read will eventually succeed, or it'll
still fail but the write will then succeed (as the drive is no longer
busy) (or the write will fail and the disk is really failed).  The
downside is that the increased delay could run into timeouts at other
levels, but these are likely to be less severe than randomly failed
drives.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkwJBKYACgkQShxCyD40xBLJLQCcCKUtAXc7htJWiGTp7TXuZQPL
N/MAn3fLfB3SCrOW8q6PnZvp91Zx7t5D
=tNJ6
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
