From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] raid10: increment write counter after bio is split
Date: Thu, 28 Jul 2016 10:28:25 +0200
Message-ID: <1469694505-20018-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

md pending write counter must be incremented after bio is split,
otherwise it gets decremented too many times in end bio callback and
becomes negative.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c7de2a5..cfa96b5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1072,6 +1072,8 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	int max_sectors;
 	int sectors;
 
+	md_write_start(mddev, bio);
+
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
@@ -1455,8 +1457,6 @@ static void raid10_make_request(struct mddev *mddev, struct bio *bio)
 		return;
 	}
 
-	md_write_start(mddev, bio);
-
 	do {
 
 		/*
-- 
1.8.3.1

