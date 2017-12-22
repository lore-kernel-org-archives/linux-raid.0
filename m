From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] doc: md: Fix a file name to md-fault.c in fault-injection.txt
Date: Sat, 23 Dec 2017 01:41:21 +0900
Message-ID: <20171222164121.18054-1-standby24x7@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: snitzer@redhat.com, shli@fb.com, linux-kernel@vger.kernel.org, corbet@lwn.net, linux-raid@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
List-Id: linux-raid.ids

drivers/md/faulty.c has been renamed to md-faulty.c after
following commit merged int to the main line.

  935fe0983e09f4f7331ebf5ea4ae2124f6e9f9e8 .

But the file name in fault-injection.txt has not been changed.
Now the actual file name and document are in sync.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/fault-injection/fault-injection.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/fault-injection/fault-injection.txt b/Documentation/fault-injection/fault-injection.txt
index 918972babcd8..1c0bfbbf7869 100644
--- a/Documentation/fault-injection/fault-injection.txt
+++ b/Documentation/fault-injection/fault-injection.txt
@@ -1,7 +1,7 @@
 Fault injection capabilities infrastructure
 ===========================================
 
-See also drivers/md/faulty.c and "every_nth" module option for scsi_debug.
+See also drivers/md/md-faulty.c and "every_nth" module option for scsi_debug.
 
 
 Available fault injection capabilities
-- 
2.15.1.433.g936d1b989416

