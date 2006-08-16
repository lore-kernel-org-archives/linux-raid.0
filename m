From: raid@bymeinc.com
Subject: RE: Imaging Mirrored OS Drives
Date: Wed, 16 Aug 2006 13:28:57 -0400 (EDT)
Message-ID: <20060816172857.9FF69AE3DC@bymeinc.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The first method that comes to mind is to make a raw copy of each mirrored disk to another disk attached to the same server. dd if=/dev/sda of=/dev/sdb will do a raw dump from one drive to another. Assuming you copy to a drive of equal or greater capacity, your partition structure, RAID superblock (including UUID), and data should remain intact. mdadm should be able to run a disk pair made by raw copies of the disks. I don't see a problem with identical UUID drives living in the same machine, so long as the array isn't started. Obviously copying a mounted block device is a bad idea, so I'd do it from a bootable CD environment, etc.
