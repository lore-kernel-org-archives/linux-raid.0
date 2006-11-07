From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 9] md: udev notification, raid5 read improvements etc
Date: Wed, 8 Nov 2006 09:09:21 +1100
Message-ID: <20061108085917.12064.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Following are 9 patches for md in 2.6.19-rc4-mm2.
The first two are suitable for 2.6.19.
The third might be.  It seems straight forward, but is awkward to test.
Possibly safest to keep it for .20...
The rest should be held for .20.

4 is a minor tidyup
5 is a resend with a bug fixed.
6-9 are resends with attribution improved.

Thanks,
NeilBrown


 [PATCH 001 of 9] md: Change ONLINE/OFFLINE events to a single CHANGE event
 [PATCH 002 of 9] md: Fix sizing problem with raid5-reshape and CONFIG_LBD=n
 [PATCH 003 of 9] md: Do not freeze md threads for suspend.
 [PATCH 004 of 9] md: Tidy up device-change notification when an md array is stopped
 [PATCH 005 of 9] md: Change lifetime rules for 'md' devices.
 [PATCH 006 of 9] md: Define raid5_mergeable_bvec
 [PATCH 007 of 9] md: Handle bypassing the read cache (assuming nothing fails).
 [PATCH 008 of 9] md: Allow reads that have bypassed the cache to be retried on failure.
 [PATCH 009 of 9] md: Enable bypassing cache for reads.
