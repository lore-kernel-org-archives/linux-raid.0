From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Sun, 16 Apr 2006 23:19:43 +0200
Message-ID: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A system with 6 disks, it was UUUUUU a moment ago, after read errors
on a file now looks like:

/proc/mdstat:
  md1 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[6](F) sda1[7](F)
      level 5, 64k chunk, algorithm 2 [6/4] [__UUUU]

uname:
  linux 2.6.11-gentoo-r4

What's the recommended approach?

Compile 2.6.16.5 and mdadm 2.4.1, install both, reboot, then use mdadm
assemble --force (after automatic mount probably fails)?
