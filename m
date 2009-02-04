From: "michael" <michael@estone.ca>
Subject: How to start SW raid later in boot?
Date: Wed, 4 Feb 2009 11:39:41 -0800
Message-ID: <20090204193039.M36676@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I have a SW raid md0(raid5) setup with a 10 disks.
/dev/sdb --> /dev/sdk

Some are plugged into motherboard, and some into a pci raid card
using the rr232x raid driver.

/dev/md0 assembes just fine except upon a reboot. I'm "guessing" the raid
driver rr232 is loaded after mdadm tries to assemble md0 and therefore
doesn't fully assemble because the system can't see the pci plugged in 
drives. dmesg seems to have this order.

Is there a way to delay the mdadm assemble until after the driver is loaded?
The / system is on single disk /dev/sda.


Thanks!

Mike
