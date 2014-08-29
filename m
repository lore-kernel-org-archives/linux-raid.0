From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Seeking help to get a failed RAID5 system back to life
Date: Fri, 29 Aug 2014 10:10:19 +0100
Message-ID: <20140829091018.GB8321@cthulhu.home.robinhill.me.uk>
References: <CAGgRf0Qe1EU6wZm4BbWqs0diwwnBCeStiVAXaOdHV88Ttn=vfw@mail.gmail.com>
 <20140829074627.GA8321@cthulhu.home.robinhill.me.uk>
 <CAGgRf0TZG28nGAHsvZzLkPhYv422GC=r5-km=6OL5-5EXJZQjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGgRf0TZG28nGAHsvZzLkPhYv422GC=r5-km=6OL5-5EXJZQjQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Fabio Bacigalupo <info1@open-haus.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Aug 29, 2014 at 10:55:53AM +0200, Fabio Bacigalupo wrote:

> Hello Robin,
>=20
> thank you for your feedback!
>=20
> 2014-08-29 9:46 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
> > That's a disaster waiting to happen. You should never leave a RAID array
> > in a degraded state for any longer than is absolutely necessary,
> > otherwise you might as well not bother running RAID at all.
>=20
> >> I could gather the following information:
>=20
> > Are the above --examine results from before or after the replacement?
>=20
> I took them before the replacement.
>=20
I suspected as such.

> > Was the old /dev/sdc data replicated onto the replacement disk?
>=20
> No, that is, not, yet. Luckily the guys in the data center kept the disk.
>=20
If you'd had the third disk in the array in the first place then you
could have just added the new disk to the array and left it to rebuild
the data, but with it already in a degraded state then you absolutely
need that data off the second disk.

> > If the initial --examine results were done on the same disks as the
> > --assemble then I'm rather confused as to why mdadm would find a
> > superblock for one and not for the other. Could you post the mdadm and
> > kernel versions - possibly there's a bug that's been fixed in newer
> > releases.
>=20
> There will be no bug. I just was under a false assumption.
>=20
> > If the --examine was on the old disk and this wasn't replicated onto the
> > new one then I'm not sure what you're expecting to happen here - you've
> > lost 2 disks in a 3-disk RAID-5 so your data is now toast.
>=20
> Ok, now that is clear. I will use ddrescue to replicate the old disk
> to the new one and try again.
>=20
You'll need to use --assemble --force in order to get the array going
again afterwards (as the event counts are different on the two disks).
If there are any blocks that couldn't be read by ddrescue then you'll
also need to run a fsck on the array after assembly to deal with any
resulting corruption - this may affect file data, directory metadata or
may just be in unused parts of the disk (if you're really lucky).

I'd definitely recommend adding the third disk back into the array
afterwards though, and making sure regular checks are run on the array
(echo check > /sys/block/mdX/md/sync_action) to pick up any disk errors
or sync issues before they cause major problems.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQAQ3oACgkQShxCyD40xBI+FwCfaDZYTAARxbZUeFnRMWHTFWc9
y2oAoJh+HZAZcXs/j2VbIw9jEYpjqKf0
=5uCi
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
