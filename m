From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 29] md: Introduction : patchbomb for 2.6.27 merge window
Date: Fri, 27 Jun 2008 16:49:10 +1000
Message-ID: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Chris Webb <chris@arachsys.com>, Dan Williams <dan.j.williams@intel.com>, Dave Jones <davej@redhat.com>, Mike Snitzer <snitzer@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>, Nikanth Karthikesan <knikanth@novell.com>, Nikanth Karthikesan <knikanth@suse.de>, stable@kernel.org
List-Id: linux-raid.ids

Following are 29 patches for md suitable for 2.6.27.

The first three are for bugs that can trigger oops or data corruption.
They are possibly suitable for 2.6.26 and for -stable.

There are some bug fixes, some minor feature enhancement (mostly
related to sysfs control of arrays) and some raid5 cleanups

Thanks,
NeilBrown


 [PATCH 001 of 29] md: Ensure interrupted recovery completed properly (v1 metadata plus bitmap)
 [PATCH 002 of 29] md: Don't acknowlege that stripe-expand is complete until it really is.
 [PATCH 003 of 29] md: Fix error paths if md_probe fails.
 [PATCH 004 of 29] md: linear: correct disk numbering error check
 [PATCH 005 of 29] md: use bio_endio instead of a call to bi_end_io
 [PATCH 006 of 29] md: Improve setting of "events_cleared" for write-intent bitmaps.
 [PATCH 007 of 29] md: Allow setting start point for requested check/repair
 [PATCH 008 of 29] md: Close race in md_probe
 [PATCH 009 of 29] md: Don't try to make md arrays dirty if that is not meaningful.
 [PATCH 010 of 29] md: Enable setting of 'offset' and 'size' of a hot-added spare.
 [PATCH 011 of 29] md: Support adding a spare to a live md array with external metadata.
 [PATCH 012 of 29] md: rationalise return value for ->hot_add_disk method.
 [PATCH 013 of 29] md: Don't reject HOT_REMOVE_DISK request for an array that is not yet started.
 [PATCH 014 of 29] md: Make sure all changes to md/array_state are notified.
 [PATCH 015 of 29] md: Make sure all changes to md/sync_action are notified.
 [PATCH 016 of 29] md: Make sure all changes to md/degraded are notified.
 [PATCH 017 of 29] md: Make sure all changes to md/dev-XX/state are notified
 [PATCH 018 of 29] md: Support changing rdev size on running arrays.
 [PATCH 019 of 29] md: md: kill STRIPE_OP_MOD_DMA in raid5 offload
 [PATCH 020 of 29] md: md: kill STRIPE_OP_IO flag
 [PATCH 021 of 29] md: md: use stripe_head_state in ops_run_io()
 [PATCH 022 of 29] md: md: unify raid5/6 i/o submission
 [PATCH 023 of 29] md: md: replace STRIPE_OP_CHECK with 'check_states'
 [PATCH 024 of 29] md: md: replace STRIPE_OP_BIOFILL with STRIPE_BIOFILL_RUN
 [PATCH 025 of 29] md: md: replace STRIPE_OP_COMPUTE_BLK with STRIPE_COMPUTE_RUN
 [PATCH 026 of 29] md: md: replace STRIPE_OP_{BIODRAIN,PREXOR,POSTXOR} with 'reconstruct_states'
 [PATCH 027 of 29] md: md: replace R5_WantPrexor with R5_WantDrain, add 'prexor' reconstruct_states
 [PATCH 028 of 29] md: md: handle operation chaining in raid5_run_ops
 [PATCH 029 of 29] md: md: rationalize raid5 function names
