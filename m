From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: Power Outage and Recovery
Date: Thu, 17 Jun 2004 11:42:34 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1273.66.230.1.97.1087490554.squirrel@exitwound.org>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm running a raid-5 setup at the house.  Earlier today, an electrical
storm caused a power outage and my system went down.  When I got home, I
booted the system and it complained bitterly about ReiserFS when trying to
mount my raid array.  It dropped me to root prompt and advised me to run
fsck.  I hit ctl-D and let the boot cycle complete.

dmesg shows the following:

sh-2006: reiserfs read_super_block: bread failed (dev 09:00, block 8, size
1024)
sh-2006: reiserfs read_super_block: bread failed (dev 09:00, block 64,
size 1024)
sh-2021: reiserfs_read_super: can not find reiserfs on md(9,0)

The above is repeated 3 more times.  dmesg does see the four drives that
should compose /dev/md0 (hde is a spare):

# dmesg | grep hd
...
hdc: Maxtor 6Y120P0, ATA DISK drive
hdd: Maxtor 6Y120P0, ATA DISK drive
hde: Maxtor 6Y120P0, ATA DISK drive
hdg: Maxtor 6Y120P0, ATA DISK drive
...

# cat /proc/mdstat:

Personalities : [raid5]
read_ahead not set
unused devices: <none>

# cat /etc/mdadm/mdadm.conf
DEVICE /dev/hd*
ARRAY /dev/md0 level=raid5 num-devices=3
UUID=fef44719:ddd66a49:0a337b48:b53e14c0
   devices=/dev/hdg1,/dev/hdd1,/dev/hdc1

# mdadmin --assemble --scan
mdadm: no devices found for /dev/md0

# cat /proc/partitions
major minor  #blocks  name

  34     0  120060864 hdg
  34     1  120060832 hdg1
  33     0  120060864 hde
  33     1  120060832 hde1
  22     0  120060864 hdc
  22     1  120060832 hdc1
  22    64  120060864 hdd
  22    65  120060832 hdd1
   3     0   39062500 hda
   3     1      40131 hda1
   3     2     996030 hda2
   3     3    4883760 hda3
   3     4          1 hda4
   3     5    9767488 hda5
   3     6    1461883 hda6
   3     7   21912628 hda7


# mdadm -E /dev/hd[gedc]1
mdadm: No super block found on /dev/hdc1 (Expected magic a92b4efc, got
00000000)
mdadm: No super block found on /dev/hdd1 (Expected magic a92b4efc, got
00000000)
mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got
00000000)
mdadm: No super block found on /dev/hdg1 (Expected magic a92b4efc, got
00000000)

How should I proceed in order to recover my array?

If I've left out anything important, just let me know and I'll be glad to
supply it.

Thanks for any advice you guys have.  I do appreciate it.

--
Steve
---------------------------------------------------------
http://stephenhargrove.com ... thoughts on stuff
http://exitwound.org ......... a gaping hole of intellect
http://buckowensfan.com ...... he's the man
---------------------------------------------------------
Pardo's First Postulate: Anything good in life is
either illegal, immoral, or fattening. Arnold's
Addendum: Everything else causes cancer in rats.
---------------------------------------------------------

