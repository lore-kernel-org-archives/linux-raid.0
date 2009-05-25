From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 0/6] md: More sector_t conversions -- intro
Date: Mon, 25 May 2009 11:27:31 +0200
Message-ID: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Hi

this patch set against the for-next tree as of last Friday converts a
couple of remaining internal representation of md sizes to sector_t,
fixes a bug in the reshape code and adds a couple of trivial cleanups.

Patch #1 converts mddev->chunk_size which was previously stored
in bytes.  Patch #2 fixes what I believe is a bug in super_1_sync()
and might be a candiate for -stable. Patches #3 and #4 are further
straight-forward conversions that deal with mddev->new_chunk,
conf->chunk_size and conf->prev_chunk. Patches #5 and #6 are pure
cleanups.

All patches pass the tests of the mdadm test suite except
07reshape5intr which appears fail also for the vanilla for-next tree.

Please review and consider for inclusion into for-next.

Thanks
Andre
