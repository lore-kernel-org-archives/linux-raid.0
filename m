From: Ole Tange <tange@binf.ku.dk>
Subject: Linux mdadm --grow RAID6: Something wrong - reshape aborted
Date: Thu, 2 May 2013 13:56:09 +0200
Message-ID: <CANU9nT=_7HYg14sR57qffH1B8KXUoRyghQC8P1oz2KxRbZr1jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID60 that I want to expand.

The current setup is: 2 axles each having 9 disks + 2 spares.

The future wanted setup is: 4 axles each having 10 disks + 1 spare.

So I need to do some --grow to reshape the drives.

I thought this would be enough:

  mdadm -v --grow /dev/md1 --raid-devices=10 --backup-file=/root/back-md1
  mdadm -v --grow /dev/md2 --raid-devices=10 --backup-file=/root/back-md2
  mdadm -v --grow /dev/md0 --raid-devices=4 --add /dev/md3 /dev/md4

The last command works, but the 2 first commands fail with:

  mdadm: Need to backup 7168K of critical section..
  mdadm: /dev/md2: Something wrong - reshape aborted

How can I --grow a RAID6 to use more devices?

Info about the system:

  $ mdadm --version
  mdadm - v3.2.5 - 18th May 2012
  $ uname -r
  3.5.0-17-generic

This URL includes a Makefile to reproduce the problem:
http://serverfault.com/questions/503832/linux-mdadm-grow-raid6-something-wrong-reshape-aborted


/Ole
