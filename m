From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] md/raid0: fix uninitialized variable bug
Date: Thu, 14 Apr 2016 12:31:49 +0300
Message-ID: <20160414093149.GA16549@mwanda>
References: <20160413170240.GB6186@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413170240.GB6186@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

If this function fails the callers expect that *private_conf is set to
an ERR_PTR() but that isn't true for the first error path where we can't
allocate "conf".  It leads to some uninitialized variable bugs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Shaohua suggested a different fix

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 2ea12c6..f63dbb6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -85,6 +85,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	unsigned short blksize = 512;
 
+	*private_conf = ERR_PTR(-ENOMEM);
 	if (!conf)
 		return -ENOMEM;
 	rdev_for_each(rdev1, mddev) {
