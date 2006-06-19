From: Ming Zhang <mingz@ele.uri.edu>
Subject: [patch] typo
Date: Mon, 19 Jun 2006 17:33:51 -0400
Message-ID: <1150752832.7656.339.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

There are 2 small typos in md.4

Signed-Off-By Ming Zhang <mingz@ele.uri.edu>

 md.4 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


--- md.4.old    2006-06-19 16:35:46.000000000 -0400
+++ md.4        2006-06-19 16:36:30.000000000 -0400
@@ -100,8 +100,8 @@
 .TP
 RAID1
 In some configurations it might be desired to create a raid1
-configuration that does use a superblock, and to maintain the state of
-the array elsewhere.  While not encouraged for general us, it does
+configuration that does not use a superblock, and to maintain the state of
+the array elsewhere.  While not encouraged for general use, it does
 have special-purpose uses and is supported.

 .SS LINEAR


