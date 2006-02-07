From: James Lamanna <jlamanna@gmail.com>
Subject: Problems making a RAID-0 over 2 gpt partitions...
Date: Mon, 6 Feb 2006 22:32:00 -0800
Message-ID: <aa4c40ff0602062232x6347c7e2lbe633f67e61eba27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently acquired a 7TB Xserve RAID. It is configured in hardware as
2 RAID 5 arrays of 3TB each.
Now I'm trying to configure a RAID 0 over these 2 drives (so RAID 50 in total).

I only wanted to make 1 large partition on each array, so I used
parted as follows:
parted /dev/sd[bc]
(parted) mklabel gpt
(parted) mkpart primary 0 3000600
(parted) set 1 raid on
(parted) q

for each of the disks.

Then I went to go make the RAID array:
mdadm -C -l 0 --raid-devices=2 /dev/md0 /dev/sdb1 /dev/sdc1

Everything seems ok at this point, /etc/mdstat lists the array as active..
I then wanted to put LVM on top of this for future expansion:

pvcreate /dev/md0
vgcreate imagery /dev/md0
lvcreate -l xxxxxxx -n image1 imagery (xxxxx is the number of PEs for
the whole disk, couldn't remember the number off the top of my head)

then a filesystem..
mkfs.xfs /dev/imagery/image1

Everything works fine up to this point until I reboot.
after reboot, the md array does not reassemble itself, and manually
doing it results in:
mdadm -A /dev/md0 /dev/sdb1 /dev/sdc1
/dev/sdb1: no RAID superblock

Kernel is 2.6.14
mdadm is 1.12.0

Did I miss a partitioning step here (or do something else sufficiently stupid)?

Thanks in advance, and please CC me for I am not subscribed.
-- James
