From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 0 of 7 - Introduction
Date: Fri, 06 Feb 2004 16:35:51 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040206162532.30220.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-raid.ids

Hi again.

Here are 7 patches for md in 2.4.3-pre-current

The first flags the START_ARRAY as deprecated - I plan to remove it in 2.7.
The comment with that patch explains why.

The next 5 provide some cleanup of raid1 code leading to a patch which 
enabled raid1 to safely use large requests when resyncing (it uses 
bio_add_page to make sure each page is allowed).  This substantially increases
resync speed in atleast one test.

The final patch in a new version of the partitioning patch.
It removes the rather ugly code for forcing the partitions to be 
re-evaluated and instead makes simple arranges for them to be reread 
on the next open.  This fixes the one bug that was reported against the
patch.
I have also taken onboard some of the feedback I got about the patch.

NeilBrown
