From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 made with assume-clean
Date: Thu, 7 Feb 2013 14:29:33 +0000
Message-ID: <20130207142933.GB16690@cthulhu.home.robinhill.me.uk>
References: <20130206115258.GA31466@animx.eu.org>
 <20130206130254.GA12118@cthulhu.home.robinhill.me.uk>
 <20130206145446.GA14892@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130206145446.GA14892@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 06, 2013 at 09:54:46AM -0500, Wakko Warner wrote:

> Please keep me in CC.
>=20
Then don't set the Mail-Followup-To header to point to the list,
otherwise you're strongly suggesting that you don't want to be CCed in
the replies.

> Robin Hill wrote:
> > On Wed Feb 06, 2013 at 06:52:58AM -0500, Wakko Warner wrote:
> >=20
> > > I was testing different parameters with --assume-clean to avoid the i=
nitial
> > > rebuild.  When I decided on the parameters I wanted, I forgot to crea=
te the
> > > array without --assume-clean.  I have 3 disks in the array.
> > >=20
> > > I thought that I'd run a check on it by doing
> > > echo check > /sys/block/md0/md/sync_action
> > >=20
> > > /proc/mdstat is showing this:
> > > Personalities : [raid1] [raid6] [raid5] [raid4]=20
> > > md0 : active raid5 sda1[0] sdb1[1] sdc1[2]
> > >       488018688 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3=
] [UUU]
> > >       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>........]  check =3D 61.7=
% (150688512/244009344) finish=3D7.1min speed=3D216592K/sec
> > >=20
> > > unused devices: <none>
> > >=20
> > > The thing is, the drives can only do ~60mb/sec and there is no disk
> > > activity.  The activity lights are not lit at all.  What would cause =
that?
> > >=20
> > What disks are they? I would expect a modern SATA disk to be able to
> > handle 120MB/s for sequential read, so 220 across the array would be
> > pretty normal.
>=20
> They are old WDC 250 disks.  I did a DD test on them, they are 60mb/sec. =
 A
> DD test on the array gives me about 119mb/sec.  As I stated, the activity
> lights did not even come on during the check.  Nothing was done.  This is
> kernel 3.3.0. =20
>=20
That does seem odd then. I've never seen that happen before. Has the
array been stopped & restarted since the initial creation? It may be
that having created it with --assume-clean is setting something which
short-circuits the check process.

> > > I was also wondering if the raid5 did RMW on the parity with 3 disks =
when
> > > the array is written to.
> > >=20
> > Not sure what the logic is on this. For a 3 disk array it'd need a
> > single read and 2 writes for a single chunk, whether it's doing RMW or
> > not. It will probably still do RMW though, as that avoids the
> > complication of special-casing things. I've had a quick look at the code
> > and I can't see any special casing (other than for a 2 disk array, where
> > the same data is written to both).
>=20
> I know there's 2 ways to update the parity.
> 1) Read the other data blocks, calculate parity, modify parity block.  Or
> 2) Read the parity, read the old data, calculate new parity, write parity.
>=20
> Obviously, with many disks, #2 is the best option.  With 3 disks, #1 would
> be the best option (IMO) especially when created with assume clean.
>=20
Performance-wise there's little difference (though #2 may be slightly
quicker as it avoids a seek on one disk), but #1 makes the code more
complex and will only help in really obscure situations.

> > > I can rebuild the array without assume-clean if that's the only way I=
 can
> > > get the parity to be correct, but I'd like to avoid doing that if pos=
sible.
> > >=20
> > That's definitely the safest option. If you can verify the data then you
> > could run a repair and a fsck before verifying/restoring the data, but
> > that'd take far longer than a simple rebuild and restore.
>=20
> The data I added was transfered from one LVM PV to this one with pvmove.=
=20
> One volume was DDd from the old disk that this array was replacing.  I sa=
ved
> the raw volume image to another server incase I messed something up (and =
the
> old disk was dying anyway)
>=20
> I really wanted to know the answer to the problem where check didn't work.
> If I recreate the array, I'll add another drive to the VG and move the
> volumes off, recreate and move back.
>=20
I'd suggest stopping & restarting the array (if this hasn't been done)
and rerunning the check (or just running a repair straightaway).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlETukwACgkQShxCyD40xBL2cQCdGy8GSQo6YekB5rws15ll0iUw
T4oAoKjW7zQsv8ab8qS8ibgH8YSX4CXo
=VW/k
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
