From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Proposed enhancement to mdadm:  Allow "--write-behind=" to be done
	in grow mode.
Date: Tue, 03 Jul 2007 22:42:09 +0930
Message-ID: <1183468329.395.59.camel@sibyl.beware.dropbear.id.au>
References: <1183038727.3792.9.camel@sibyl.beware.dropbear.id.au>
	 <1183130939.4544.6.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1183130939.4544.6.camel@sibyl.beware.dropbear.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There doesn't seem to be any designated place to send bug reports and
feature requests to mdadm, so I hope I am doing the right thing by
sending it here.

I have a small patch to mdamd which allows the write-behind amount to be
set a array grow time (instead of currently only at grow or create
time). I have tested this fairly extensively on some arrays built out of
loop back devices, and once on a real live array. I haven't lot any data
and it seems to work OK, though it is possible I am missing something.

--- mdadm-2.6.1/mdadm.c.writebehind	2006-12-21 16:12:50.000000000 +1030
+++ mdadm-2.6.1/mdadm.c	2007-06-30 13:16:22.000000000 +0930
@@ -827,6 +827,7 @@
 			bitmap_chunk = bitmap_chunk ? bitmap_chunk * 1024 : 512;
 			continue;
 
+		case O(GROW, WriteBehind):
 		case O(BUILD, WriteBehind):
 		case O(CREATE, WriteBehind): /* write-behind mode */
 			write_behind = DEFAULT_MAX_WRITE_BEHIND;


-- 
Ian Dall <ian@beware.dropbear.id.au>

