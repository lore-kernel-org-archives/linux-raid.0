From: buliwyf <buliwyf@gmx.de>
Subject: Extend raid 5
Date: Mon, 12 Jan 2004 01:11:55 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1704458665.20040112011155@gmx.de>
Reply-To: =?ISO-8859-15?B?QnVsfHf9Zg==?= <buliwyf@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I have the following problem.
I have set up a Linux Software Raid 5 with 4 160GB Disks.
This works well. Now i run out of Disk Space and want to add another
160 GB Disk on the fly. Is this possible without loosing Data?
my /etc/raidtab

raiddev /dev/md0
        raid-level      5
        nr-raid-disks   4
        nr-spare-disks  0
        persistent-superblock 1
        parity-algorithm        left-symmetric
        chunk-size      32
        device          /dev/hdi1
        raid-disk       0
        device          /dev/hdj1
        raid-disk       1
        device          /dev/hdk1
        raid-disk       2
        device          /dev/hdl1
        raid-disk       3

My system is a Debian/gnu Linux Woody Box.
Installed is Raidtools2 and mdadm.
I tried the raidreconf tool but always got an error message.
Has anybody the same problem yet and has solved it, or can tell me
a solution?

cYa
Dominik Sennfelder



