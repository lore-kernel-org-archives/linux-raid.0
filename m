From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 0/5] the latest changes for md-cluster
Date: Wed,  1 Mar 2017 16:42:35 +0800
Message-ID: <1488357760-7893-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since 2, 3 and 13 are merged, so the relationship between V2
and previous patchset are:
	 V2	 	     old
	0001 -> 0004, 0005, 0006, 0008 and 0009
	0002 -> 	    0007
	0003 -> 	    0010
	0004 -> 	0011 and 0012
	0005 -> 	    0014
     
     
And based on Shaohua's comments, this version also changes:

1. discard the first patch for now.
2. add mode check before destroy bitmap.
3. for patch 11, add more codes to handle lockres_init returns err.
4. call revalidate_disk after set_capacity in both patch 3 and 5.

Thanks,
Guoqing
