From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: WARNING: Software Raid 0 on SSD's and discard corrupts data
Date: Thu, 21 May 2015 08:24:28 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1505210822150.9060@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hello,

all users using a Software Raid 0 on SSD's with discard should disable
discard, if they use any recent kernel since mid-April 2015. The bug
was introduced by commit 47d68979cc968535cb87f3e5f2e6a3533ea48fbd and
the fix is not yet in Linus tree. The fix can be found here:

    http://git.neil.brown.name/?p=md.git;a=commitdiff;h=a81157768a00e8cf8a7b43b5ea5cac931262374f

Users should immediately remove the discard option from any mounted
software Raid 0 filesystems. Any delete or modification of files can
lead to random destruction on the filesystem. Use the remount option
of the mount command to remove the discard option. Do not do it via
editing /etc/fstab if your root filesystem is on a software raid 0.

Regards,
Holger
