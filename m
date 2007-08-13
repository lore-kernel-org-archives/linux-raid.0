From: joe@perches.com
Subject: [PATCH] [442/2many] MAINTAINERS - SOFTWARE RAID (Multiple Disks)
 SUPPORT
Date: Sun, 12 Aug 2007 23:36:01 -0700
Message-ID: <46bffbd1.6OOR1+/x0yRKyfpY%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org, neilb@suse.de, mingo@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-raid.ids

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d17ae3d..29a2179 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4205,6 +4205,8 @@ P:	Neil Brown
 M:	neilb@suse.de
 L:	linux-raid@vger.kernel.org
 S:	Supported
+F:	drivers/md/
+F:	include/linux/raid/
 
 HIBERNATION (aka Software Suspend, aka swsusp):
 P:	Pavel Machek
