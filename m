From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: replacing drives
Date: Wed, 8 May 2013 18:01:41 +0100
Message-ID: <20130508170141.GA22065@cthulhu.home.robinhill.me.uk>
References: <517A8EB5.8080100@supsi.ch>
 <20130426155347.GA9928@cthulhu.home.robinhill.me.uk>
 <5183E592.6020409@supsi.ch>
 <20130507075340.GA25772@cthulhu.home.robinhill.me.uk>
 <518A5EF5.5090808@supsi.ch>
 <20130508151019.GA20347@cthulhu.home.robinhill.me.uk>
 <518A77CC.2040001@supsi.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <518A77CC.2040001@supsi.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Nunnari <roberto.nunnari@supsi.ch>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed May 08, 2013 at 06:05:32 +0200, Roberto Nunnari wrote:

> Robin Hill wrote:
> > On Wed May 08, 2013 at 04:19:33PM +0200, Roberto Nunnari wrote:
> >=20
> >> Robin Hill wrote:
> >>> On Fri May 03, 2013 at 06:28:02PM +0200, Roberto Nunnari wrote:
> >>>
> >>>> Robin Hill wrote:
> >>>>> The safest option would be:
> >>>>>  - add in the new disks
> >>>>>  - partition to at least the same size as your existing partitions =
(they
> >>>>>    can be larger)
> >>>>>  - add the new partitions into the arrays (they'll go in as spares)
> >>>>>  - grow the arrays to 4 members (this avoids any loss of redundancy)
> >>>>>  - wait for the resync to complete
> >>>>>  - install grub/lilo/syslinux to the new disks
> >>>>>  - fail and remove the old disk partitions from the arrays
> >>>>>  - shrink the arrays back down to 2 members
> >>>>>  - remove the old disks
> >>>>>
> >>>>> Then, if you're keeping the same number of partitions but increasin=
g the
> >>>>> size:
> >>>> Ok.. got here.
> >>>>
> >>>>>  - grow the arrays to fill the partitions
> >>>>>  - grow the filesystems to fill the arrays
> >>>> Now the scary part.. so.. here I believe I should give the following=
=20
> >>>> commands:
> >>>>
> >>>> mdadm --grow /dev/md0 --size=3Dmax
> >>>> mdadm --grow /dev/md1 --size=3Dmax
> >>>> mdadm --grow /dev/md2 --size=3Dmax
> >>>>
> >>> Yep, that's right. Make sure they've actually grown to the correct si=
ze
> >>> before you progress though - I have had one occasion where using
> >>> --size=3Dmax actually ended up shrinking the array and I had to manua=
lly
> >>> work out the size to use in order to recover. That was using an older
> >>> version of mdadm though, and I've not seen it happen since.
> >>>
> >>>> and after that
> >>>>
> >>>> fsck /dev/md0
> >>>> fsck /dev/md1
> >>>> fsck /dev/md2
> >>>>
> >>> You'll need 'fsck -f' here to force it to run.
> >> humm.. as /dev/md0 is mounted on / I probably should boot from a cd, a=
nd=20
> >> run fsck and resize2fs from there.. maybe using UUIDs, right?
> >>
> > You can just skip the fsck and run resize2fs - it'll work fine on a
> > mounted filesystem. It'll probably be safer to do it offline though.
> >=20
> > Cheers,
> >     Robin
>=20
> I'd rather stay on the safe side.. how do I assemble the array if I boot=
=20
> from a cd?
>=20
> something like:
>=20
> mdadm --scan --assemble --uuid=3Da26bf396:31389f83:0df1722d:f404fe4c
>=20
> would to the job and let me with a /dev/mdX I will be able to work with=
=20
> (fsck and resize2fs)?
>=20
That should do it, yes. If not, you can always do it explicitly with:
    mdadm -A /dev/md0 /dev/sd[abcd]1

You'd need to double-check what the device names end up as though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGKhPQACgkQShxCyD40xBIz1wCfWOrRDmU1zaHfu6BhD4CnH8r+
cZwAoKGOmmJTM94YxMpCP49+botysFgm
=3SSg
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
