From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH 0/2] Modify read error handle for RAID-4,5,6.
Date: Sat, 26 May 2012 10:52:50 +0800
Message-ID: <201205261052422815923@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When RAID-4,5,6 degraded and met read-error, it will eject the rdev.And then
the RAID will fail and lost data.Because the function of set-badsector,when 
this occur,it will set-badsector,not ejecting the rdev.
When RAID-4,5,6 met read-error, it will re-write if RAID was not degrade.But if 
re-write error,it will eject the rdev and RAID will degrade and it will take too
long time for recoverying.So I add judgement for controling how may re-write-error
can eject the rdev.

I do those for flexible controling the read-error for different situation.
	

majianpeng (2):
  md/raid456: When readed error and raid was degraded,it try to
    set badsector, not ejecting the rdev.
  md/raid456:Add interface for contorling eject rdev when re-write
    failed.

 drivers/md/md.c    |   35 +++++++++++++++++++++++++++++++++++
 drivers/md/md.h    |    2 ++
 drivers/md/raid5.c |   28 +++++++++++++++++++---------
 3 files changed, 56 insertions(+), 9 deletions(-)

-- 
1.7.5.4
 				
--------------
majianpeng
2012-05-26

