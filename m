From: "B. J. Zolp" <bjzolp@wisc.edu>
Subject: RAID5 Not coming back up after crash
Date: Mon, 29 Nov 2004 10:33:22 -0600
Message-ID: <41AB4F52.3030001@wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID5 setup on my fileserver using disks hda1 hdb1 hdc1 hdd1 
hdi1 and hdj1.  Yesterday I started moving a large chunk of files ~80GB 
from this array to a stand alone drive in the system and about halfway 
through the mv I got a ton of PERMISSION DENIED errors some of the 
remaining files left to be moved and the move process quit.  I did a ls 
of the raid directory and got PERMISSION DENIED on the same files that 
errored out on the mv while some of the other files looked fine.  I 
figured it might be a good idea to take the raid down and back up again 
(probably a mistake) and I could not reboot the machine without 
physically turning it off as some processes were hung.  Upon booting 
back up, the raid did not come online stating that hdj1 was kicked due 
to inconsistency.  Additionally hdb1 is listed as offline too.  So I 
have 2 drives that are not cooperating.  I have a hunch hdb1 might have 
not been working for some time.

I found some info stating that if you mark the drive that failed first 
as "failed-drive" and try a  "mkraid --force --dangerous-no-resync 
/dev/md0" then I might have some luck getting my files back.  From my 
logs I can see that all the working drives have event counter: 00000022 
and hdj1 has event counter: 00000021 and hdb1 has event counter: 
00000001.  Does this mean that hdb1 failed a log time ago or is this 
difference in event counters likely within a few minutes fo each other?  
I just ran badblocks on both hdb1 and hdj1 and found 1 bad block on hdb1 
and about 15 on hdj1, would that be enough to cause my raid to get this 
out of whack?  In any case I plan to replace those drives, but would the 
method above be the best route once I have copied the raw data to the 
new drives in order to bring my raid back up?


Thanks,

bjz

here is my log from when I run raidstart /dev/md0:

Nov 29 10:10:19 orion kernel:  [events: 00000022]
Nov 29 10:10:19 orion last message repeated 3 times
Nov 29 10:10:19 orion kernel:  [events: 00000021]
Nov 29 10:10:19 orion kernel: md: autorun ...
Nov 29 10:10:19 orion kernel: md: considering hdj1 ...
Nov 29 10:10:19 orion kernel: md:  adding hdj1 ...
Nov 29 10:10:19 orion kernel: md:  adding hdi1 ...
Nov 29 10:10:19 orion kernel: md:  adding hdd1 ...
Nov 29 10:10:19 orion kernel: md:  adding hdc1 ...
Nov 29 10:10:19 orion kernel: md:  adding hda1 ...
Nov 29 10:10:19 orion kernel: md: created md0
Nov 29 10:10:19 orion kernel: md: bind<hda1,1>
Nov 29 10:10:19 orion kernel: md: bind<hdc1,2>
Nov 29 10:10:19 orion kernel: md: bind<hdd1,3>
Nov 29 10:10:19 orion kernel: md: bind<hdi1,4>
Nov 29 10:10:19 orion kernel: md: bind<hdj1,5>
Nov 29 10:10:19 orion kernel: md: running: <hdj1><hdi1><hdd1><hdc1><hda1>
Nov 29 10:10:19 orion kernel: md: hdj1's event counter: 00000021
Nov 29 10:10:19 orion kernel: md: hdi1's event counter: 00000022
Nov 29 10:10:19 orion kernel: md: hdd1's event counter: 00000022
Nov 29 10:10:19 orion kernel: md: hdc1's event counter: 00000022
Nov 29 10:10:19 orion kernel: md: hda1's event counter: 00000022
Nov 29 10:10:19 orion kernel: md: superblock update time inconsistency 
-- using the most recent one
Nov 29 10:10:19 orion kernel: md: freshest: hdi1
Nov 29 10:10:19 orion kernel: md0: kicking faulty hdj1!
Nov 29 10:10:19 orion kernel: md: unbind<hdj1,4>
Nov 29 10:10:19 orion kernel: md: export_rdev(hdj1)
Nov 29 10:10:19 orion kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Nov 29 10:10:19 orion kernel: md0: max total readahead window set to 2560k
Nov 29 10:10:19 orion kernel: md0: 5 data-disks, max readahead per 
data-disk: 512k
Nov 29 10:10:19 orion kernel: raid5: device hdi1 operational as raid disk 4
Nov 29 10:10:19 orion kernel: raid5: device hdd1 operational as raid disk 3
Nov 29 10:10:19 orion kernel: raid5: device hdc1 operational as raid disk 2
Nov 29 10:10:19 orion kernel: raid5: device hda1 operational as raid disk 0
Nov 29 10:10:19 orion kernel: raid5: not enough operational devices for 
md0 (2/6 failed)
Nov 29 10:10:19 orion kernel: RAID5 conf printout:
Nov 29 10:10:19 orion kernel:  --- rd:6 wd:4 fd:2
Nov 29 10:10:19 orion kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hda1
Nov 29 10:10:19 orion kernel:  disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 
00:00]
Nov 29 10:10:19 orion kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdc1
Nov 29 10:10:19 orion kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdd1
Nov 29 10:10:19 orion kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hdi1
Nov 29 10:10:19 orion kernel:  disk 5, s:0, o:0, n:5 rd:5 us:1 dev:[dev 
00:00]
Nov 29 10:10:19 orion kernel: raid5: failed to run raid set md0
Nov 29 10:10:19 orion kernel: md: pers->run() failed ...
Nov 29 10:10:19 orion kernel: md :do_md_run() returned -22
Nov 29 10:10:19 orion kernel: md: md0 stopped.
Nov 29 10:10:19 orion kernel: md: unbind<hdi1,3>
Nov 29 10:10:19 orion kernel: md: export_rdev(hdi1)
Nov 29 10:10:19 orion kernel: md: unbind<hdd1,2>
Nov 29 10:10:19 orion kernel: md: export_rdev(hdd1)
Nov 29 10:10:19 orion kernel: md: unbind<hdc1,1>
Nov 29 10:10:19 orion kernel: md: export_rdev(hdc1)
Nov 29 10:10:19 orion kernel: md: unbind<hda1,0>
Nov 29 10:10:19 orion kernel: md: export_rdev(hda1)
Nov 29 10:10:19 orion kernel: md: ... autorun DONE.
