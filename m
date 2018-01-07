From: Kevin Lyda <kevin@ie.suberic.net>
Subject: Adding a USB device to a SATA-only array
Date: Sun, 7 Jan 2018 10:58:55 +0000
Message-ID: <CADJ56BScVkAwUVkenQL+e5AeXskjWjB35gdfzTqks5-anLpesg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tl;dr: what's the status of mixed usb/sata arrays? There used to be
data corruption along with "bio too big device mdX (248 > 240)" errors
in logs.

I have a few file servers that lack hot-pluggable SATA. They do
however have USB ports. When a drive failure happens (I have two
RAID1s with two disks each) I currently do the following:

1. Remove the broken partition(s) from mdadm --manage $RAID --fail
$BADPART ; mdadm --manage $RAID --remove $BADPART (repeat if multiple
disks/partitions are bad)
2. I then power down the machine and physically replace the broken drives.
3. Copy the partition structure from the remaining good disk to the
new disk and reset UUIDs on the new disk. The new disk can now be
referred to as $BADPART
4. Add the new disk back to the array: mdadm --manage $RAID --add $BADPART
5. Wait several hours.

Particularly when the deceased disk is the boot disk, /dev/sda, I'd
really like to do this instead:

1. Add new disk via a USB caddy and copy the partition structure from
the remaining good disk to the new disk and reset UUIDs on the new
disk. Copy non-raid partitions and boot block.
2. Add it to the array.
3. Wait for it to sync.
4. Remove the broken partition(s) from mdadm.
5. Power down, swap in new disks, reboot to fixed machine.

The nice part about the second scenario is that I could script stages
1 through 4 so that they could happen when the system detects a
defective disk. I could keep a few disks attached in a sleep state via
USB and by the time I'm alerted to a disk being down the spare would
have been brought online (albeit via the slower USB) and all I'd have
to do is physically swap them.

This scenario sounds great, but last I knew mixing SATA and USB
connected disks would lead to data corruption. But I last looked
around 2010 or so. Is this still true? If not, what version of the
kernel / mdadm tools did it get fixed in. I skimmed the changelogs and
commits and didn't see any mentions that it had been.

Kevin

-- 
Kevin Lyda
Galway, Ireland
