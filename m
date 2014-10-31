From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Trying to get POLICY working
Date: Fri, 31 Oct 2014 15:34:55 +0000
Message-ID: <20141031153455.GA8615@cthulhu.home.robinhill.me.uk>
References: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Oct 31, 2014 at 04:19:04PM +0100, Caspar Smit wrote:

> Hi all,
>=20
> I'm trying to get the POLICY framework of mdadm working but I can't seem =
to.
>=20
> As i understand in the man page of mdadm the Incremental and POLICY
> directives could allow adding a new disk without MD superblock as
> spare to an already active array:
>=20
> "Note that mdadm will normally only add devices to an array which were
> previously working (active or spare) parts of that array.  The support
> for automatic inclusion of a new drive as a spare in some array
> requires a configuration through POLICY in config file."
>=20
> Furthermore:
>=20
> "If no md metadata is found, the device may be still added to an array
> as a spare if POLICY allows."
>=20
>=20
> To get the basics working I created a system with 3 disks /dev/sdb,
> /dev/sdc and /dev/sdd
>=20
> Created a RAID5 with one missing disk:
>=20
> mdadm -C /dev/md0 -l 5 -n 3 /dev/sd[b-c] missing
>=20
> I set the POLICY in mdadm.conf to:
>=20
> POLICY action=3Dforce-spare
>=20
> This should add any device (passed through mdadm --incremental) as
> spare no matter what (Am i correct?)
>=20
> Now when I do:
>=20
> #mdadm --incremental /dev/sdd
> mdadm: no RAID superblock on /dev/sdd.
>=20
> Well, i know there is no MD superblock on /dev/sdd but shouldn't the
> policy setting kick in here and add /dev/sdd as spare (and hence start
> rebuilding) to /dev/md0?
>=20
> mdadm version: 3.2.5-5 (latest debian wheezy stable)
> kernel version: 3.2.63-2 (latest debian wheezy stable)
>=20
According to the mdadm.conf manual page on my machine:
      The  action  item  determines the automatic behavior allowed for
      devices matching the path and type  in  the  same  line.  If  a
      device  matches  several  lines  with different actions then the
      most permissive will apply. The  ordering  of  policy lines  is
      irrelevant to the end result.

With the examples given being:
      POLICY domain=3Ddomain1 metadata=3Dimsm path=3Dpci-0000:00:1f.2-scsi-=
* action=3Dspare
      POLICY domain=3Ddomain1 metadata=3Dimsm path=3Dpci-0000:04:00.0-scsi-=
[01]* action=3Dinclude

So I'd guess that the path=3D entry is required (though the type value
would look to be optional, which is not clear from the text).

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlRTrB8ACgkQShxCyD40xBJG/wCfVBukjz4rL+iXAnRQK4M/Cplt
dl8AnRN7+LttZ7JEhLv1xFa4xxxuENHv
=0Rt9
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
