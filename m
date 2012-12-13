From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: failed raid re-create changed dev size
Date: Thu, 13 Dec 2012 09:30:40 +0000
Message-ID: <20121213093040.GA17294@cthulhu.home.robinhill.me.uk>
References: <1355236515.50c744a3720c1@mail.inbox.lv>
 <20121211144949.GB28593@cthulhu.home.robinhill.me.uk>
 <1355328659.50c8ac93db8a3@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355328659.50c8ac93db8a3@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 12, 2012 at 06:10:59PM +0200, Andris Berzins wrote:

> >> Is it possible that no data was damaged? It is LUKS partition, i
> >> mapped it and run "fsck -n" on underlying ext3 partition,
> >> but fsck returned immediately with status "clean".
> >>=20
> > By default fsck will just check whether the filesystem is marked as
> > dirty/clean and just skip running if it's clean. You'll need to use "-f"
> > to force it to run.
>=20
> It seems that something got damaged. I have several traces as shown
> below in dmesg.
>=20
> Tried to run "fsck -f -n" but it looks that it will take several month
> on this 15TB fs with billion files.
> Any ideas?
>=20
Sorry, no. You've got a corrupted filesystem and fsck is the tool to fix
that. If you're certain that the array is now set up correctly (which it
probably is if LUKS is able to map it okay), then you can skip the "-n"
pass and proceed straight to repair. Depending on memory, you may also
want to look into setting up scratch_files in e2fsck.conf as it can suck
up a lot of memory for large filesystems. You may also want to look into
moving to ext4 once you've got the filesystem fixed - fsck times should
be much lower than with ext3.

The only other option would be to reformat and restore from backup.

Good luck,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDJoEAACgkQShxCyD40xBLqYQCdG98X9nhAEo84KvBVAw5RBS0b
pUoAn1vov3Sy8EdyfTQCFpHS0n7Ez9rn
=yy8F
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
