From: =?iso-8859-2?Q?Krzysztof_B=B3aszkowski?= <info@sysmikro.com.pl>
Subject: a vm address of rdev's sb_page
Date: Fri, 15 Oct 2004 17:50:39 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000d01c4b2ce$ba83bf60$21ffffc0@sysc1300>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I couldn't access easy a rdev super block (mdp_superblock_s) by remote gdb
(exactly at the places where I wish to print it), so are there any
constraints against keep a mdp_supeblock_t * sb_rdev in mdk_rdev_s as well
as  page *sb_page ? like in 2.4 kernel ? It could also make better overall
performance due to that page_address() calls would be unnecessary.

The pointer could be  kmapp'ed once after the sb_page is set and kept as
long as drive is present in the array.

Regards,
Krzysztof Blaszkowski

