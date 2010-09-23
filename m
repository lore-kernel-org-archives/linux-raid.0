From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: How to remove non-existant device
Date: Thu, 23 Sep 2010 09:30:29 +0200
Message-ID: <20100923073029.GD19538@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all.

On a SLES 10 SP 3 x86_64 version I'm encountering the following problem:

Two disks sda and sdb are in a RAID 1 configuration. When pulling one
disk and replacing it it becomes sdc instead of sda. The RAID is now
degraded:

kblhbe101:~ # cat /proc/mdstat
Personalities : [raid1] [raid0] [raid5] [raid4] [linear]
md2 : active raid1 sda8[2](F) sdb8[1]
      286125568 blocks [2/1] [_U]

md0 : active raid1 sda5[2](F) sdb5[1]
      529984 blocks [2/1] [_U]

md3 : active raid1 sda7[2](F) sdb7[1]
      4200896 blocks [2/1] [_U]

md1 : active raid1 sda6[2](F) sdb6[1]
      2104384 blocks [2/1] [_U]

unused devices: <none>

But now I can't remove the sda partitions from the RAID:
kblhbe101:~ # mdadm /dev/md0 -r /dev/sda5
mdadm: cannot find /dev/sda5: No such file or directory
kblhbe101:~ # mdadm /dev/md0 -r sda5
mdadm: cannot find sda5: No such file or directory

What am I doing wrong here?
kblhbe101:~ # mdadm --version
mdadm - v2.6 - 21 December 2006


Trying mdadm -Iq /dev/md0 results in a segfault...


Kind regards,
     Benjamin

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFMmwIUvGeX+A6y9KwRAkGWAJ9+rfE5LvVP6on5WEfEMB/CAzNNOACgl/6b
WCOKr/tCmsjMoE6aABzH8VU=
=QU+K
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
