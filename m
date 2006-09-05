From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: checking md device parity (forced resync) - is it necessary?
Date: Tue, 05 Sep 2006 10:59:17 +0200
Message-ID: <44FD3C65.8040000@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lately I installed Debian on a Thecus n4100 machine.
It's a 600 MHz ARM storage device, and has 4 x 400 GB drives.

I made Linux software RAID on these drives:
- RAID-1  - ~1 GB for system (/)
- RAID-1  - ~1 GB for swap
- RAID-10 - ~798 GB for iSCSI storage


I noticed that each day the device slows down; a quick investigation 
discovered that Debian runs a "checkarray" script each night at 1 am 
(via cron). The essence of "checkarray" script is basically this:

echo check > /sys/block/$dev/md/sync_action

Which starts a resync of drives. As one can imagine, resync of 800 GB on 
a rather slow device (600 MHz ARM) can take 12 hours or so...


So my question is: is this "daily forced resync" necessary?

Perhaps in some cases, yes, because someone wrote that tool which does 
it daily.

On the other hand, if we consider Linux software RAID stable, such a 
resync would be only needed in some rare situations.

When can one need to run a "daily forced resync", and in which 
circumstances?


-- 
Tomasz Chmielewski
