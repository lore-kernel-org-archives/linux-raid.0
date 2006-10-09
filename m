From: Doug Ledford <dledford@redhat.com>
Subject: Re: avoiding the initial resync on --create
Date: Mon, 09 Oct 2006 15:45:39 -0400
Message-ID: <1160423139.2917.112.camel@fc6.xsintricity.com>
References: <20061009125700.GA10191@piper.madduck.net>
	 <20061009134946.GA26122@harddisk-recovery.com>
	 <1160411520.2917.76.camel@fc6.xsintricity.com>
	 <37950.192.168.0.1.1160421056.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ilIhT3bjI31G1wULJygQ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37950.192.168.0.1.1160421056.squirrel@bymeinc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Rob Bray <raid@bymeinc.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-ilIhT3bjI31G1wULJygQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-10-09 at 15:10 -0400, Rob Bray wrote:
> > On Mon, 2006-10-09 at 15:49 +0200, Erik Mouw wrote:
> >
> >> There is no way to figure out what exactly is correct data and what is
> >> not. It might work right after creation and during the initial install=
,
> >> but after the next reboot there is no way to figure out what blocks to
> >> believe.
> >
> > You don't really need to.  After a clean install, the operating system
> > has no business reading any block it didn't write to during the install
> > unless you are just reading disk blocks for the fun of it.  And any
> > program that depends on data that hasn't first been written to disk is
> > just wrong and stupid anyway.
>=20
> I suppose a partial-stripe write would read back junk data on the other
> disks, xor with your write, and update the parity block.

The original email was about raid1 and the fact that reads from
different disks could return different data.  For that scenario, my
comments are accurate.  For the parity based raids, you never have two
disks with the same block, so you would only ever get different results
if you had a disk fail and the parity was never initialized.  For that
situation, you would need to init the parity on any stripe that has been
even partially written to.  Totally unwritten stripes could have any
parity you want since the data is undefined anyway, so who cares if it
changes when a disk fails and you are reconstructing from parity.

> If you benchmark the disk, you're going to be reading blocks you didn't
> necessarily write, which could kick out consistency errors.

The only benchmarks I know of that give a rats ass about the data
integrity are ones that write a pattern first and then read it back.  In
that case, parity would have been init'ed during the write.

> A whole-array consistency check would puke on the out-of-whack parity dat=
a.

Or a whole array consistency check on an array that hasn't had a whole
array parity init makes no sense.  You could create the array without
touching the parity, update parity on all stripes that are written,
leave a flag in the superblock indicating the array has never been
init'ed, and in the event of failure you can use the parity safe in the
knowledge that all stripes that have been written to have valid parity
and all other stripes we don't care about.  The main problem here is
that if we *did* need a consistency check, we couldn't tell errors from
uninit'ed stripes.  You could also make it so that the first time you
run a consistency check with the uninit'ed flag in the superblock set,
you calculate all parity and then clear the flag in the superblock and
on all subsequent runs you would then know when you have an error as
opposed to an uninit'ed block.

Probably the best thing to do would be on create of the array, setup a
large all 0 block of mem and repeatedly write that to all blocks in the
array devices except parity blocks and use a large all 1 block for that.
Then you could just write the entire array at blinding speed.  You could
call that the "quick-init" option or something.  You wouldn't be able to
use the array until it was done, but it would be quick.  If you wanted
to be *really* fast, at least for SCSI drives you could write one large
chunk of 0's and one large chunk of 1's at the first parity block, then
use the SCSI COPY command to copy the 0 chunk everywhere it needs to go,
and likewise for the parity chunk, and avoid transferring the data over
the SCSI bus more than once.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-ilIhT3bjI31G1wULJygQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFKqbjTzP9PM7pjw8RAggwAJ9g+wOrZuSb9W5WAHAb4De/kpi7bgCeO8ZF
eYSZjPdR9IBYCh5Ka1HjPGk=
=fOLS
-----END PGP SIGNATURE-----

--=-ilIhT3bjI31G1wULJygQ--

