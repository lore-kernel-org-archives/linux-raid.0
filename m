From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
Date: Wed, 30 Oct 2013 13:20:22 +0100
Message-ID: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

In case of reshape of raid0 through raid4 a value of discard_granularity
will be set to stripe size. MD driver should re-set this value to correct
one when migration will be finished. Otherwise array will be left with
wrong value and discard operations will not work properly.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: Shaohua Li <shli@kernel.org>
---
 drivers/md/raid0.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c4d420b..807ca3a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -266,6 +266,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
+	mddev->queue->limits.discard_granularity =
+			queue_logical_block_size(mddev->queue);
 
 	/*
 	 * now since we have the hard sector sizes, we can make sure
