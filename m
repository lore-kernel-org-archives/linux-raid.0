From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 8] Introduction
Date: Fri, 14 Oct 2005 12:25:50 +1000
Message-ID: <20051014122335.11602.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

8 patches for md/raid in 2.6 follow.

The first replaces 
   md-identify-raid-rcu-protected-pointer.patch
which has some minor issues.
2 and 3 fix problems in previous patches identified by some kindly code reviewers.

Thanks,
NeilBrown


 [PATCH md 001 of 8] Provide proper rcu_dereference / rcu_assign_pointer annotations in md
 [PATCH md 002 of 8] Fix ref-counting problems with kobjects in md
 [PATCH md 003 of 8] Minor MD fixes
 [PATCH md 004 of 8] Change raid5 sysfs attribute to not create a new directory.
 [PATCH md 005 of 8] Improvements to raid5 handling of read errors
 [PATCH md 006 of 8] Convert 'faulty' and 'in_sync' fields to bits in 'flags' field.
 [PATCH md 007 of 8] Make md on-disk bitmaps not host-endian
 [PATCH md 008 of 8] Support BIO_RW_BARRIER for md/raid1.
