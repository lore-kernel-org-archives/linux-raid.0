From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH/RFC 0/2] md: personality pushdown patches -- intro
Date: Fri, 29 May 2009 15:18:40 +0200
Message-ID: <1243603122-11116-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Here are the first two patches for pushing down raid level dependent
code from md.c to the corresponding personalities.

The first patch is trivial as it moves only a printk() to the
personalities. The second patch removes knowledge about bitmaps
from md.c.

If the general approach used by the second patch is agreed with, I
will follow up with patches that deal with data integrity registration
and multipath handling which are the remaining two issues where md.c
does what should be handled in personality code.

Thanks
Andre
-- 
1.5.4.3

