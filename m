From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH 0/2] Fix near layout I/O distribution
Date: Thu,  3 Nov 2016 17:45:06 -0600
Message-ID: <20161103234508.12641-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This fixes a small typo from when the code was copied from raid1 and removes a
loop break when a read is atomic on only 'near' layouts. 'Far' layouts never
triggered this break and so it would spread all read I/Os to all available
devices. This removes that break since it is contrary to the comments previous
to it and works as intended in the 'far' layout. After this change random I/O
for 'near' layout is distributed to all disks instead of being all serviced by
the first disk.  Sequential I/O is not affected as it would not trigger the
break.

i.e. Before patch
# mdadm --create /dev/md14 --level 10 --raid-devices 4 -p n4 /dev/loop{11..14}
# fio -rw=randread --size=5G --name=mdadm_test
<snip>
Disk stats (read/write):
   md14: ios=1304718/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=327680/0, aggrmerge=0/0, aggrticks=18719/0, aggrin_queue=18689,
aggrutil=88.37%
 loop13: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
 loop11: ios=1310108/0, merge=0/0, ticks=74856/0, in_queue=74736, util=88.37%
 loop14: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
 loop12: ios=612/0, merge=0/0, ticks=20/0, in_queue=20, util=0.02%

After patch:

<snip>
Disk stats (read/write):
    md14: ios=1309172/1, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=327680/3, aggrmerge=0/0, aggrticks=19866/29, aggrin_queue=19871,
aggrutil=37.54%
  loop13: ios=331904/3, merge=0/0, ticks=21184/24, in_queue=21180, util=24.64%
  loop11: ios=330075/3, merge=0/0, ticks=32252/24, in_queue=32248, util=37.54%
  loop14: ios=327612/3, merge=0/0, ticks=3204/24, in_queue=3200, util=3.73%
  loop12: ios=321129/3, merge=0/0, ticks=22824/44, in_queue=22856, util=26.59%
