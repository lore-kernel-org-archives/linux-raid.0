From: John Lange <john.lange@bighostbox.com>
Subject: is raid compatible between 2.4.22 & 2.6.5 ?
Date: Fri, 11 Jun 2004 12:21:39 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1086974499.5186.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there some reason why a RAID 1 set built under 2.6.5 would not work
under 2.4.22?

I build a machine (Slackware) with two RAID 1 mirrored drives under a
2.6.5 kernel.

I later discovered that I needed to drop back to a 2.4.22 kernel in
order to do some clustering under openMosix and TKCluster so I
downloaded the recommended TKCluster 2.4.22 kernel. This kernel is a
standard kernel with patches for libata and openMosix.

I rebuilt the kernel including support for RAID and serial ATA (ICH5).

When I boot the 2.4.22 kernel it goes along nicely until it tries to
mount the root partition. It then throws up a "modprobe" error.
Something about char-major 9 I think? (I'm sorry but I am not near the
console at the moment).

Is there some reason why a RAID 1 set built under 2.6.5 would not work
under 2.4.22? Is there something I've forgot to include in my 2.4.22
kernel that is preventing it from mounting?

Thanks,

John Lange


