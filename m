From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid over 48 disks
Date: Tue, 18 Dec 2007 18:45:08 +0000
Message-ID: <20071218184508.GA8744@cthulhu.home.robinhill.me.uk>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Dec 18, 2007 at 12:29:27PM -0500, Norman Elton wrote:

> We're investigating the possibility of running Linux (RHEL) on top of Sun=
's=20
> X4500 Thumper box:
>
> http://www.sun.com/servers/x64/x4500/
>
> Basically, it's a server with 48 SATA hard drives. No hardware RAID. It's=
=20
> designed for Sun's ZFS filesystem.
>
> So... we're curious how Linux will handle such a beast. Has anyone run MD=
=20
> software RAID over so many disks? Then piled LVM/ext3 on top of that? Any=
=20
> suggestions?
>
> Are we crazy to think this is even possible?
>
The most I've done is 28 drives in RAID-10 (SCSI drives, with the array
formatted as XFS).  That keeps failing one drive, but I've not had time
to give the drive a full test yet to confirm it's a drive issue.  It's
been running quite happily (under pretty heavy database load) on 27
disks for a couple of months now though.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHaBUzShxCyD40xBIRAjnuAJ9BiJ3Xw79vTJXbl5VM71GEjC5OOwCfVADi
lxJaBfFPaG/RcWzI4WtcB5M=
=U12m
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
