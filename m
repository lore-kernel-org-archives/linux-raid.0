From: "Sean Hildebrand" <silverwraithii@gmail.com>
Subject: Crash while increasing RAID5 from 3 disks to 5, array won't build.
Date: Wed, 3 Dec 2008 10:43:15 -0500
Message-ID: <fa037c550812030743i70236951g964b444163425d39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

blkid reports that all five disks have the same UUID.

Specifying disks by UUID results in "mdadm: no devices found for /dev/md0".

Specifying disks based on their positions, /dev/sd[abcef]1 in this
case, results in "mdadm: superblock on /dev/sda1 doesn't match others
- assembly aborted" and it'll continue doing that with [bcef]1 if a is
removed.

mdadm --detail --scan outputs nothing.

I've tried assembling the original three disks sans the two new ones
to no avail.
