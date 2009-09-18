From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Fri, 18 Sep 2009 12:15:11 +0100
Message-ID: <20090918111511.GF22909@cthulhu.home.robinhill.me.uk>
References: <h8nfoe$n8p$3@ger.gmane.org>
 <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
 <h8nreb$n8p$4@ger.gmane.org>
 <87ws3z5iro.fsf@frosties.localdomain>
 <1253106813.17888.9.camel@localhost>
 <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
 <20090918082851.GD22909@cthulhu.home.robinhill.me.uk>
 <70ed7c3e0909180257hf13ba48va808b942deaba177@mail.gmail.com>
 <20090918102234.GE22909@cthulhu.home.robinhill.me.uk>
 <70ed7c3e0909180352m152e2237o2c449730660fc0ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3uUfsyyY1Pqa/ej"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0909180352m152e2237o2c449730660fc0ba@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--w3uUfsyyY1Pqa/ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 18, 2009 at 01:52:14PM +0300, Majed B. wrote:

> Well, I think my case is different Matthias's and I can't reconstruct
> the data anymore, as you said, Robin.
>=20
> So this leaves me with a degraded array with bad sectors and a dodgy
> filesystem.
>=20
> You see, I can mount the LVM Logical Volume (formatted with XFS), but
> as soon as I hit some bad sectors, XFS complains and then one of the
> array disks jump out.
> Just now, one disk exited the array and renamed itself from sdg to sdj
> .... (this is the first time this happens). According to smartctl -a
> /dev/sdj, there are no bad sectors, but I still get this in
> /var/log/messages
>=20
The renaming would suggest a hard bus reset - not what I'd expect with
just a bad block.

> Here's some info on smartctl -a /dev/sdg
>   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
>   7 Seek_Error_Rate         0x002e   100   253   000    Old_age
> Always       -       0
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
> Offline      -       0
>=20
A lot of these are only updated via offline tests, so won't change in
normal use, even if there are issues.  Have you run any SMART tests on
the disk?  The long test usually shows a failure if the disk has read
errors.

> Plan B: Since I cloned the disk with bad sectors to another, what
> would happen if I zeroed the damaged one then cloned the clone to it?!
>=20
Depends on what the actual condition of the disk is.  The zeroing should
remap any bad blocks though.

> I do realize that there will be zeros in the areas of bad sectors, but
> how will mdadm/md behave? Would a resync fail?
>=20
mdadm doesn't care what data is on it, as long as the array metadata is
valid.  Providing all disks are readable (and the new disk is writable)
then a resync would certainly work - whether the filesystem will be
usable afterwards depends on how many zeroed blocks there are and where
they fall.

> I can run fsck at that point and files residing on bad sectors will be
> the only affected ones, correct?
>=20
Files/directories yes - if the directory inodes get zeroed then all the
files within the directory will be affected (renamed & moved to
/lost+found).

I've had to do just this myself recently, and despite the low number of
zeroed blocks, there was an awful lot of filesystem damage (I ended up
restoring most of it from backup).


    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--w3uUfsyyY1Pqa/ej
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqza74ACgkQShxCyD40xBKOjQCfd4v9Kqsk0QUoLAuDIGJv2uzA
970AoJbbj1fJGo4J0OA5ZZcRT2f5i6L/
=/fsL
-----END PGP SIGNATURE-----

--w3uUfsyyY1Pqa/ej--
