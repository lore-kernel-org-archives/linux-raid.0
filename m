From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 0/6] Reduce the number of devices in RAID4/5/6
Date: Tue, 24 Mar 2009 19:53:31 +1100
Message-ID: <20090324084629.15383.10271.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is a set of patches I just finished that will be submitted for
2.6.30.
They make it possible to reduce the number of devices in a raid 4/5/6
array.

There is no support in mdadm for this yet so:
  a/ it has to be done by hand, writing to sysfs
  b/ there is no protection for the "critical section".
     So if you try this and your system crashes just before
     the reshape finishes, you lose data.

When reducing the number of device, you need to reduce the size of the
array first.  This can be done by writing to the "array_size"
attribute.
Alternately you can write the current size to the array_size
attribute, to pin it, then use "mdadm --grow --size=whatever" to use
more of the devices.  That is what the script below does.

When reducing the number of devices in an array, restriping starts at
the end of the devices and works towards the beginning.  When it gets
to the first few chunks it needs to over-write data that is currently
live.  This is perfectly safe unless the system crashes.  In that case
see the comment about "critical section" above.

The following script give some idea how to use this if you want to
experiment.  I kept and ext3 filesystem on md0 busy while this was
happening, and it fscked perfectly afterwards.

Note that the array starts degraded (I only have 5 test disks) and
ends degraded.  But then there are suddenly two spare devices, so it
start recovery straight away.

Comments or improvements, as always, very welcome.

NeilBrown

# test script for shrinking a raid5
# from 6 devices to 4
# don't worry about critical section
# make the devices larger first

mdadm -Ss
mdadm -CR /dev/md0 -l5 -n6 -z 2000000 missing /dev/sd[bcdef]
mdadm --wait /dev/md0
cat /proc/mdstat
echo 4 > /sys/block/md0/md/raid_disks
# freeze the array size at 5*2000000
echo 10000000 > /sys/block/md0/md/array_size
# make the individual devices bigger to 3333376
mdadm -G /dev/md0 --size 3333376
sleep 2
echo reshape > /sys/block/md0/md/sync_action
sleep 2
cat /proc/mdstat
mdadm --wait /dev/md0
echo default > /sys/block/md0/md/array_size
cat /proc/mdstat


---

NeilBrown (6):
      Documentation/md.txt update
      md: allow number of drives in raid5 to be reduced
      md/raid5: change reshape-progress measurement to cope with reshaping backwards.
      md: add explicit method to signal the end of a reshape.
      md/raid5: enhance raid5_size to work correctly with negative delta_disks
      md/raid5: drop qd_idx from r6_state


 Documentation/md.txt |   37 ++++++-
 drivers/md/md.c      |   11 +-
 drivers/md/md.h      |    2 
 drivers/md/raid5.c   |  259 ++++++++++++++++++++++++++++++++++----------------
 drivers/md/raid5.h   |   17 ++-
 5 files changed, 219 insertions(+), 107 deletions(-)


