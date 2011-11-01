From: Krzysztof Adamski <k@adamski.org>
Subject: [md PATCH 1/1] add display of hours remaining to finish resync
Date: Tue, 01 Nov 2011 17:53:47 -0400
Message-ID: <1320184427.6471.70.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is my first patch, so please be gentle.

This patch adds the display of the number of hours till the completion
of resync of an array in the /proc/mdstat display.

Example: [>....................]  resync =  3.3% (98633240/2928311808)
finish=1026.1min (17h) speed=45957K/sec

Signed-off-by: Krzysztof Adamski <k@adamski.org>

# diff -Naru drivers/md/md.c-orig  drivers/md/md.c
--- drivers/md/md.c-orig        2011-10-25 01:11:12.000000000 -0400
+++ drivers/md/md.c     2011-11-01 17:37:35.000000000 -0400
@@ -6351,8 +6351,8 @@
        rt *= dt;
        rt >>= 5;
 
-       seq_printf(seq, " finish=%lu.%lumin", (unsigned long)rt / 60,
-                  ((unsigned long)rt % 60)/6);
+       seq_printf(seq, " finish=%lu.%lumin (%luh)", (unsigned long)rt /
60,
+                  ((unsigned long)rt % 60)/6, (unsigned long)rt / 60 /
60);
 
        seq_printf(seq, " speed=%ldK/sec", db/2/dt);
 }



