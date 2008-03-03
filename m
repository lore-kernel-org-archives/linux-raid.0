From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 9] md: Introduction EXPLAIN PATCH SET HERE
Date: Mon, 3 Mar 2008 11:16:58 +1100
Message-ID: <20080303111240.23302.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Keld Simonsen <keld@dkuug.dk>, "K.Tanaka" <k-tanaka@ce.jp.nec.com>
List-Id: linux-raid.ids

Following are 9 patches for md in 2.6.25-rc2-mm1.  All are fairly
simply bugfixes and are suitable for 2.6.25 (though I confess I
should have sent some of them eariler :-( ).

They include fixes for three bugs found but the scsi fault injection framework
(thanks!), and small raid10 read optimisation, and various other bits
and pieces.

NeilBrown


 [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
 [PATCH 002 of 9] md: Reduce CPU wastage on idle md array with a write-intent bitmap.
 [PATCH 003 of 9] md: Guard against possible bad array geometry in v1 metadata.
 [PATCH 004 of 9] md: Clean up irregularity with raid autodetect.
 [PATCH 005 of 9] md: Make sure a reshape is started when device switches to read-write.
 [PATCH 006 of 9] md: Lock access to rdev attributes properly
 [PATCH 007 of 9] md: Don't attempt read-balancing for raid10 'far' layouts.
 [PATCH 008 of 9] md: Fix possible raid1/raid10 deadlock on read error during resync.
 [PATCH 009 of 9] md: The md RAID10 resync thread could cause a md RAID10 array deadlock
