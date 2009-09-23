From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 08:57:10 +0100
Message-ID: <20090923075710.GA9409@cthulhu.home.robinhill.me.uk>
References: <20090922200912.GA28999@cthulhu.home.robinhill.me.uk>
 <151287.16979.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <151287.16979.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Sep 22, 2009 at 02:56:08PM -0700, adfas asd wrote:

> Thanks Robin.
>=20
> --- On Tue, 9/22/09, Robin Hill <robin@robinhill.me.uk> wrote:
> > The BIOS boots from a single drive, and won't boot from RAID10, so
> > presumably you already have a non-RAID (or RAID-1) boot partition.
>=20
> I have my only two drives set up as RAID10offset2 (WD 2TB each), and
> it boots just fine for some reason.
>=20
Yes, with a 2-drive RAID10o2 layout, one of the drives contains all
blocks in normal order, the other doesn't (see
http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10)
so if the one drive fails then your system will be non-bootable.  A
RAID10n2 or RAID1 (the layout's the same) would be a better choice.

> > > > What if I use the mobo's e-SATA port to add 5 external
> > > > drives locally. This would require a port multiplier. I
> > > > presume it would not be bootable, since a port multiplier
> > > > needs OS support? Or would something go in initrd.img?=20
> > > > Or would I need an individual boot drive to get things up?
> > > > =20
> > Depends on exactly how the BIOS sees is - some seem to see a single
> > drive off the multiplier, so can boot off that one, whereas others
> > won't see anything.  The initrd question is immaterial, as
> > this is only read after the BIOS has called the boot loader, but
> > certainly you could load any necessary drivers at that point.
>=20
> It's an Asus P5N7A-VM mobo, and of course Asus doesn't know the answer
> to this question.  I have in mind the Addonics port "software"
> multiplier, which is a pure hardware multiplexer.  (AD5SARPM-E with
> eSATA & Sii3726 chip)
>=20
> I guess the answer is to just buy and try it.  Reluctant to though,
> owing to the expense.  I am surprised no one else has tried this.
>=20
I certainly haven't anyway.  Is there any reason you can't leave a
couple of drives internal though?  You could definitely boot from those
then.
> =20
> > I'm not sure offset is really noticeably faster than far for
> > writes. Commercial flagging shouldn't be writing to the recordings
> > drive though - it's just inserting database metadata.  If your
> > MythTV database is on the same array/drives then you'll certainly
> > get a big gain from moving it to a separate disk.
>=20
> Commercial flagging is writing like hell to the array, according to
> iotop.  I don't know how else to assess what's going on.  The drives
> are constantly hammering, and my Myth menu moves get very slow during
> flagging, even with the latest 2TB disk drives and RAID10.
>=20
Are you transcoding as well?  The flagging itself shouldn't write, but
if you're transcoding as well (to cut the commercials) then it will have
to write.  And slow menu moves would suggest database/CPU holdups -
there should be no need to read from the recordings disk (actually, it
may have to check the file exists, but that's it).  You didn't say
whether your database is on the array or not (if you're booting from the
array then I'd guess so though).

If your aim is to improve performance then I'd recommend using a single
(relatively small) drive for the main OS and database, and then one (or
more) drives for the recordings.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq51NUACgkQShxCyD40xBLZ1wCgrMTd+Z5KWbzHFuHuorTL+uZD
tZUAoKNt/rAn0Ou5OqninU2x8m3iIzHk
=S/G9
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
