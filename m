From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH v2 0/2] Reorganize raid*_make_request to clean up code
Date: Thu,  1 Dec 2016 20:30:06 -0700
Message-ID: <20161202033008.30314-1-robert@leblancnet.us>
References: <20161130212020.15762-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161130212020.15762-1-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert LeBlanc <robert@leblancnet.us>
List-Id: linux-raid.ids

In response to Christoph, I've broken the read and writes into their own
functions to make the code even cleaner. Since it is such a big change, I broke
up the commits into this series instead of creating a v2 of the previous patch.

Changes since v1:
 
 John Stoffel
 * Changed to if/then instead of return in raid1_make_request

 Neil Brown
 * Moved wait_barrier into raid1_{read,write}_request so that it could be after
   ->suspend_{hi,lo}. This prevents a write blocking a resync until the suspend
   region is moved.

Robert LeBlanc (2):
  md/raid1: Refactor raid1_make_request
  md/raid10: Refactor raid10_make_request

 drivers/md/raid1.c  | 241 ++++++++++++++++++++++++----------------------
 drivers/md/raid10.c | 271 +++++++++++++++++++++++++++-------------------------
 2 files changed, 264 insertions(+), 248 deletions(-)

-- 
2.10.2

