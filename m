From: dean gaudet <dean@arctic.org>
Subject: normal writes during raid resync
Date: Wed, 18 Jan 2006 18:28:46 -0800 (PST)
Message-ID: <Pine.LNX.4.63.0601181801570.29932@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi...

i wanted to confirm my reading of the raid1 code during a resync.

from my reading, all writes go to all non-faulty disks even if the write 
is beyond the current sync point and the disks are being resync'd... is 
that correct?  and writes are delayed when they overlap the current sync 
point... and issue after the sync passes by.

i had a (2.4 kernel) box with a 3-way raid1 crash recently and on reboot 
it started resyncing from the 0th disk in the array... then 12h later that 
0th disk failed before the resync finished (system was way too busy to 
handle the resync).

at first i was worried i would have to go back to backup, but when i 
thought it through and inspected the code i convinced myself i probably 
had an almost perfect copy of the array on either disk 1 or disk 2...

i.e. at crash disk 0,1,2 were at most a few thousand sectors out of 
sync... the usual crash situation.  but during resync, if my reading of 
the code is right, all writes went to all disks, even those beyond the 
sync point... so after the disk 0 failure disks 1 and 2 had possibly the 
original few thousand sectors out of sync plus the sectors that were being 
sync'd at disk 0 failure time.

anyhow even if my reading is wrong i got the system back on its feet 
without resorting to backups... and the only corrupted files discovered so 
far were in-flight at the time of the crash and/or disk 0 failure, so 
that's expected.

thanks
-dean
