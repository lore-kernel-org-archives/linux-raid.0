From: Karl Voit <neww@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data
Date: Mon, 10 Jul 2006 08:48:11 +0000 (UTC)
Message-ID: <loom.20060710T104325-971@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org> <62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich <at> gmail.com> writes:

> You should probably upgrade at some point, there's always a better
> chance that devels will look at your problem if you're running the
> version that they're sitting with..

OK, I upgraded my kernel and mdadm:

"uname -a":
Linux ned 2.6.13-grml #1 Tue Oct 4 18:24:46 CEST 2005 i686 GNU/Linux

"dpkg --list mdadm" --> "2.4.1-6"

Now I get slightly different messages. The problem seems to be
the superblocks. Can I repair them?

root@ned ~ # date;cat /proc/mdstat
Mon Jul 10 10:41:45 CEST 2006
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]\
 [raid6] [raid10]
unused devices: <none>
root@ned ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1\
 /dev/sdc1 /dev/sdd1
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has no superblock - assembly aborted
root@ned ~ # mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1\
 /dev/sdc1 /dev/sdd1 --force
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has no superblock - assembly aborted
root@ned ~ #

If I omit the sda1, the message is repeated but with the missing
superblock of sdb1.

