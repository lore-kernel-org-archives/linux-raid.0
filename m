From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: array doesn't run even with --force
Date: Sun, 20 Jan 2008 20:52:24 -0200
Message-ID: <18323.53416.900135.357320@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a raid5 array with 5 disks where 2 failed. The failures are
occasional and only on a few sectors so I tried to assemble it with 4
disks anyway:

# mdadm -A -f -R /dev/md<number> /dev/disk1 /dev/disk2 /dev/disk3 /dev/disk4

However mdadm complains that one of the disks has an out-of-date
superblock and kicks it out, and then it cannot run the array with
only 3 disks.

Shouldn't it adjust the superblock and assemble-run it anyway? That's
what -f is for, no? This is with kernel 2.6.22.16 and mdadm 2.6.4.
