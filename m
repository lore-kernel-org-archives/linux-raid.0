From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: Power Outage and Recovery
Date: Thu, 3 Jun 2004 14:49:21 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1925.66.230.1.56.1086292161.squirrel@exitwound.org>
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

Do I need to run reiserfsck on each of the four drives?  How should I
proceed in order to recover my array?

If I've left out anything important, just let me know and I'll be glad to
supply it.

Thanks for any advice you guys have.  I do appreciate it.

--
Steve
