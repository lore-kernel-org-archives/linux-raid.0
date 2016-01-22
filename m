From: Paul van der Vlis <paul@vandervlis.nl>
Subject: Wrong device name after hot-swap
Date: Fri, 22 Jan 2016 22:55:39 +0100
Message-ID: <n7u8gr$1bv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I want to put bigger disks into my server. What I want to do is replace
the first disk, rebuild the raid, replace the second disk, rebuild the
raid. The machine has two disks, sda and sdb.

But, when I replace a disk, it gets a new device name. E.g. /dev/sdb
becomes /dev/sdc. After a reboot it's good again, but I prefer not to
reboot this machine!

Is there a way to get the correct device name?

When not:
Is it maybe an idea too add the wrong device name to the md-device?
mdadm /dev/md0 -a /dev/sdc1
Then replace /dev/sda what becomes /dev/sdd:
mdadm /dev/md0 -a /dev/sdd1
Then restore grub on both disks (with "--recheck" ??)
But what will happen after a reboot later? Will the md-device be
restored with the old names?

With regards,
Paul van der Vlis.

-- 
Paul van der Vlis Linux systeembeheer Groningen
https://www.vandervlis.nl/

