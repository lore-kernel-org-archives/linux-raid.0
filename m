From: "Gernot A. Weber" <gernot@tux-web.de>
Subject: Re: Removing a Raid Partition? How-to?
Date: Wed, 15 May 2002 10:54:16 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0205151051560.23601-100000@kopernikus.tux-web.de>
References: <5.1.0.14.0.20020514171826.01f64070@205.233.215.4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.0.20020514171826.01f64070@205.233.215.4>
To: Jeff Hill <jhill@hronline.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

try a "dd if=/dev/zero of=/dev/sda" if your disk is the first SCSI disk.
Replace sda with the right devive name. Don't enter a partition number -
just the device name. dd should overwrite the MBR and the partition table.

Good luck

   Gernot Weber

-- 
Gernot A. Weber
http://www.tux-web.de

Only wimps use tape backup: _real_ men just upload their important stuff
on ftp, and let the rest of the world mirror it.

                              Linus Torvalds, after a hard drive crash

