From: PFC <lists@peufeu.com>
Subject: echo check > .../sync_action displays "resync" in mdstat
Date: Sun, 28 May 2006 11:07:01 +0200
Message-ID: <op.s987lzy4cigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	A little nit-picking...

# echo check > /sys/block/md0/md/sync_action

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid4]
md1 : active raid1 sda7[1] hda7[0]
       6253248 blocks [2/2] [UU]

md2 : active raid5 sdd1[2] sdc1[3] sdb1[1] hdc1[0] hdb1[4]
       976783616 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

md0 : active raid1 sda6[1] hda6[0]
       109464896 blocks [2/2] [UU]
       [>....................]  resync =  2.7% (3025664/109464896)  
finish=41.8min speed=42425K/sec


	It says "resync"... is it resyncing or just checking ?
