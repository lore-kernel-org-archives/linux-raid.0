From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 12] md: Introduction
Date: Tue, 27 Jun 2006 17:05:01 +1000
Message-ID: <20060627170010.25835.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following are 12 assorted small patches for md.
They are against 2.6.17-mm2 and are suitable for inclusion in 2.6.18.

They are primarily small bug fixes, many fixing possible races, some
of which have been seen in the wild, some not.

Thanks,
NeilBrown


 [PATCH 001 of 12] md: Possible fix for unplug problem
 [PATCH 002 of 12] md: Set desc_nr correctly for version-1 superblocks.
 [PATCH 003 of 12] md: Delay starting md threads until array is completely setup.
 [PATCH 004 of 12] md: Fix resync speed calculation for restarted resyncs.
 [PATCH 005 of 12] md: Fix a plug/unplug race in raid5
 [PATCH 006 of 12] md: Fix some small races in bitmap plugging in raid5.
 [PATCH 007 of 12] md: Fix usage of wrong variable in raid1
 [PATCH 008 of 12] md: Unify usage of symbolic names for perms.
 [PATCH 009 of 12] md: Require CAP_SYS_ADMIN for (re-)configuring md devices via sysfs.
 [PATCH 010 of 12] md: Remove a variable that is now unused.
 [PATCH 011 of 12] md: Fix "Will Configure" message when interpreting md= kernel parameter.
 [PATCH 012 of 12] md: Include sector number in messages about corrected read errors.
