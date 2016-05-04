From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 0/2] Check node nums for cluster raid
Date: Wed,  4 May 2016 16:33:42 +0800
Message-ID: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

For cluster raid, we do need at least two nodes for it,
the two patches add the checks before create and change
bitmap.

Thanks,
Guoqing    

Guoqing Jiang (2):
  Create: check the node nums when create clustered raid
  super1: don't update node nums if it is not more than 1

 Create.c | 7 ++++++-
 super1.c | 5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.6.2

