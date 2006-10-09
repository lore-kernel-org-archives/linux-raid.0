From: Doug Ledford <dledford@redhat.com>
Subject: Re: avoiding the initial resync on --create
Date: Mon, 09 Oct 2006 17:45:15 -0400
Message-ID: <1160430315.2917.125.camel@fc6.xsintricity.com>
References: <20061009125700.GA10191@piper.madduck.net>
	 <20061009134946.GA26122@harddisk-recovery.com>
	 <1160411520.2917.76.camel@fc6.xsintricity.com>
	 <37950.192.168.0.1.1160421056.squirrel@bymeinc.com>
	 <1160423139.2917.112.camel@fc6.xsintricity.com>
	 <17706.49180.270321.212774@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WFAj9bjzO/mZU8TbPwdg"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17706.49180.270321.212774@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Rob Bray <raid@bymeinc.com>, martin f krafft <madduck@madduck.net>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-WFAj9bjzO/mZU8TbPwdg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-10-10 at 07:33 +1000, Neil Brown wrote:
> On Monday October 9, dledford@redhat.com wrote:
> >=20
> > The original email was about raid1 and the fact that reads from
> > different disks could return different data.
>=20
> To be fair, the original mail didn't mention "raid1" at all.  It did
> mention raid5 and raid6 as a possible contrast so you could reasonably
> get the impression that it was talking about raid1.  But that wasn't
> stated.

OK, well I got that impression from the contrast ;-)

> Otherwise I agree.  There is no real need to perform the sync of a
> raid1 at creation.
> However it seems to be a good idea to regularly 'check' an array to
> make sure that all blocks on all disks get read to find sleeping bad
> blocks early.  If you didn't sync first, then every check will find
> lots of errors.  Ofcourse you could 'repair' instead of 'check'.  Or
> do that once.  Or something.
>=20
> For raid6 it is also safe to not sync first, though with the same
> caveat as raid1.  Raid6 always updates parity by reading all blocks in
> the stripe that aren't known and calculating P and Q.  So the first
> write to a stripe will make P and Q correct for that stripe.
> This is current behaviour.  I don't think I can guarantee it will
> never changed.
>=20
> For raid5 it is NOT safe to skip the initial sync.  It is possible for
> all updates to be "read-modify-write" updates which assume the parity
> is correct.  If it is wrong, it stays wrong.  Then when you lose a
> drive, the parity blocks are wrong so the data you recover using them
> is wrong.

superblock->init_flag =3D=3D FALSE then make all writes a parity generating
not updating write (less efficient, so you would want to resync the
array and clear this up soon, but possible).

> In summary, it is safe to use --assume-clean on a raid1 or raid1o,
> though I would recommend a "repair" before too long.  For other raid
> levels it is best avoided.
>=20
> >=20
> > Probably the best thing to do would be on create of the array, setup a
> > large all 0 block of mem and repeatedly write that to all blocks in the
> > array devices except parity blocks and use a large all 1 block for that=
.
>=20
> No, you would want 0 for the parity block too.  0 + 0 =3D 0.

Sorry, I was thinking odd parity.

> > Then you could just write the entire array at blinding speed.  You coul=
d
> > call that the "quick-init" option or something.  You wouldn't be able t=
o
> > use the array until it was done, but it would be quick.=20
>=20
> I doubt you would notice it being faster than the current
> resync/recovery that happens on creation.  We go at device-speed -
> either the buss device or the storage device depending on which is
> slower.

There's memory overhead though.  That can impact other operations the
cpu might do while in the process of recovering.

>=20
> >                                                          If you wanted
> > to be *really* fast, at least for SCSI drives you could write one large
> > chunk of 0's and one large chunk of 1's at the first parity block, then
> > use the SCSI COPY command to copy the 0 chunk everywhere it needs to go=
,
> > and likewise for the parity chunk, and avoid transferring the data over
> > the SCSI bus more than once.
>=20
> Yes, that might be measurably faster.  It is the sort of thing you might
> do in a "hardware" RAID controller but I doubt it would ever get done
> in md (there is a price for being very general).

Bleh...sometimes I really dislike always making things cater to the
lowest common denominator...you're never as good as you could be and you
are always as bad as the worst case...

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-WFAj9bjzO/mZU8TbPwdg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFKsLrTzP9PM7pjw8RArP4AJ41kmNi0BG1dwL8PeOLx31qjK6RsQCdFv1o
ziSGFzKI4r32fbJHjB2cANA=
=UM1k
-----END PGP SIGNATURE-----

--=-WFAj9bjzO/mZU8TbPwdg--

