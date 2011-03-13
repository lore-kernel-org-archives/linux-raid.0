From: Asdo <asdo@shiftmail.org>
Subject: Raid1 mismatches maybe associated to free space
Date: Mon, 14 Mar 2011 00:18:29 +0100
Message-ID: <4D7D50C5.6090807@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Some time ago there was a discussion on how it could happen that
sometimes people see mismatches on MD raid1.
Some people reported to see a lot of them, especially in raid1 directly
on partitions and without LVM on top.
I had never seen one, but note I usually use LVM.

Today I saw this happening on a machine of mine without lvm so I could
do a test that has been on my mind for a while.

Firstly, the machine is a very particular setup:
- It boots from 2 x 4GB usb flash keys in raid1 (2-way raid1) and has no
HDD.
- The raid1 was directly on partitions and no LVM on it
- The usb flash keys probably do not honour sync.
- It had a few abrupt poweroffs in its life.
- The MD bitmap was active, and has been active most of its life. But
probably it experienced at least 1 abrupt poweroff with bitmap active
and 1 abrupt poweroff with bitmap inactive.

When I did the "check" today I saw 1024 mismatch_cnt.
So I took the occasion to do a test it was on my mind for a while:

dd if=/dev/zero of=fillitup bs=1M ; sync ; rm fillitup

wait for it, then do again check, wait for it, and then read
mismatch_cnt again.

The mismatch_cnt was zero this time!
This means afaiu that the mismatches were on the free space.

Now quoting Goswin Von Bredelow as of 01/22/2010 07:13 PM:

> There is some unknown corruption going on with raid1 that causes
> mismatches but it is believed that it will never occur on any used
> block. Swapping is a likely cause.
>
> Any swap device on the raid? Try turning that off.
> If that doesn't help try umounting filesystems or remounting RO.
>
> MfG
>         Goswin

...exactly... this seemed to be my case.
Clearly I don't know if it's always the case.

So people experiencing corruption: would you also do this test and
report? It's easy and takes little time...

Thank you
