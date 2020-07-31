From: allenpeng <allenpeng@synology.com>
Subject: [PATCH 0/2] Fix RCW bug and allow degraded raid6 do rmw
Date: Fri, 31 Jul 2020 17:49:58 +0800
Message-ID: <1596188998-2994-1-git-send-email-allenpeng@synology.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, ChangSyun Peng <allenpeng@synology.com>
List-Id: linux-raid.ids

From: ChangSyun Peng <allenpeng@synology.com>

This patch fix io stuck in force reconstruct-write degraded raid5
problem and allow degraded raid6 do rmw.

ChangSyun Peng (2):
  md/raid5: Fix Force reconstruct-write io stuck in degraded raid5
  md/raid5: Allow degraded raid6 to do rmw

 drivers/md/raid5.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

-- 
2.7.4
