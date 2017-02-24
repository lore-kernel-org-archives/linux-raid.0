From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 00/14] the latest changes for md-cluster
Date: Fri, 24 Feb 2017 11:15:10 +0800
Message-ID: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Hi,

This patchset is based on md/for-next branch, which includes below parts:

1. some code improvements (0001-0004).
2. changes for use sync way to handle METADATA_UPDATED msg (0005-0009).
3. add resize support for md-cluster (0010-0012 and 0014), and also
   make some related changes inside md (0013).

Thanks,
Guoqing   
