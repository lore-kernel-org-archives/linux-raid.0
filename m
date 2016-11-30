From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH 0/2] Reorganize raid*_make_request to clean up code
Date: Wed, 30 Nov 2016 14:20:18 -0700
Message-ID: <20161130212020.15762-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert LeBlanc <robert@leblancnet.us>
List-Id: linux-raid.ids

In response to Christoph, I've broken the read and writes into their own
functions to make the code even cleaner. Since it is such a big change, I broke
up the commits into this series instead of creating a v2 of the previous patch.

Robert LeBlanc (2):
  md/raid1: Refactor raid1_make_request
  md/raid10: Refactor raid10_make_request

 drivers/md/raid1.c  | 244 +++++++++++++++++++++++-----------------------
 drivers/md/raid10.c | 271 +++++++++++++++++++++++++++-------------------------
 2 files changed, 265 insertions(+), 250 deletions(-)

-- 
2.10.2

