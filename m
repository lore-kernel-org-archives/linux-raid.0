From: Matt <matt@lpbproductions.com>
Subject: Raid chunksize...
Date: Wed, 28 May 2003 03:34:49 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305280334.52979.matt@lpbproductions.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Description: clearsigned data
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello, 
	I currently have a software raid0 setup with this configuration
raiddev                 /dev/md0
raid-level              0
nr-raid-disks           2
nr-spare-disks          0
persistent-superblock   1
chunk-size              4

device                  /dev/hda2
raid-disk               0

device                  /dev/hdc2
raid-disk               1

Both drives are 80 gig .. so the total comes out to 160 gig w/ raid0 .. Now is 
a chunksize of 4k to small (??), or is it optimal (??). Also I'am curios is 
there anyway to change the chunksize w/o lossing the raid array and the 
contents inside that array ? 

Thanks, 
Matt

- - Also Iam not on the list , so any replies please CC to me .. Thanks
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1JDLleY/n9G/oZ8RAsXCAJ47PYJi6oMWyNHx4ZRRd42XivRacgCfToF/
KV4H0rAQ3kJpSbiofVFxh0E=
=UGvD
-----END PGP SIGNATURE-----
