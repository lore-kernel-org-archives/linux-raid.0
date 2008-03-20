From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Redundancy check using "echo check > sync_action": error
	reporting?
Date: Thu, 20 Mar 2008 14:45:49 +0000
Message-ID: <20080320144549.GB28114@cthulhu.home.robinhill.me.uk>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47E2725C.1020206@tuxes.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 20, 2008 at 03:19:08PM +0100, Bas van Schaik wrote:

> Robin Hill wrote:
> > On Thu Mar 20, 2008 at 02:32:37PM +0100, Bas van Schaik wrote:
> >  =20
> >> Anyone able to answer the last and most important question: does it
> >> produce a message during resync in case of corruption? That would be g=
reat!
> >>    =20
> > There's no explicit message produced by the md module, no.  You need to
> > check the /sys/block/md{X}/md/mismatch_cnt entry to find out how many
> > mismatches there are.  Similarly, following a repair this will indicate
> > how many mismatches it thinks have been fixed (by updating the parity
> > block to match the data blocks).
> >  =20
> Marvellous! I naively assumed that the module would warn me, but that's
> not true. Wouldn't it be appropriate to print a message to dmesg if such
> a mismatch occurs during a check? Such a mismatch clearly means that
> there is something wrong with your hardware lying beneath md, doesn't it?
>=20
With a RAID5 then mostly, yes - there may be errors caused by transient
situations (interference, cosmic rays, etc) which are entirely
independent of the hardware.  With other RAID versions it's not quite as
clear cut.  For example with RAID1 it's possible for the in-memory data
to have been changed between writing to each disk (especially with swap
disks) - this isn't necessarily an issue (and certainly not a hardware
one).

> > I've no idea whether the checkarray script you're using is checking this
> > counter - there seems little point in having a special script if it
> > isn't though.
> >  =20
> If I understand the meaning of this counter, it would be sufficient to
> check the value of it _before_ the check operation and compare that
> value to the counter value _after_ the check. If the counter has
> increased: the check has encountered some inconsistencies which should
> be reported.
> Please correct me if I'm wrong!
>=20
Depends on what the previous operation was.  After a repair, the counter
will indicate the number of errors fixed, not the number remaining.
Theoretically, after a repair there will be no errors remaining, so any
value (> 0) in the counter after a check would indicate an issue to be
reported.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH4nibShxCyD40xBIRApWTAKC9OZO+NBIplm71BbX8j6s4npUv0QCcCxHj
VBpu+m2c0yqDcqvwsAQxvAM=
=si2a
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
