From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 2] md: Introduction
Date: Mon, 22 May 2006 16:18:45 +1000
Message-ID: <20060522161259.2792.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Don Dupuis <dondster@gmail.com>
List-Id: linux-raid.ids

Two patches to fix two possibly Oopses in md/raid
Both are suitable for 2.6.17.

Both involve indexing off the end of the array, and only cause a
problem if the ends up hitting a non-mapped page.

The first only affects raid0 is fairly rare put possible circumstances.

The second can affect all users of bio_split: linear, raid0, raid10

Thanks to Don Dupuis for hitting these bugs!

 [PATCH 001 of 2] md: Fix possible oops when starting a raid0 array
 [PATCH 002 of 2] md: Make sure bi_max_vecs is set properly in bio_split
