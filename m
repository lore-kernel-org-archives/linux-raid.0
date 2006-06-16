From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: ANNOUNCE: mdadm 2.5.1 - A tool for managing Soft RAID under Linux
Date: Fri, 16 Jun 2006 11:46:51 -0400
Message-ID: <4492D26B.4070705@steeleye.com>
References: <17554.895.666628.776527@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050901040603040509060802"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17554.895.666628.776527@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050901040603040509060802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Neil Brown wrote:
> 
> I am pleased to announce the availability of
>    mdadm version 2.5.1

Hi Neil,

Here's a small patch to allow compilation on gcc 2.x. It looks like gcc 
3.x allows variable declarations that are not at the start of a block of 
code (I don't know if there's some standard that allows that in C code 
now, but it doesn't work with all C compilers).

Patch attached.

Thanks,
Paul

--------------050901040603040509060802
Content-Type: text/plain;
 name="mdadm-2.5.1-super1-compile-error.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-2.5.1-super1-compile-error.diff"

--- mdadm-2.5.1/super1.c.orig	Fri Jun 16 11:27:16 2006
+++ mdadm-2.5.1/super1.c	Fri Jun 16 11:28:20 2006
@@ -309,6 +309,7 @@ static void brief_examine_super1(void *s
 	struct mdp_superblock_1 *sb = sbv;
 	int i;
 	char *nm;
+	char *c=map_num(pers, __le32_to_cpu(sb->level));
 
 	nm = strchr(sb->set_name, ':');
 	if (nm)
@@ -317,8 +318,6 @@ static void brief_examine_super1(void *s
 		nm = sb->set_name;
 	else
 		nm = "??";
-
-	char *c=map_num(pers, __le32_to_cpu(sb->level));
 
 	printf("ARRAY /dev/md/%s level=%s metadata=1 num-devices=%d UUID=",
 	       nm,

--------------050901040603040509060802--
