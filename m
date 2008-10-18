From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/8] md: Make raid0 use sector-based quantities
Date: Sat, 18 Oct 2008 17:24:21 +0200
Message-ID: <1224343469-2831-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This series of patches against Neil's for-next branch converts the
internal representations of block-based quantities in the raid0 code
to sector-based quantities.

There's also one trivial patch in this series, #6, which adds
KERN_INFO/KERN_ERR to a couple of printk's.

checkpatch.pl is happy with all eight patches, and the patched kernel
passes the raid0 tests of mdadm's test suite on my i386 UP box.

Please review.
Andre
