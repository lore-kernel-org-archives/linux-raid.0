From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active
 devices)
Date: Mon, 14 Jul 2008 10:44:16 +0000 (UTC)
Message-ID: <g5fam0$8oe$1@ger.gmane.org>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com>
	<20080625161357.GH23944@skl-net.de>
	<18532.50062.63173.620773@notabene.brown> <48680586.609@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 29 Jun 2008 17:58:30 -0400, Bill Davidsen wrote:

> Of course build an array out of drives so unstable that you can't safelt
> *run* a check is another topic.

It's a topic that needs to be addressed sooner or later, however.

Let's face it, drives do develop bad spots.

Tossing a perfectly good drive because 0.0000064% of the data cannot be
read is wasteful (assuming a 64-kByte area of an 1-terabyte disk).

My basic approach would be, whenever a read error is encountered, to tell
the disk drive to fix the bad area (either by rewriting the problem area
or by hardware reallocation or by using devmapper), fix the data (either
tell the RAID driver that this particular area needs to be recovered or
do it in userspace), and re-add the drive.

So ... is there some userspace code which, given a bunch of RAID disks,
can rebuild the array? Limiting said rebuild to one particular area on
one particular disk should then be reasonably easy.

-- 
Matthias Urlichs

