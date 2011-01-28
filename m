From: Janek Kozicki <janek_listy@wp.pl>
Subject: sub-array kicked out of raid6 on each reboot.
Date: Fri, 28 Jan 2011 21:15:34 +0100
Message-ID: <20110128211534.697017aa@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My configuration is following: raid6= 2TB + 2TB + raid5(4*500GB+missing) + missing.

This can be hardly called a redundancy, this is due to problems with
SATA controllers. I have third 2TB and two 500GB discs just waiting
to be plugged in, but currently I can't - my current controllers don't
work with them well (I am looking for controllers that will
communicate with them well, currently I will RMA Sil3114, which I
bought today).

A similar configuration was previously working good:
  raid6 = 2TB + 2TB + raid6(5*500GB+missing) + missing.

But one of those 500GB discs in raid6 above had problems
communicating with SATA controllers and I decided to remove it. Also
I decided to switch this sub-array from raid6 to radi5. In the end it
was easiest to recreate this array as raid5, with the problematic
disc removed.

And then the problems started happening.

I created that raid5(4*500GB+missing) sub-array. Added it to BIG
raid6 array, it took 2 days to resync.

Then after reboot - to my surprise the sub-array was kicked out of BIG raid6.

And now, after each reboot I must do following:
   (The sub-array is /dev/md6, and BIG array is /dev/md69)

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md6 : inactive sdg1[0](S) sdc1[5](S) sde1[3](S) sdh1[2](S) sda1[1](S)
      2441914885 blocks super 1.1

md69 : active raid6 sdd3[0] sdf3[1]
      3901977088 blocks super 1.1 level 6, 128k chunk, algorithm 2 [4/2] [UU__]
      bitmap: 15/15 pages [60KB], 65536KB chunk

md0 : active raid1 sdf1[6] sdb1[8] sdd1[9]
      979924 blocks super 1.0 [6/3] [UU___U]

md2 : active (auto-read-only) raid1 sdb2[8]
      4000176 blocks super 1.0 [6/1] [_____U]
      bitmap: 6/8 pages [24KB], 256KB chunk

unused devices: <none>

# mdadm --run /dev/md6
mdadm: started /dev/md6

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md6 : active (auto-read-only) raid5 sdg1[0] sdc1[5] sde1[3] sda1[1]
      1953530880 blocks super 1.1 level 5, 128k chunk, algorithm 2 [5/4] [UU_UU]
      bitmap: 4/4 pages [16KB], 65536KB chunk

md69 : active raid6 sdd3[0] sdf3[1]
      3901977088 blocks super 1.1 level 6, 128k chunk, algorithm 2 [4/2] [UU__]
      bitmap: 15/15 pages [60KB], 65536KB chunk

md0 : active raid1 sdf1[6] sdb1[8] sdd1[9]
      979924 blocks super 1.0 [6/3] [UU___U]

md2 : active (auto-read-only) raid1 sdb2[8]
      4000176 blocks super 1.0 [6/1] [_____U]
      bitmap: 6/8 pages [24KB], 256KB chunk


# mdadm --add /dev/md69 /dev/md6
mdadm: re-added /dev/md6

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md6 : active raid5 sdg1[0] sdc1[5] sde1[3] sda1[1]
      1953530880 blocks super 1.1 level 5, 128k chunk, algorithm 2 [5/4] [UU_UU]
      bitmap: 4/4 pages [16KB], 65536KB chunk

md69 : active raid6 md6[4] sdd3[0] sdf3[1]
      3901977088 blocks super 1.1 level 6, 128k chunk, algorithm 2 [4/2] [UU__]
      [>....................]  recovery =  0.0% (75776/1950988544) finish=1716.0min speed=18944K/sec
      bitmap: 15/15 pages [60KB], 65536KB chunk

md0 : active raid1 sdf1[6] sdb1[8] sdd1[9]
      979924 blocks super 1.0 [6/3] [UU___U]

md2 : active (auto-read-only) raid1 sdb2[8]
      4000176 blocks super 1.0 [6/1] [_____U]
      bitmap: 6/8 pages [24KB], 256KB chunk


It kind of defeats my last point of redundancy - having to
re-add /dev/md6 upon each reboot. This dangerous situation
shouldn't last longer than a week or two, I hope, until I get a
working SATA controller and attach remaining drives. But If you could
help me here, I would be grateful.

Is it possible that the order in which the arrays were created,
matters? Because when it worked I created the sub-array first, and
then I created the BIG array. And currently the sub-array is created
after the BIG one.

best regards
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
