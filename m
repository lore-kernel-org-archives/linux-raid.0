From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Fri, 18 Sep 2009 09:28:51 +0100
Message-ID: <20090918082851.GD22909@cthulhu.home.robinhill.me.uk>
References: <h8nbt5$n8p$1@ger.gmane.org>
 <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
 <h8nfoe$n8p$3@ger.gmane.org>
 <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
 <h8nreb$n8p$4@ger.gmane.org>
 <87ws3z5iro.fsf@frosties.localdomain>
 <1253106813.17888.9.camel@localhost>
 <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9UV9rz0O2dU/yYYn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9UV9rz0O2dU/yYYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 18, 2009 at 11:17:27AM +0300, Majed B. wrote:

> I've re-read this thread and I was wondering if: echo check >
> /sys/block/$array/md/sync_action would help me (and possibly Matthias)
> in any way.
>=20
> I have a RAID5 array of 8 disks running degraded on 7. One of the 7
> has bad sectors and the one that is not in the array also had bad
> sectors.
>=20
> I zeroed the one out of the array (with dd) and then cloned the one
> with bad sectors in the array to it using dd_rescue.
>=20
> Later, I reassembled the array using the cloned disk instead of the origi=
nal.
>=20
> So now, I'm sure I still have inconsistencies, but would doing the
> action above force a correction? Also, would that work on a degraded
> array?
>=20
All the 'check' action does is validate that the checksum matches the
data.  By doing this, it will also be doing a full read check on the
array (though I'm not certain what action is taken on read failures).
The 'repair' action will also rewrite any checksums which don't match
the data.

All of this requires a non-degraded array, so I suspect the 'check' and
'repair' actions will get ignored altogether on a degraded array (and
certainly won't actually work).  As the array is degraded, you _can't_
have any RAID inconsistencies.  You may have some filesystem
inconsistencies (a fsck is definitely recommended) and/or data
inconsistencies (unless you have checksums or backups to compare against
then you're stuck on finding these though).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9UV9rz0O2dU/yYYn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqzRMIACgkQShxCyD40xBKobQCdE6yt5dGyjmPgMPwi3MhSMHm4
PX8An3ve+ys1LqqANhoF0nlYKQFdIK+Y
=xSAg
-----END PGP SIGNATURE-----

--9UV9rz0O2dU/yYYn--
