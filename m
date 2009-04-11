From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Sat, 11 Apr 2009 15:36:42 +0100
Message-ID: <20090411143642.GA9915@cthulhu.home.robinhill.me.uk>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <019701c9ba66$aeed5630$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 10, 2009 at 10:29:59PM -0700, Timothy D. Lenz wrote:

> From: "CoolCold" <coolthecold@gmail.com>
>=20
> > Yes, he should provide correct /etc/mdadm/mdadm.conf and
> > update-initramfs -u on md boot, smth like
> > chroot /mnt/md0
> > update-initramfs -u
>=20
> How would this help in a system that doesn't ramdisk built in to the
> kernel or as a module? Or does it change some other stuff?
>=20
This is useless if you don't use an initrd.

> I started looking at the stuff that was copied to md0 and /md0/dev is
> empty. Looking through the guides I found a few things. One said that
> using cp had to be from root or not everything would get coppied. I
> used sudo but I know some things require you to root.
>
This shouldn't matter in this case.  The reason you're getting nothing
copied in /dev is that it's a mounted filesystem, and your copy command
specifically excludes mounted filesystems.

> Also this:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> # rsync -avHhx --progress / /mnt/raid-md0
>=20
>     * If the system wasn't previously in single user mode, move to
>     single user mode and update the data that changed during the first
>     copy:
> (--delete flag tells rsync to delete files from the destination which
> do not exist on the source):
>=20
> # rsync -avHhx --progress --delete / /mnt/raid-md0
>=20
Yes, this is an alternative to running from a bootable CD.  In
single-user mode (init 1), there can be no background applications
running, so there should be no open files to worry about.  I'd still
rather use a bootable CD though.

>     * Create needed device nodes:
>=20
> # cd /mnt/raid-md0/dev/ && MAKEDEV generic
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> Using rsync from single user mode still left /mnt/md0/dev empty. I
> read up in "makedev generic" and it seems to be a shotgun fix adding
> way more then is needed. Is there a way to create just what is in
> /dev?
>=20
Again, the rsync command includes the 'x' option so excludes mounted
filesystems (which is what you want here).  You can copy the necessary
/dev entries manually - I think the only entries you need are
/dev/console & /dev/null, so:
    cp -a /dev/console /dev/null /mnt/raid-md0/dev

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkngqvkACgkQShxCyD40xBKFlgCgsfZ5gJh076LRZyf7sY1bAVWJ
hPYAoIbbAVvb1lxIvS8LJJbmAEJP5YkQ
=8t2F
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
