From: Seth Hall <seth@speech.mit.edu>
Subject: Promise SX6000 problems.
Date: Mon, 03 Feb 2003 18:10:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E3EF6E3.CBA898DC@speech.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Has anyone had better success with this card than we have? To wit:

------------------------------------------------------------------------
I am still struggling with trying to get our new SuperTrac SX6000 to work
properly with any version of Linux. I have not had any success since we received
the card in late December. 

Most recently I have been trying to get the Promise Driver V1.02.0.22
[06/27/2002] driver to work on a fresh distribution of RedHat v7.3, kernel
2.4.18-3 installation described in the Readme seemed to succeed, but the ft.o
driver refuses to load, with insmod giving the following error message:

#root_> insmod /lib/modules/2.4.18-3/kernel/drivers/scsi/ft.o
Warning: loading /lib/modules/2.4.18-3/kernel/drivers/scsi/ft.o
will taint the kernel: no license

/lib/modules/2.4.18-3/kernel/drivers/scsi/ft.o: init_module: operation not
permitted
Hint: insmod errors can be caused by incorrect module parameters, including
invalid IO or IRQ parameters


No SCSI devices are created and lsmod confirms that the ft.o module was not
loaded.


The system in question is a brand new:

Dell Optiplex GX260, 1GB RAM, Gigabit ethernet (Intel e1000), 60GB Ultra ATA
drive, Radeon graphics controller.

The Promise RAID is configuer as follows:

Promise SX6000 with 5 Seagate 120GB drives installed and configured as a 480GB
RAID-5 device (BIOS state reported: Functional.)


FastTrak Series Linux Driver 
Version 1.02.0.22 [06/27/2002]
For RedHat Linux 7.3 (kernel 2.4.18-3)

The SX6000 works perfectly under W2K. I then deleted this test RAID-5 set. A new
RAID-5 set was created and initialized for Linux following verification of the
hardware using W2K.

Incidentally, I also tried to use the new Open Linux driver you offer, using a
driver Makefile Jordan Rhody sent me on December 18, 2002, with no success. The
Makefile supplied built correctly under Slackware v8.1 (kernel v2.4.20) After
booting, the sca device could not be found. I reverted to RH 7.3 since this is
the release you claim to support.

Help!?

Seth Hall
Speech Comm. Group
MIT - Cambridge
