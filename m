From: satha <satha_koti@yahoo.co.in>
Subject: Request on RAID5
Date: Sat, 27 Jun 2009 05:16:46 +0000 (UTC)
Message-ID: <loom.20090627T051604-240@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
 
 Iam using 2.6.27 kernel. Connected 8 disks using Silicon Image and Marvell 
Rocket RAID PCIe express cards.
 
 Can any one help me in debugging the following problem:
 
There is a kernel bug detected in __get_priority_stripe() 
BUG_ON(atomic_read(&sh->count) != 1) while testing RAID5, 
writing morethan 20GB data using dd, several times.
 
Is Iam missing any configurations, can anyone briefly explain what exactly 
this function doing.
 
Thanks inadvance,
Satha

