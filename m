From: Wakko Warner <wakko@animx.eu.org>
Subject: RAID5 made with assume-clean
Date: Wed, 6 Feb 2013 06:52:58 -0500
Message-ID: <20130206115258.GA31466@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was testing different parameters with --assume-clean to avoid the initial
rebuild.  When I decided on the parameters I wanted, I forgot to create the
array without --assume-clean.  I have 3 disks in the array.

I thought that I'd run a check on it by doing
echo check > /sys/block/md0/md/sync_action

/proc/mdstat is showing this:
Personalities : [raid1] [raid6] [raid5] [raid4] 
md0 : active raid5 sda1[0] sdb1[1] sdc1[2]
      488018688 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      [============>........]  check = 61.7% (150688512/244009344) finish=7.1min speed=216592K/sec

unused devices: <none>

The thing is, the drives can only do ~60mb/sec and there is no disk
activity.  The activity lights are not lit at all.  What would cause that?

I was also wondering if the raid5 did RMW on the parity with 3 disks when
the array is written to.

I can rebuild the array without assume-clean if that's the only way I can
get the parity to be correct, but I'd like to avoid doing that if possible.

I also have backups of the array if it gets trashed.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
