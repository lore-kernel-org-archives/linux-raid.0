From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 15:08:10 +0100
Message-ID: <20110826140810.GB13709@cthulhu.home.robinhill.me.uk>
References: <4E5787A1.7080807@xunil.at>
 <20110826125653.GA13709@cthulhu.home.robinhill.me.uk>
 <4E57A4D5.3070004@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E57A4D5.3070004@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: "Stefan G. Weichinger" <lists@xunil.at>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, robin.hill47@ntlworld.com
List-Id: linux-raid.ids


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Aug 26, 2011 at 03:51:17PM +0200, Stefan G. Weichinger wrote:

> Am 26.08.2011 14:56, schrieb Robin Hill:
>=20
> > This would indicate that sdb has been reset as a spare, suggesting=20
> > that the resync failed so it has left sda alone in the array (as=20
> > failing it would destroy the array).
>=20
> oh my ...
>=20
> So the array is somehow split-brain now? Some sectors good here, some
> there??
>=20
> Why is sda4 now flagged as (S)? Is it a spare or not?
> I don't fully understand the current state of the array ...
>=20
sda4 is still in the array, with some unreadable sectors. sdb4 is a
spare because the resync failed due to unreadable sectors on sda4. You
cannot add a disk to an array unless the data can all be read (or
recovered if there's still enough redundancy).

> > I'd suggest stopping the array and using ddrescue to clone sda4 to=20
> > sdb4. That'll copy everything possible, flagging up any read
> > issues. You'll then need to run a "fsck -f" on sdb4 to clear up
> > any filesystem damage. You may still be left with damaged/missing
> > files, depending on where any read errors occurred. How critical
> > this is will depend on what the filesystem is used for (and whether
> > you have any backup).
>=20
> I am rather scared to do so ... as I am ~50kms away from the box now,
> and as it seems to be working fine so far (though there are currently
> no users working with it).
>=20
It'll work fine unless something attempts to read from any of the
unreadable sectors on sda4. If these are not used by the filesystem
currently, then you may never run into an issue (as they'll get remapped
if a write error occurs when they do get used).

> As mentioned /dev/md2 doesn't contain a filesystem itself, but is the
> single PV in a LVM-volumegroup.
>=20
> This group contains 6 logical volumes ...
>=20
> As far as I understand it might be possible to spot the defective
> sectors and the related LV?
>=20
A read of the relevant block device (dd if=3D/dev/xxx of=3D/dev/null) will
result in read errors for whichever block device contains the bad
sectors. You could also probably map the sectors reported by the kernel
to the position on the disk to tell what LV it.

> I have backups, yes ...
>=20
In which case the absolute safest option is just to recreate whatever
arrays, PVs, LVs, etc. on sdb4 and restore the data, ignoring whatever's
on sda4 currently.

> > If that all works okay, then get sda replaced and give it a
> > thorough badblocks and SMART test.
> >=20
> > I'd also advise setting up regular array checks (echo check >=20
> > /sys/block/mdX/md/sync_action) to make sure the disks are checked=20
> > and any unreadable blocks repaired/mapped out _before_ they're
> > needed for recovery.
>=20
> re-adding sda4 and starting such a check would be possible?
> Or would a re-add damage things?
>=20
You can't add sda4 because it's already in the array.

> Should I shutdown the box for safety?
>=20
For absolute safety, yes, though I don't think the risk is too high at
the moment, and I don't think things'll get any worse in the short term.

> I am really feeling unsafe now, and getting another hdd for swapping
> will take me at least until monday.
>=20
> (I would like to dd-rescue to another new disk to keep sdb, just in case)
>=20
I doubt you'd be able to recover anything useful from sdb4 at the
moment, but that's up to you.


--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5XqMkACgkQShxCyD40xBITYACcDVXYAyJZZta4w/pbBRihAJ0O
XZMAn0COXKudUGoxQhA7ZJ8o8BtAzkeC
=qwfx
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
