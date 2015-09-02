From: Christoph Hellwig <hch@lst.de>
Subject: fix use after free in raid5-cache
Date: Wed,  2 Sep 2015 16:14:45 +0200
Message-ID: <1441203288-22515-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, neilb@suse.de
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, Kernel-team@fb.com
List-Id: linux-raid.ids

Hi Shaohua, hi Neil,

this series fixes a use after free of the r5l_io_unit structure I ran into
while testing the caching code.  The real fix is in patch 3, but other two
patches contain refactoring to enable the fix.

