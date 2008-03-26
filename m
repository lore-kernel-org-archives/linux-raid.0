From: akb+lists.linux-raid@mirror.to (Andrew K. Bressen)
Subject: raid, lvm, and reused disks crashing initramfs
Date: Wed, 26 Mar 2008 06:13:22 -0400
Message-ID: <0q3aqd3i9p.fsf@lanconius.mirror.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi--

I have a linux system running a pair of raid-1 drives, hda and hdc,
off of the motherboard IDE controller. 

Almost all the space on the disks is in md1. 
(There's a tiny md0 from an old configuration, the system used
to boot off of it, but now it's empty and doesn't get mounted).

On top of md1 is lvm, a single PV (horivg) 
with a bunch of logical volumes in it.

About a year ago, I replaced hda with a newer drive. 

Recently, wanting more disk space, I took the old hda and added
it back to the machine as hdc. I repartitioned, put lvm on it, 
creating a sigle PV (hori2vg) with two LVs in it. I copied files
onto it and such, and all was well. Until a power outage and reboot.

Then, the system crashed into initramfs. Exploring, it became
evident that initramfs was trying to mount the old disk
as root. This behavior occurred if the old disk was hdc or hdd. 

Remove the disk, system boots normally.

(Except that X11 no longer works. But I'm just going to choose
to believe that that's unrelated, even though I didn't change anything,
and even though that also occurred when the system was hosed a year 
ago by being booted with hda and hdc reversed.)

The system is an athlon running debian etch; 
kernel 2.6.22 (debian 2.6.22-3-k7 build).

I'd like to put that disk back in and have my system work. 

Any ideas about what's going on and how to fix it?

  --thanks for any clues
  --a k bressen

