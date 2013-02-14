From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Thu, 14 Feb 2013 22:39:08 +0100
Message-ID: <20130214213908.282850@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I heart that -force could be result in more problems - right? i do asswell:
 mdadm -Af -vv /dev/md2
mdadm: looking for devices for /dev/md2
mdadm: cannot open device /dev/md/1: Device or resource busy
mdadm: /dev/md/1 has wrong uuid.
mdadm: cannot open device /dev/md/0: Device or resource busy
mdadm: /dev/md/0 has wrong uuid.
mdadm: /dev/sdf4 has wrong uuid.
mdadm: cannot open device /dev/sdf3: Device or resource busy
mdadm: /dev/sdf3 has wrong uuid.
mdadm: cannot open device /dev/sdf2: Device or resource busy
mdadm: /dev/sdf2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdf1
mdadm: /dev/sdf1 has wrong uuid.
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: /dev/sdf has wrong uuid.
mdadm: /dev/sde4 has wrong uuid.
mdadm: cannot open device /dev/sde3: Device or resource busy
mdadm: /dev/sde3 has wrong uuid.
mdadm: cannot open device /dev/sde2: Device or resource busy
mdadm: /dev/sde2 has wrong uuid.
mdadm: no RAID superblock on /dev/sde1
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has wrong uuid.
mdadm: /dev/sdc4 has wrong uuid.
mdadm: cannot open device /dev/sdc3: Device or resource busy
mdadm: /dev/sdc3 has wrong uuid.
mdadm: cannot open device /dev/sdc2: Device or resource busy
mdadm: /dev/sdc2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc1
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdd4 has wrong uuid.
mdadm: cannot open device /dev/sdd3: Device or resource busy
mdadm: /dev/sdd3 has wrong uuid.
mdadm: cannot open device /dev/sdd2: Device or resource busy
mdadm: /dev/sdd2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdd1
mdadm: /dev/sdd1 has wrong uuid.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdb4 has wrong uuid.
mdadm: cannot open device /dev/sdb3: Device or resource busy
mdadm: /dev/sdb3 has wrong uuid.
mdadm: cannot open device /dev/sdb2: Device or resource busy
mdadm: /dev/sdb2 has wrong uuid.
mdadm: no RAID superblock on /dev/sdb1
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sda4 has wrong uuid.
mdadm: cannot open device /dev/sda3: Device or resource busy
mdadm: /dev/sda3 has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: no RAID superblock on /dev/sda1
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.

it looks strang die device should sdX4...
