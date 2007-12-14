From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 7] md: Introduction EXPLAIN PATCH SET HERE
Date: Fri, 14 Dec 2007 17:26:02 +1100
Message-ID: <20071214171950.1308.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-raid.ids

Following are 7 md related patches are suitable for the next -mm
and maybe for 2.6.25.

They move towards giving user-space programs more fine control of an
array so that we can add support for more complex metadata formats
(e.g. DDF) without bothering the kernel with such things.

The last patch isn't strictly md related.  It adds an ioctl which
allows mapping from an open file descriptor on a block device to
a name in /sys.  This makes finding name of things in /sys more practical.
As I put this in block-layer code, I have Cc:ed Jens Axboe.

 [PATCH 001 of 7] md: Support 'external' metadata for md arrays.
 [PATCH 002 of 7] md: Give userspace control over removing failed devices when external metdata in use
 [PATCH 003 of 7] md: Allow a maximum extent to be set for resyncing.
 [PATCH 004 of 7] md: Allow devices to be shared between md arrays.
 [PATCH 005 of 7] md: Lock address when changing attributes of component devices.
 [PATCH 006 of 7] md: Allow an md array to appear with 0 drives if it has external metadata.
 [PATCH 007 of 7] md: Get name for block device in sysfs
