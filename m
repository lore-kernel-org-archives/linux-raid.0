From: Louis-David Mitterrand <vindex@apartia.org>
Subject: strange lilo error
Date: Tue, 15 Jun 2004 09:39:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040615073953.GA25753@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I am trying to convert a raid1 partition from reiserfs to ext3 by
setting one drive faulty, removing it, creating a new degraded raid1
set, copying data from the reiserfs partition to the ext3 one.

Here is the /proc/mdstat output before starting the conversion:

Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
md1 : active raid1 hdb2[0] hda2[1]
      313152 blocks [2/2] [UU]

md0 : active raid1 hdb1[2] hda1[1]
      77834816 blocks [2/2] [UU]

Once /dev/hdb1 and /dev/hdb2 have been marked faulty and removed lilo
will fail with the following message:

Fatal: Trying to map files from unnamed device 0x0000 (NFS/RAID mirror down ?)

The lilo.conf has:

# boot=/dev/md0
boot=/dev/hda
root=/dev/md0
# raid-extra-boot=mbr
compact
install=/boot/boot-menu.b
map=/boot/map
delay=20
vga=normal
default=Linux
image=/vmlinuz
    label=Linux
    read-only
image= /boot/vmlinuz-2.4.22-madrid
    label=Linux-2.4.22
    read-only

I commented out "raid-extra-boot" and replaced "boot=/dev/md0" with
"boot=/dev/hda" but the error persists.

After running a few tests it appears lilo will only stop complaining
once the original raid1 set is restored _and_ synchronized.

This the first time we have this kind of error, having done the same
conversion on other machines. This is with debian unstable and a 2.6.6
kernel.

Any idea? Thanks in advance,


-- 
In linux-dominated parallel world, all children's names begin with g, k or x
