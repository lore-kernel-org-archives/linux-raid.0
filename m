From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: Should I Start Over?
Date: Wed, 30 Jun 2004 08:46:02 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1147.66.230.1.97.1088603162.squirrel@exitwound.org>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having no luck with this problem.  If this is not the correct place to
seek assistance or if there is some other place I should ask, I would
appreciate it someone could point me in the right direction.

About a month ago, my system crashed.  When it booted, the raid array
would not start.  The system is seeing all of the drives, but can't find
/dev/md0.  I've got about 80Gb of data on the array which can be recovered
in time, but if I can rebuild the array without losing the data, that
would rock.

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

I don't know where to turn from here.  This is my first real experience
with Linux and raid devices.  If someone could help, I'd really appreciate
it.

Thanks.

--
Steve
