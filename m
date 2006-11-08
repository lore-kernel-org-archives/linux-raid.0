From: Robin Bowes <robin-lists@robinbowes.com>
Subject: new array not starting
Date: Wed, 08 Nov 2006 01:59:08 +0000
Message-ID: <eirdlc$l7j$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've just done an FC6 install on to a system with 2 x 250GB disks and 8
x 500GB disks. /dev/md0 is a 100MB mirror mounted as boot, and /dev/md1
is another mirror using the rest of the disks and is assigned to an LVM
PV/VG with LVs created for various system partitions.

After fun and games with grub (0.97 only supports up to 8 disks - I had
to patch grub to support up to 16 disks) I got the server to boot.

I then configured /dev/md2 as an 8 disk RAID6 array using the 8 x 500GB
disks using the whole of each disk for the array, i.e. no partitions.

This is the command I used to create the array:

mdadm --create /dev/md2 --raid-devices=8 --level=6 --auto=yes /dev/sdc
/dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj

When the array havd finished syncing, I rebooted the server.

However, /dev/md2 did not restart.

If I try to start the array manually:

# mdadm --assemble --auto=yes  /dev/md2 /dev/hdc /dev/hdd /dev/hde
/dev/hdf /dev/hdg /dev/hdh /dev/hdi /dev/hdj
mdadm: cannot open device /dev/hdc: No such file or directory
mdadm: /dev/hdc has no superblock - assembly aborted

What's going on here? No superblock? Doesn't that get written when the
array is created?

Am I doing this right?

Thanks,

R.

