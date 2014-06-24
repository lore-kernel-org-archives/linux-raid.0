From: Francis Moreau <francis.moro@gmail.com>
Subject: /sys/block/md126 still exists even after stopping the array
Date: Tue, 24 Jun 2014 17:38:30 +0200
Message-ID: <53A99B76.3020603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I'm having the folloing behaviour with kernel 3.14.5 and mdadm v3.3.1.

After stopping all arrays, I still can see one of them in /sys/block/:

# cat /proc/mdstat
Personalities : [raid1]
md125 : active raid1 sdb3[1] sda3[0]
      483688448 blocks super 1.2 [2/2] [UU]
      [======>..............]  resync = 34.9% (169161280/483688448)
finish=44.0min speed=118852K/sec
      bitmap: 3/4 pages [12KB], 65536KB chunk

md126 : active raid1 sdb2[1] sda2[0]
      4038656 blocks super 1.2 [2/2] [UU]

md127 : active raid1 sdb1[1] sda1[0]
      524224 blocks super 1.0 [2/2] [UU]

unused devices: <none>

# mdadm --stop /dev/md12[567]
mdadm: stopped /dev/md125
mdadm: stopped /dev/md126
mdadm: stopped /dev/md127

# cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>

# ls /sys/block/
md126  sda  sdb  sdc  sr0

# ls /sys/block/md126/md/
array_size  array_state  bitmap  chunk_size  component_size  layout
level  max_read_errors  metadata_version  new_dev  raid_disks
reshape_direction  reshape_position  resync_start  safe_mode_delay

# dmesg
....
[ 1573.715476] md125: detected capacity change from 495296970752 to 0
[ 1573.715626] md: md125 stopped.
[ 1573.715633] md: unbind<sdb3>
[ 1573.740681] md: export_rdev(sdb3)
[ 1573.740694] md: unbind<sda3>
[ 1573.754008] md: export_rdev(sda3)
[ 1573.773398] md126: detected capacity change from 4135583744 to 0
[ 1573.773403] md: md126 stopped.
[ 1573.773410] md: unbind<sdb2>
[ 1573.820652] md: export_rdev(sdb2)
[ 1573.820664] md: unbind<sda2>
[ 1573.873974] md: export_rdev(sda2)
[ 1573.889904] md127: detected capacity change from 536805376 to 0
[ 1573.889910] md: md127 stopped.
[ 1573.889917] md: unbind<sdb1>
[ 1573.913978] md: export_rdev(sdb1)
[ 1573.914033] md: unbind<sda1>
[ 1573.940627] md: export_rdev(sda1)

After waiting a couple of min, stopping again md126 worked:

[ 1835.755661] md: md126 stopped.

Is this expected ?

Thanks.
