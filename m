From: "Shaw, Marco" <marco.shaw@nbtel.nb.ca>
Subject: RAID0 versus Linear
Date: Mon, 23 Sep 2002 21:39:24 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA780BAD5BA7@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

RedHat Advanced Server 2.1AS
Raidtools-1.00.2-1.2

Couldn't seem to find anything relevant in the linux-raid archive...

Had an internal discussion regarding the choice of linear versus raid0.  We'd like to standardize on a usage within our company.

(If this makes a difference: We have a SAN which will present a host with a disk using SCSI over fibre.  (That's the extent of my SAN-technical jargon/knowledge.).  The virtual disk presented to the host is a 0+1 RAID volume on the other end which is supposed to be transparent to the user/host system.)

Disks will not necessarily always be of the same size, but we do want to concatenate them, so I guess linear would be the way to go.  Problem is I built a RAID0 array during testing, and was now trying to convert it to linear, by simply:
*editing the /etc/raidtab file appropriately: raid-level 0-->raid-level linear
*umount /raid_dir
*raidstop /dev/md0
*mkraid -R /dev/md0

I would assume that this is the appropriate procedure, but I get a nasty kernel crash, of which I don't have anything able to capture it.

(Tried different combinations of enable/disabling the persistent-superblock.  I've not been able to reproduce it regularly, but was getting errors that "persistent-superblock was not supported by linear or RAID0" at various times during the boot process, but once I redid the md device with a mkraid, and built a new fs, it seemed to be OK.  The logs complained about an invalid superblock on the device 0 everytime.)

I'd also like to confirm that RAID0 can only be used for disks of aproximately the same size.  If they aren't, does the extra space become unusable?

Marco
