From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Question: read-only array
Date: Mon, 6 Feb 2006 17:41:21 +0100
Message-ID: <20060206174121.2b528f5f@mwdsp001.swissptt.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi

I've just noticed that setting an array readonly doesn't really make
it readonly.

I have a RAID1 array and LVM on top of it.

When I run 

/sbin/mdadm --misc --readonly /dev/md0

/proc/mdstat shows:

Personalities : [raid1]
md0 : active (read-only) raid1 sda[0] sdb[1]
      160436096 blocks [2/2] [UU]

However, it doesn't prevent me from activating volume groups, mounting 
filesystems and write files onto it.

Is it a bug, feature or my misunderstanding of the meaning of readonly flag?


I use RedHat AS 4 (U1) on a dual core Opteron machine.
Kernel 2.6.9-11.ELsmp as delivered with RH.

mdadm - v1.12.0 - 14 June 2005

Thanks for your time.

Regards,
Chris
