From: danci@agenda.si
Subject: Fast RAID rebuild?
Date: Tue, 22 Jul 2003 13:49:15 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0307221333120.21063@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have a 3 disk RAID-5 array with one spare disk on two IDE controller. As
I'm experimenting with kernel and drivers, sometimes my kernel doesn't
detect one of the controllers and therefore marks one of the RAID disks as
faulty. The RAID-5 is my root fs...

Next time I boot the kernel with all disks detected, RAID starts
rebuilding which takes a long time - pretty unconvenient for testing...

Is there a way to quickly add the disk back to array without resyncing
- something like 'mdadm --unfail'? :)


  D.

