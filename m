From: "Rami Addady" <rami@tase.co.il>
Subject: Replacing fail boot disk from md raid1 set
Date: Sun, 1 Feb 2004 15:31:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00c101c3e8c7$c79eb9b0$0e64630a@rami>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Replacing fail boot disk from md raid1 set

One of my disk fail and I replace it with new one.
I fail to make the new disk bootable.
Right now the system is boot only from IDE2 master (hdc1)
Here are the steps I made, it use to work on previous occurrence:

- fdisk the new disk
-Adding all the partition to the raid array
  /sbin/raidhotadd /dev/mdX /dev/hdaY...
- Reboot from a Linux CD-ROM in rescue mode.
- mkdir /mnt/hda_disk_par1
- Mount the / partition
  mount /dev/hda1 /mnt/hda_disk_par1
- Replace md1 with hda1 in /etc/lilo.conf
- chroot /mnt/hda_disk_par1 /sbin/lilo
- Replace hda1 with md1 in /etc/lilo.conf
- halt
- disconnect hdc
- boot

At this stage the system not boot. I can boot it only in one of those
senarios:
 From boot diskette or connecting again hdc.

After boot the raid status of all the partition is  [UU] (up)

The configuration:
-Red Hat 8.0
-Two IDE disk both master on IDE1 (hda) and IDE2 (hdc)
-My bios is capable to boot from IDE1 or IDE2 master
-lilo boot loader
-My bios is capable to boot from IDE1 or IDE2 master

Any Idea what wrong?

Regards,
Addady

