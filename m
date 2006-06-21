From: David Greaves <david@dgreaves.com>
Subject: bitmap status question
Date: Wed, 21 Jun 2006 18:16:43 +0100
Message-ID: <44997EFB.8080308@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How do I interpret:
      bitmap: 0/117 pages [0KB], 1024KB chunk
in the mdstat output

what does it mean when it's, eg: 23/117

cu:/huge# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [raid6]
md0 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
hdb1[6](S)
      1225543680 blocks level 5, 4096k chunk, algorithm 2 [6/6] [UUUUUU]
      bitmap: 0/117 pages [0KB], 1024KB chunk


David

-- 

