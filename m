From: "Martin Clauss" <clauss@neuro.informatik.uni-ulm.de>
Subject: Problems with SCSI devices renaming...
Date: Tue, 19 Oct 2004 16:47:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001201c4b5ea$958f0790$30493c86@clever>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

i got a problem with my raid. Current setup:

        raiddev /dev/md/0
                raid-level              5
                nr-raid-disks           10
                nr-spare-disks          0
                persistent-superblock   1
                parity-algorithm        left-symmetric

                device /dev/scsi/host2/bus0/target0/lun0/part1
                raid-disk               0
                device /dev/scsi/host2/bus0/target1/lun0/part1
                raid-disk               1
                device /dev/scsi/host2/bus0/target2/lun0/part1
                raid-disk               2
                device /dev/scsi/host2/bus0/target3/lun0/part1
                raid-disk               3
                device /dev/scsi/host2/bus0/target4/lun0/part1
                raid-disk               4
                device /dev/scsi/host2/bus0/target8/lun0/part1
                raid-disk               5
                device /dev/scsi/host2/bus0/target9/lun0/part1
                raid-disk               6
                device /dev/scsi/host2/bus0/target10/lun0/part1
                raid-disk               7
                device /dev/scsi/host2/bus0/target11/lun0/part1
                raid-disk               8
                device /dev/scsi/host2/bus0/target12/lun0/part1
                raid-disk               9

This works very fine so far. But when I attach an additional device to this
DEC Storage Device, I get an additional target on this SCSI bus. Now this
doesn't matter for the devfs names, but the superblock of the RAID saves
major/minor numbers that are wrong now. So the raid won't start anymore....
Shouldn't autodetect handle exactly this problem? (Yes, partition type is
linux raid autodetect for all raid disks...)

I guess, this should be a quite common problem, so I hope to find some
answers here.

Greetz,
Martin Clauss

