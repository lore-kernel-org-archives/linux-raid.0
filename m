From: Francis Moreau <francis.moro@gmail.com>
Subject: Weirdness with DDF arrays (mdadm 3.3)
Date: Thu, 12 Sep 2013 12:02:50 +0200
Message-ID: <CAC9WiBgJX4VH7-cNMVcqPL-9UpsH03Z7cRKvLUOSUogkiQpx7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Still testing MD arrays using DDF metadata and find another possible issues :)

I'm creating a new DDF array containing 2 disks. After that
/proc/mdstat looks correct:

# cat /proc/mdstat
Personalities : [raid1]
md124 : active raid1 loop0[1] loop1[0]
      84416 blocks super external:/md125/0 [2/2] [UU]

md125 : inactive loop1[1](S) loop0[0](S)
      65536 blocks super external:ddf

Now I'm stopping the array and restart it by incrementaly adding the 2 disks:
# mdadm --stop /dev/md124
# mdadm --stop /dev/md125
# mdadm -IRs /dev/loop0
# mdadm -IRs /dev/loop1
# cat /proc/mdstat
Personalities : [raid1]
md124 : active (auto-read-only) raid1 loop1[2] loop0[0]
      84416 blocks super external:/md125/0 [2/1] [_U]

md125 : inactive loop1[1](S) loop0[0](S)
      65536 blocks super external:ddf

Parsing mdstat content tells me disk "loop1" have a role number equal
to 2 which is greater than 1 indicating that "loop1" is a spare disk
and the "[_U]" below indicates "loop1" is down".

Why is "loop1" down now ?

I decided to still use the md device by creating a new partition on it:
# fdisk /dev/md124
...
Calling ioctl() to re-read partition table.
Syncing disks.

Now inspecting /proc/mdstat:

# cat /proc/mdstat
Personalities : [raid1]
md124 : active raid1 loop1[2] loop0[0]
      84416 blocks super external:/md125/0 [2/2] [UU]

md125 : inactive loop1[1](S) loop0[0](S)
      65536 blocks super external:ddf

which looks even weirder: "loop1[2]" indicates that the disk is a
spare one whereas "[UU]" tells me the opposite.

Could you tell me if I'm wrong in my interpretation or what's going wrong ?

Thanks
-- 
Francis
