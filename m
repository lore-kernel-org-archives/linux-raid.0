From: "Yildiz, Murat" <murat.yildiz@atosorigin.com>
Subject: /boot with raid1-root
Date: Thu, 18 Jul 2002 10:35:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <09DC92F4BACCD31198FC009027D3A0C00299F2B4@exchange-s>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Hi,
my last try was with the following settings;
I have installed suse7.3 with 4G raid1 /  (/dev/sda1 & /dev/sdb1  as
/dev/md0) and 1G swap as /dev/sda2.I chose to install the boot loader to the
/dev/sda1 partition and the install was completed except at the end it said
it could not write the boot loader to the partition.
But when I rebooted the machine it booted from /dev/md0 and the install was
ok.
The question is, why does an error occur if I have a non-raid /boot
partition and tell the installer to install the boot record to /boot?

thx

Murat 
