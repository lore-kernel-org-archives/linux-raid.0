From: Pol Hallen <raid1@fuckaround.org>
Subject: check which disk is a problem
Date: Thu, 19 May 2011 12:34:39 +0200
Message-ID: <201105191234.39391.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks :-)

I've a raid6 sw on debian stable and a problem (!):

cat /proc/mdstat

Personalities : [raid6] [raid5] [raid4] 
md0 : active raid6 sdc1[0] sdf1[5] sdg1[4] sdh1[3] sdd1[1]
      5860543744 blocks level 6, 64k chunk, algorithm 2 [6/5] [UU_UUU]

so, I think /dev/sde is corrupted disk

How identify this disk?

blkid:

/dev/sdc1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d" 
TYPE="linux_raid_member" 
/dev/sdd1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d" 
TYPE="linux_raid_member" 
/dev/sde1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d" 
TYPE="linux_raid_member" 
/dev/sdf1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d" 
TYPE="linux_raid_member" 
/dev/sdg1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d" 
TYPE="linux_raid_member" 
/dev/sdh1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d" 
TYPE="linux_raid_member" 

has same uuid, why?

and now how can I resolve?

thanks!

 
Pol
