From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/9] md: Make raid0 use sector-based quantities
Date: Mon, 20 Oct 2008 10:56:38 +0200
Message-ID: <1224493007-1255-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[try #2, this time with the missing patch included]

This series of patches against Neil's for-next branch converts the
internal representations of block-based quantities in the raid0 code
to sector-based quantities.

There's also one trivial patch in this series, #7, which adds
KERN_INFO/KERN_ERR to a couple of printk's.

checkpatch.pl is happy with all nine patches, and the patched kernel
passes the raid0 tests of mdadm's test suite on my i386 UP box.

Please review.
Andre
