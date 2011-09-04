From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] trival: md_k.h should be md.h in the beginning comment of
 file md.h
Date: Sun, 04 Sep 2011 19:13:56 +0800
Message-ID: <4E635D74.7090808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The patch is against 3.1-rc3.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 drivers/md/md.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1e586bb..4b304ad 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1,5 +1,5 @@
 /*
-   md_k.h : kernel internal structure of the Linux MD driver
+   md.h : kernel internal structure of the Linux MD driver
           Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
 	  
    This program is free software; you can redistribute it and/or modify
-- 
1.7.1

