From: "Kent Wang" <kwang@kwang.org>
Subject: Bootable RAID-5 array dead!
Date: Tue, 4 May 2004 22:45:51 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003801c43253$78fc1fc0$6500a8c0@eclipse>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The heart of my system is an Abit KT7A-RAID motherboard, it has 2
additional IDE headers. I have 4 PCI RocketRaid 100 IDE controllers
attached. Each of those controllers has 2 IDE headers. Attached to all
those IDE headers are the following:

2x 60GB Maxtor
4x 120GB WD
5x 120GB Seagate

For almost a year, I've had RedHat 7.2 running a RAID-5 array of 9x
120GB drives. "/" is located on the RAID array and /boot is on one of
the 60GB Maxtors.

One day, after about 25 days uptime, the system stopped responding to
network requests and though I could still move the mouse around, the
whole system was essentially frozen. So, I rebooted. When I did, it
spewed some stuff indicating that the RAID array was damaged and that
it would attempt a recovery. HDD indicator LEDs flashed for half a
day. When I came back, the screen was blank and the HDD activity LED
was stuck on. I waited a whole day before I decided to reboot it
again. Similar results: attempt recovery, disk activity, then freeze.
After the third or fourth attempt at this, it now boots up with a
kernel panic. I can't read all the error messages, but right after
loading the IDE controller drivers and right before it kernel panics,
it spews out a listing of all the drives and then says that the md0
array cannot be loaded.

What should I do at this point? I have most of my data backed up, but
I hate to have to reconfigure a new server from scratch.

Thanks,
Kent Wang
IC2 Institute


