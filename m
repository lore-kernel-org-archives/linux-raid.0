From: Doug Ledford <dledford@redhat.com>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 16:38:25 -0400
Message-ID: <1160512705.2917.159.camel@fc6.xsintricity.com>
References: <20061009125700.GA10191@piper.madduck.net>
	 <20061009134946.GA26122@harddisk-recovery.com>
	 <1160411520.2917.76.camel@fc6.xsintricity.com>
	 <20061010095524.GF7416@boogie.lpds.sztaki.hu>
	 <1160502476.2917.134.camel@fc6.xsintricity.com>
	 <20061010231828.72d68502.vsu@altlinux.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EYDwHgz7yOh9ctEPluwB"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061010231828.72d68502.vsu@altlinux.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Sergey Vlasov <vsu@altlinux.ru>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Erik Mouw <erik@harddisk-recovery.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-EYDwHgz7yOh9ctEPluwB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-10-10 at 23:18 +0400, Sergey Vlasov wrote:
> On Tue, 10 Oct 2006 13:47:56 -0400 Doug Ledford wrote:
>=20
> [...]
> > So, like my original email said, fsck has no business reading any block
> > that hasn't been written to either by the install or since the install
> > when the filesystem was filled up more.  It certainly does *not* read
> > blocks just for the fun of it, nor does it rely on anything the
> > filesystem didn't specifically write.
>=20
> There are fsck implementations which read potentially unwritten
> blocks.  E.g., reiserfsck --rebuild-tree reads every block on the
> device, finds anything which looks like a tree block and tries to
> do something with it.  This procedure sometimes recovers files
> which were deleted, and if an uncompressed image of a reiserfs v3
> filesystem was stored in a file on reiserfs, it can confuse
> reiserfsck badly...

Or if the disk was pulled from another machine that had a reiserfs on it
and then reformatted in the new machine with reiserfs, it could find old
blocks from the previous filesystem that point to possibly overwritten
data and give corrupted files.  Like I said, no program has any business
reading from unwritten blocks.  The "scan the whole disk looking for
something that might be something" heuristic is an easily breakable one
that I don't really give a rats ass about.  Besides, even in this
scenario, if it were *truly* a deleted file, then it *would* be in sync
between the disks and the point is moot.  It's only if it's random
garbage that might get interpreted as a deleted tree block that we have
the issue of whether it reads the data from one raid1 disk or another
and gets different results, and in that case we don't care, it's
garbage.  In fact, reiserfsck *could* read the block from multiple
constituent devices of a raid1 to check for any inconsistency, and
should it be spotted, use that knowledge to clue us in to the fact that
it's not a valid block for recovery.  And if we *did* do an initial sync
of the raid1 devices and the device we are syncing from is the one with
the old reiserfs on it, then we have now copied that bogus garbage to
all the disks and eliminated this possible clue as to the voracity of
the blocks we find.  I'd rather 0 the blocks out than copy them across
for this reason personally, but I think the option to zero the device
should be just that, an option and not the default, to avoid accidental
loss of data in cases where someone is converting a normal disk to a
raid1 disk and wants to sync the correct source to the destination(s).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-EYDwHgz7yOh9ctEPluwB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFLATBTzP9PM7pjw8RAvM4AJ9/4ZyDl/3rPvqf2JGZQyzLRRUtgwCfYc2Q
vV/8feQ0cHLtAXCRNcXd2wo=
=DOEz
-----END PGP SIGNATURE-----

--=-EYDwHgz7yOh9ctEPluwB--

