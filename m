From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm raid5 single drive fail, single drive out of sync terror
Date: Wed, 26 Nov 2014 15:49:22 +0000
Message-ID: <20141126154922.GA12222@cthulhu.home.robinhill.me.uk>
References: <5475ECDC.6070309@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5475ECDC.6070309@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Robison <narfman0@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 26, 2014 at 10:08:12AM -0500, Jon Robison wrote:

> Hi all!
>=20
> I upgraded to mdadm-3.3-7.fc20.x86_64, and my raid5 array would no=20
> longer recognize /dev/sdb1 in my raid 5 array (which is normally=20
> /dev/sd[b-f]1). I `mdadm --detail --scan`,  which resulted in a degraded=
=20
> array, then added /dev/sdb1, and it started rebuilding happily until 25%=
=20
> or so, when another failure seemed to occur.
>=20
> I am convinced the data is fine on /dev/sd[c-f]1, and that somehow I=20
> just need to inform mdadm about that, but they got out of sync and=20
> /dev/sde1 thinks the array is AAAAA while the others think its AAA.. .=20
> The drives also seem to think e is bad because f said e was bad or some=
=20
> weird stuff, and sde1 is behind by ~50 events or so. That error hasn't=20
> shown itself recently. I fear sdb is bad and sde is going to go soon.
>=20
> Results of `mdadm --examine /dev/sd[b-f]1` are here=20
> http://dpaste.com/2Z7CPVY
>=20
> I'm scared and alone. Everything is off and sitting as above, though e=20
> 50 events behind and out of synch. New drives coming Friday and backup=20
> is of course a bit old. I'm petrified to execute `mdadm --create=20
> --assume-clean --level=3D5 --raid-devices=3D5 /dev/md0 /dev/sdf1 /dev/sdd=
1=20
> /dev/sdc1 /dev/sde1 missing`, but that seems my next option unless ya'll=
=20
> know better. I tried `mdadm --assemble -f /dev/md0 /dev/sdf1 /dev/sdd1=20
> /dev/sdc1 /dev/sde1` and it said something like can't start with only 3=
=20
> devices (which I wouldn't expect because examine still shows 4, just=20
> that they are out of sync and I thought that was -f's express purpose in=
=20
> assemble mode). Anyone have any suggestions? Thanks!

It looks like this is a bug in 3.3 (the checkin logs show something
similar anyway). I'd advise getting 3.3.1 or 3.3.2 and retrying the
forced assembly.

If it failed during the rebuild, that would suggest there's an
unreadable block on sde though, which means you'll hit the same issue
again when you try to rebuild sdb. You'll need to:
    - image sde to a new disk (via ddrescue)
    - assemble the array
    - add another new disk in to rebuild
    - once the rebuild has completed, force a fsck on the array
      (fsck -f /dev/md0) as the unreadable block may have caused some
      filesystem corruption. It may also cause some file corruption, but
      that's not something that can be easily checked.

These read errors can be picked up and fixed by running regular array
checks (echo check > /sys/block/md0/md/sync_action). Most distributions
have these set up in cron, so make sure that's in there and enabled.

The failed disks may actually be okay (sde particularly), so I'd advise
checking SMART stats and running full badblocks write tests on them. If
the badblocks tests run okay and there's no increase in reallocated
sectors reported in SMART, they should be perfectly okay for re-use.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlR19oEACgkQShxCyD40xBK9TACZAd1VOqnYvD5OLQd8ZvRIE7gV
CkwAoKV8nzQtABfVK132B7Ijqn6gqABY
=ZEet
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
