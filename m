From: "TJ" <systemloc@earthlink.net>
Subject: Re: RAID5 reconfig
Date: Sun, 19 Jan 2003 22:16:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000701c2c032$4785e410$6500a8c0@system>
References: <000f01c2ae90$3e9c4eb0$6500a8c0@system> <20030120001941.GB23750@unthought.net>
Reply-To: "TJ" <tjharrel@eagle.fgcu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, raidreconfig worked wonderfully for me, however I screwed up
afterwards. I fscked before resize2fs, but forgot to do it again afterwards
and mounted the filesystem and used it. That caused it enough damage that I
damaged it and rebuilt it from backups. Raidreconfig worked excellently. It
handled unequal partition sizes just fine, though running it with the --test
flag returned an error that one partition was too small (0kb).

One feature request:

Go from 4 40gb disks in RAID 5 to 3 80gb devices in RAID 5: 1 80 gb disk and
the 4 40gb drives in RAID 0.


Old raidtab:

raiddev                        /dev/md0
raid-level                     0
nr-raid-disks                2
chunk-size                    64k
persistent-superblock   1
nr-spare-disks              0
    device                      /dev/hda4
    raid-disk                  0
    device                      /dev/hdc1
    raid-disk                 1

New raidtab:

raiddev                        /dev/md0
raid-level                      5
nr-raid-disks                4
chunk-size                   128k
persistent-superblock       1
parity-algorithm            left-symmetric
nr-spare-disks              0
    device          /dev/hda4
    raid-disk     0
    device          /dev/hdb1
    raid-disk     1
    device          /dev/hdc1
    raid-disk     2
    device          /dev/hdd1
    raid-disk     3

