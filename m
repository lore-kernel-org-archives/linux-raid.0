From: Francis Moreau <francis.moro@gmail.com>
Subject: Some info given by 'mdadm --detail --export' are not convenient to
 use
Date: Fri, 11 Apr 2014 13:01:49 +0200
Message-ID: <5347CB9D.5090702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I'm writing a tool that relies udev lib in order to manage block
devices connected to my computer.

One thing that I need is to retrieve disks contained by a RAID array.

The current usefull information exported by udev are, for example:

MD_DEVICES=3
MD_DEVICE_loop0p1_DEV=/dev/loop0p1
MD_DEVICE_loop0p1_ROLE=0
MD_DEVICE_loop1p1_DEV=/dev/loop1p1
MD_DEVICE_loop1p1_ROLE=1
MD_DEVICE_loop2p1_DEV=/dev/loop2p1
MD_DEVICE_loop2p1_ROLE=2

but this is not really easy to exploit since I need to know the disk
names in order to poke the devices used by the array :-/

why not simply using ?

MD_DEVICE_DEV_1=/dev/loop0p1
MD_DEVICE_ROLE_1=0

Thanks
