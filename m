From: linuxraid@valli.org
Subject: Can't boot from Adaptec 2010s
Date: Tue, 13 Jan 2004 08:41:44 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <34861.194.153.178.110.1073979704.squirrel@mail.valli.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,
I successfully installed my linux (Debian with a 2.4.24 vanilla kernel)
on my Fujitsu Siemens Primergy TX200 server containing a 2010s (Raid 1).

The only problem i have is that I can't boot from my raid. When I boot
from bootdisks the raid works fine!
My bootloader is lilo. The bootpartition on my disks has a ext3 filesystem.
When I boot the machine I can't see nothing from lilo, the machine just
hangs.
(The PhoenixBios recognizes 'I2O OSM' as a HardDrive)

What could be the problem?

Thanx for answering
valli
