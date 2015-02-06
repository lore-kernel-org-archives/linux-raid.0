From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Fri, 6 Feb 2015 13:39:52 +1100
Message-ID: <20150206133952.173f1975@notabene.brown>
References: <20141218161456.GA29504@shrek.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Ii+GQN=QD16p.ymDNO/TJ38"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141218161456.GA29504@shrek.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Ii+GQN=QD16p.ymDNO/TJ38
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Dec 2014 10:14:57 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

> Hello,
>=20
> This is an attempt to make MD-RAID cluster-aware. The advantage of
> redundancy can help highly available systems to improve uptime.
> Currently, the implementation is limited to RAID1 but with further work
> (and some positive feedback), we could extend this to other compatible
> RAID scenarios.
>=20
> The design document (first patch) is pretty descriptive of how
> the md has been made cluster-aware and how DLM is used to safeguard data
> and communication.
>=20
> This work requires some patches to the mdadm tool [1]
>=20
> A quick howto:
>=20
> 1. With your corosync/pacemaker based cluster running execute:
> # mdadm --create md0 --bitmap=3Dclustered --raid-devices=3D2 --level=3Dmi=
rror --assume-clean /dev/sda /dev/sdb
>=20
> 2. On other nodes, issue:
> # mdadm --assemble md0 /dev/sda /dev/sdb
>=20
> References:
> [1] mdadm tool changes: https://github.com/goldwynr/mdadm branch:cluster-=
md
> [2] Patches against stable 3.14: https://github.com/goldwynr/linux branch=
: cluster-md-devel
>=20
> Regards,
>=20


hi Goldwyn,
 thanks for these - and sorry for the long delay.   Lots of leave over
 southern summer, and the lots of email etc to deal with.

This patch set is very close and I am tempted to just apply it and then
fix things up with subsequent patches.  In order to allow that, could you
please:
  - rebase against current upstream
  - fix the checkpatch.pl errors and warnings.
    The "WARNING: line over 80 characters" are often a judgement call
    so I'm not particularly worried about those.  Most, if not all, of
    the others should be followed just to have consistent layout.

Then I'll queue them up for 3.21, providing I don't find anything that would
hurt non-cluster usage ....
 On that topic: why initialise rv to -EINVAL in "metadata_update sends
 message...".  That looks wrong.

I noticed that a number of times a patch will revert something that a
previous patch added.  It would be much nicer to fold these changes back in=
to
the original patch.  Often this is just extra blank lines, but occasionally
variable names are changed (md -> mddev).  It should be given the final name
when introduced.  Every chunk in every patch should be directly relevant to
that patch.

Some other issues, that could possibly be fixed up afterwards:

 - Is a clustername 64 bytes or 63 bytes?  I would have thought 64,
   but the use of strlcpy make is 63 plus a nul.  Is that really what is
   wanted?

 - Based on https://lkml.org/lkml/2012/10/23/580 it might be good to add
   "default n" to Kconfig, and possible add a WARN() if anyone tries to use
   the code.

 - I'm a bit concerned about the behaviour on node failure.
   When a node fails, two things must happen w.r.t the bits in that node's
   bitmap.
   1/ The corresponding regions of the array need to be resynced.  You do h=
ave
      code to do this.
   2/ Other nodes must avoid read-balancing on those regions until the
      resync has completed. =20

   You do have code for this second bit, but it looks wrong.  It avoids
   read-balancing if ->area_resyncing().  That isn't sufficient.
   The "area_resyncing" is always (I assume) a relatively small region of
   the array which will be completely resynced quite quickly.  It must be
   because writes are blocked to this area.  However the region in which
   we must disable re-balancing can be much larger.  It covers *all* bits
   that are set in any unsynced bitmap.  So it isn't just the area that is
   currently being synced, but all areas that will be synced.

 - I think md_reload_sb() might be too simple.  It probably should check th=
at
   nothing serious has changed.  The "mddev->raid_disks =3D 0" look suspici=
ous.
   I'll have to think about this a bit more.

That's all I can see for now.  I'll have another look once I have it all in=
 my tree.

Thanks,
NeilBrown

--Sig_/Ii+GQN=QD16p.ymDNO/TJ38
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNQpeDnsnt1WYoG5AQIEWg/7BpWm851YYEtybqYiaq6Mh2JaA4Je72/5
4p08TRExbVcPBbc/Lw4bpIMimuTetYXTMAO6n5fszRFmiIcq7zrHKLBcmkDj4aZ6
7eEJUDI0x1xti4kHOokSs0hBa9mVkJHL+5WPzBhpMVQc5pVLXC0Nqq0X9MCcc+qm
YBVwkRRr2N7KwCQh0OJ6AKUo1qJ6PK1LMtPZMFSg0cyT85pRdAIp5hvXGK5tKoP4
OGhnQUEOguQW25UmSdnQnm2bgLyW2d034b3sw4WLJY0oLyAaLsQu6DUG9JXBuKJN
uY39/HPOcZVrt2D7P8+DT4zHfskFIQnBT1c5ar3to7G5YOinlySvMAd2syfLDzGz
lN7yOAH2RnQHaNwStYZDkbjhLYeUlg9VRJwL1j0VEzDhu7xLHxqwx1NC2duLGXiw
NIMI5oJfiwaiqmaYoJjWMX3ViubMa4LkKD2GIloxEwEk7D6tkHVWyJV3ciGoNhKk
qlmSvD4r+7R6oEVehyeJK7X01kdkfNdbQ55HsEFUhirVdEJg8c3VuLYSpyCrOEMG
UxN/MxMA7M7YPDCryX2nYYBpXpbDKlZgx2d+vzSgBo2/m5Uj/Yeu6yAykehwQ1Xy
m5CkFsenFsHJVsMYc4/9uc79ItxKDST7nbSiX7Ja4cEL7EkrLcyudxvSSMNRNjbl
gLP1IpEgkjk=
=83Pv
-----END PGP SIGNATURE-----

--Sig_/Ii+GQN=QD16p.ymDNO/TJ38--
