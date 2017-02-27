From: "Peter Sangas" <pete@wnsdev.com>
Subject: GRUB warning after replacing disk drive in RAID1
Date: Mon, 27 Feb 2017 15:37:24 -0800
Message-ID: <002f01d29152$737b4550$5a71cff0$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all.

I have a RAID1 with 3 disks sda,sdb,sdc.  After replacing sdc and re-syncing
it to the array I issued the following command to load grub but I get this 
warning:

grub-install /dev/sdc

Installing for i386-pc platform.
grub-install: warning: Couldn't find physical volume `(null)'. Some modules
may be missing from core image..
grub-install: warning: Couldn't find physical volume `(null)'. Some modules
may be missing from core image..
Installation finished. No error reported.

Does anyone know why I get this warning and how to avoid it.

uname -a 
Linux green 4.4.0-47-generic #68-Ubuntu SMP Wed Oct 26 19:39:52 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux

mdadm -V
mdadm - v3.3 - 3rd September 2013


Thanks,
Pete



