From: d tbsky <tbskyd@gmail.com>
Subject: data corruption after rebuid
Date: Thu, 14 May 2015 12:54:04 +0800
Message-ID: <CAC6SzHKo8kUOJoC+eaZU1mQCzW+WdB6ACRkrM30yUCA7CodLCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi:
     I think I did something wrong and cause mdadm data corruption.
but I am curious which steps brings me down. hope someone can told me
about it.

       I have two hosts forms a vm HA cluster. each one is a 2TB * 2
mdadm raid 1. I need to test something but lack of disks, so I pull
one disk of each hosts.  after testing, I put the disk back and let
mdadm rebuild. host B took several hours to rebuild and looks fine.
host A took only 5 min to rebuild. after completing rebuild, the
virtual machines stand  above the raid crashed one by one. since I
know I have write many data  bytes during the testing, host A should
not took only 5 min to recover. I must do something wrong to confuse
mdadm.  below is what I done:

1. I test a 3 disk mdadm raid 5: sda (hostA sdb), sdb (hostB sdb), sdc
(new disk). I wrote about 5G data for system restore testing.

2. then I test a 4 disk mdadm raid10: sda (hostA sdb), sdb(hostB
sdb),sdc(new disk),sdd (new disk). I wrote about 5G data for system
restore testing.

3. then I test again a  4 disk mdadm rai10, but wrote about 120G data
for system restore testing.

then I put back the disk to hostA and hostB (hot plugin, HOST A and B
are still running). at hostA I issue command blow:
   mdadm --stop /dev/md126; mdadm --stop /dev/md127 (the plugged disk
has raid data on it and udev seems found it)
   dd if=/dev/sda of=/dev/sdb bs=1k count=1000  (to recreate mbr
partition table).
   partprobe /dev/sdb
   mdadm --add /dev/md0 /dev/sdb1 (this is a small 500MB raid for /boot).
   mdadm --add /dev/md1 /dev/sdb2 (this is about 2TB raid).

   mdadm seems confused it only took 5 min to recover. I did the same
at host B and it took several hours to recover.

   so I did something wrong to confuse the mdadm superblock? should I
use "mdadm --zero-superblock /dev/sdb2" before I add it back to mdadm?

  thanks a lot for advice!!

Regards,
tbskyd
