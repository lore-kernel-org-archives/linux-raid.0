From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/2] md: More block -> sector conversions.
Date: Mon, 26 Jan 2009 16:14:10 +0100
Message-ID: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

These two patches against Neil's for-next tree make the internal
representaions of mddev->size and rdev->size sector-based.
checkpatch.pl is happy with both patches, and the patched kernel
passes all tests of the mdadm test suite on my i386 UP box.

Please review.

BTW: This completes the block -> sector conversion of the md code base
because all remaining block-based quantities are either user-visible
(via sysfs) or describe on-disk formats (version 0.90 superblocks)
and hence can not be changed without breaking user space.

Andre

