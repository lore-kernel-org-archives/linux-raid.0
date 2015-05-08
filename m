From: Hans Kraus <hans@hanswkraus.com>
Subject: mdadm Raid level change from 1 to 5?
Date: Fri, 08 May 2015 11:18:44 +0200
Message-ID: <554C7F74.5010404@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a Raid 1 with 3 drives, the following layout (the internal
bitmap is already removed):
-----------------------------------------------------------------
md20 : active raid1 sdj1[2] sdi1[1] sdn1[0]
       732442432 blocks super 1.2 [3/3] [UUU]
-----------------------------------------------------------------
I tried to change it to Raid 5, but I'm getting aways an error.
-----------------------------------------------------------------
mdadm --grow /dev/md20 --level=5 --raid-devices=3 -c 32 \
   --backup-file=/home/kraush/work/raidLevelChange

Impossibly level change request for RAID1
-----------------------------------------------------------------
I tried it with various permutations (+/- raid-devices, c, ...).

Is something in my command wrong or is the level change not
possible?
This is on Debian 7, mdadm - v3.3-65-g2167de7 - 11th March 2014

Regards, Hans



