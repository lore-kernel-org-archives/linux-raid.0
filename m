From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] change back 0644 permission for Grow.c
Date: Tue,  2 May 2017 17:27:13 +0800
Message-ID: <1493717233-32524-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Fixes commit:
26714713cd2b ("mdadm: Change timestamps to unsigned data type.")

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Grow.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 Grow.c

diff --git a/Grow.c b/Grow.c
old mode 100755
new mode 100644
-- 
2.6.6

