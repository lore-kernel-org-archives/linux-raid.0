From: Aaron <aaront@cmu.edu>
Subject: RAID5 and missing superblocks
Date: Sun, 09 Jan 2005 17:40:07 -0800
Message-ID: <1105321207.24159.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 3 disk RAID5 device that has had all 3 superblocks zeroed out
(don't ask, it's hard enough to even admit it ...).  The disks are
healthy and the data is there, but is there any way to ever assemble the
array again?  I have tried the simple approaches with mdadm --assemble
--force and raidstart with no luck.

Thanks,
Aaron


