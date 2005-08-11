From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 000 of 6] Introduction
Date: Thu, 11 Aug 2005 17:22:26 +1000
Message-ID: <20050811171720.10115.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The following 6 patches for md mostly add some new functionality (hot-adding 
write-intent bitmaps and write-behind support for raid1).
They can, and should, wait for after 2.6.13 is released.

The first patch fixes a bug which could be annoying, and is probably
suitable for 2.6.13, however I suspect it is too late for 2.6.13, and
it is ok to be left.

The bug is that if you create an array with an internal bitmap, shut
it down, and then create an array with the same md device, the md
drive will assume it should have a bitmap too.  As the array can be
created with a different md device, it is mostly an inconvenience.
I'm pretty sure there is no risk of data corruption.

NeilBrown


 [PATCH md 001 of 6] Make sure mddev->bitmap_offset gets cleared between array instantiations.
 [PATCH md 002 of 6] Don't allow new md/bitmap file to be set if one already exists
 [PATCH md 003 of 6] Improve handling of bitmap initialisation.
 [PATCH md 004 of 6] All hot-add and hot-remove of md intent logging bitmaps
 [PATCH md 005 of 6] Support write-mostly device in raid1
 [PATCH md 006 of 6] Add write-behind support for md/raid1
