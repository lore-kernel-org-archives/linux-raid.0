From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: A simple question
Date: Wed, 16 Jul 2003 11:11:32 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000f01c34bc5$afc68790$df01010a@moon>
References: <Pine.LNX.4.43.0307121548180.6220-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
   I have a simple question:
    Can software raid survive one disk hot unplug when the raid is under
heavy load?

    During my test (3ware 7500-8 jbod mode, software raid 5), I ran bonnie++
on the
top of md and then unplugged one disk. I saw a lot of scsi disk errors from
dmesg, and then
scsi layer marked this disk offline. Finnally md detected disk failure and
mark this disk
as faulty. But bonnie++ still hangs there with state 'D' which could not be
killed by -9.

Thanks!

Donghui Wen





