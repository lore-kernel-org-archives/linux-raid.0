From: Jes.Sorensen@redhat.com
Subject: [PATCH] Add zlib license to crc32.c
Date: Wed,  3 Oct 2012 10:00:34 +0200
Message-ID: <1349251234-1703-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 crc32.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/crc32.c b/crc32.c
index 12d08e5..94fda06 100644
--- a/crc32.c
+++ b/crc32.c
@@ -2,6 +2,26 @@
  * Copyright (C) 1995-2003 Mark Adler
  * For conditions of distribution and use, see copyright notice in zlib.h
  *
+ * Note: zlib license from from zlib.h added explicitly as mdadm does
+ *       not include zlib.h. License from v1.2.2 of zlib:
+ *
+ *  This software is provided 'as-is', without any express or implied
+ *  warranty.  In no event will the authors be held liable for any damages
+ *  arising from the use of this software.
+ *
+ *  Permission is granted to anyone to use this software for any purpose,
+ *  including commercial applications, and to alter it and redistribute it
+ *  freely, subject to the following restrictions:
+ *
+ *  1. The origin of this software must not be misrepresented; you must not
+ *     claim that you wrote the original software. If you use this software
+ *     in a product, an acknowledgment in the product documentation would be
+ *     appreciated but is not required.
+ *  2. Altered source versions must be plainly marked as such, and must not be
+ *     misrepresented as being the original software.
+ *  3. This notice may not be removed or altered from any source distribution.
+ *
+ *
  * Thanks to Rodney Brown <rbrown64@csc.com.au> for his contribution of faster
  * CRC methods: exclusive-oring 32 bits of data at a time, and pre-computing
  * tables for updating the shift register in one step with three exclusive-ors
-- 
1.7.11.4

