From: Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH] lib/raid6: ignore generated files
Date: Mon, 23 Aug 2010 19:25:30 +0200
Message-ID: <m2d3t9z1f9.fsf@igel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 lib/raid6/.gitignore |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 lib/raid6/.gitignore

diff --git a/lib/raid6/.gitignore b/lib/raid6/.gitignore
new file mode 100644
index 0000000..730e5ec
--- /dev/null
+++ b/lib/raid6/.gitignore
@@ -0,0 +1,12 @@
+int1.c
+int2.c
+int4.c
+int8.c
+int16.c
+int32.c
+altivec1.c
+altivec2.c
+altivec4.c
+altivec8.c
+tables.c
+mktables
-- 
1.7.2.2

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
