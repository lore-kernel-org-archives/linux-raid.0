From: Dusty Mabe <dustymabe@gmail.com>
Subject: 0.90 vs 1.X - Differing behavior for device # during fail/remove/add operation
Date: Wed, 8 May 2013 13:39:24 -0400
Message-ID: <CAFfJ-R58bqNKL+Q1Htp=KDzARi1GLamW9B7idFjnL+h6tYArkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Dusty Mabe <dustymabe@gmail.com>
List-Id: linux-raid.ids

CentOS 6.3
2.6.32-279.19.1
mdadm-3.2.3-9.el6.x86_64


I have noticed that the device number printed in the mdstat file gets
changed if you fail->remove->add a member device of a 1.X metadata
array, but for a 0.90 metadata array the device will go back to the
original value once recovery has finished.

This means after recovery has finished I end up with the following
outputs for 1.1 and 0.90 metadata:

1.1 METADATA /proc/mdstat (trimmed)
md50 : active raid1 loop0[2] loop1[1]
      32760 blocks super 1.1 [2/2] [UU]

1.1 METADATA mdadm --detail (trimmed)
    Number   Major   Minor   RaidDevice State
       2       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1

0.90 METADATA /proc/mdstat (trimmed)
md50 : active raid1 loop0[0] loop1[1]
      32704 blocks [2/2] [UU]

0.90 METADATA mdadm --detail (trimmed)
    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1



Is this by design? I know 1.X version of metadata use dev_roles rather
than this_disk and the mdp_disk_t structure so maybe it is by design?



A simple re-creator is below if you want to see it in action Please
analyze it first to make sure my assumptions are valid in your case.
Change --meta from 1.1 to 0.90 to see it for the other metadata.

# Create two sparse disk image files
dd if=/dev/zero of=/tmp/disk1.img bs=1 count=0 seek=32M
dd if=/dev/zero of=/tmp/disk2.img bs=1 count=0 seek=32M

# Set them up as loopback devices
losetup -f /tmp/disk1.img
losetup -f /tmp/disk2.img

# Create a raid 1 out of them
mdadm --create /dev/md50 --level=1 --raid-devices=2 --meta=1.1
/dev/loop0 /dev/loop1

# Fail/remove/zero-superblock/add device back to array
mdadm --fail /dev/md50 /dev/loop0
sleep 1
mdadm --remove /dev/md50 /dev/loop0
sleep 1
mdadm --zero-superblock /dev/loop0
sleep 1
mdadm --add /dev/md50 /dev/loop0
cat /proc/mdstat | grep -A 2 md50
sleep 10
cat /proc/mdstat | grep -A 2 md50

# Clean up
mdadm --stop /dev/md50
losetup -d /dev/loop0
losetup -d /dev/loop1
rm -f /tmp/disk1.img
rm -f /tmp/disk2.img


Thanks for any input!

Dusty
