From: mattyml@bellsouth.net
Subject: Persisting hotspare configuration
Date: Sun, 28 Dec 2003 14:13:11 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0312281358001.20976@winnie.matty.com>
Reply-To: mattyml@bellsouth.net
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Software RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Howdy,

I followed the directions in the FAQ, and mirrored "/" and swap on one
of my machines. I am attempting to add a hotspare drive for these raid
devices, and did the following:

1) Update /etc/raidtab

raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
persistent-superblock       1
nr-spare-disks              1
    device          /dev/hda2
    raid-disk     0
    device          /dev/hdc2
    raid-disk     1
    device          /dev/hde1
    spare-disk    0

2) Add the hotspare to the device
$ raidhotadd /dev/md1 /dev/hde1

This works fine, but the configuration (from "cat /proc/mdstat")
disappears after a reboot. I suspect that the configuration isn't
getting written to the persistent-superblock? I looked through
the "man -k raid" manpages, the FAQ, and various messages in the archives,
but can't seem to figure out why the hotspare isn't visible when the box
reboots? Is there an easy way to print the configuration that resides
within the persistent-superblock?

Thanks,
- Ryan
