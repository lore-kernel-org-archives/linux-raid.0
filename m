From: David Greaves <david@dgreaves.com>
Subject: Re: Low perfomance of RAID0,RAID5, RAID+LVM on 2.6
Date: Thu, 19 Aug 2004 16:53:25 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4124CCF5.8010201@dgreaves.com>
References: <20040819193200.27c97a4e@vovapc.kpml.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040819193200.27c97a4e@vovapc.kpml.int>
To: "Vladimir I. Umnov" <uvi@ezmail.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Vladimir I. Umnov wrote:

|HW: chipset 875WPE, P4 2.4HT, 3 SATA WD 160JD, 1 ATA Samsung 80Gb.
|SW: kernel 2.6.6, libata drivers for PROMISE S150 TX4.
|CONFIG: 256K readahead on all drives.
|    sda1,sdb1,sdc1->RAID0 (md0)
|    sda2,sdb2,sdc2,hda1->RAID5 (md1)
|    about 20 partitions on LVM2 with xfs,ext3,reiserfs
|    chunksize on md0, md1 = 256k - this was optimal with 2.6.0test3 about
|    year ago.
|
|Theoretically RAID0 read speed should be nearly read speed of one
|drive multiply to number of drives, but I have:
|dd if=/dev/sda1 of=/dev/null gives about 44 Mb/s on all drives (but  on
|sii3112 ide driver with  WD 160JD about 55Mb/s and on libata the same
|44)

I use my arrays for large video files so large readahead is good.

I use blockdev on the lvms:
/sbin/blockdev --setra 4096 /dev/video_vg/video_lv
/sbin/blockdev --setra 4096 /dev/video_vg/huge_lv

the md device:
/sbin/blockdev --setra 4096 /dev/md0

and the raw devices
/sbin/blockdev --setra 4096 /dev/sda
/sbin/blockdev --setra 4096 /dev/sdb
/sbin/blockdev --setra 4096 /dev/sdc
/sbin/blockdev --setra 4096 /dev/sdd
/sbin/blockdev --setra 4096 /dev/hdb

HTH

David
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBJMz08LvjTle4P1gRAkfpAJ9XA17vexSqmcN0LVFZOx0Dxik/BQCgjMk+
oAslumzTWosxF9WqnDXln3k=
=C3uO
-----END PGP SIGNATURE-----

