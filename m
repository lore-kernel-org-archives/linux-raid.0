From: Maurice Hilarius <maurice@harddata.com>
Subject: interesting md problem
Date: Thu, 09 Oct 2003 17:45:42 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20031009170729.0718b5a0@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I ran into an interesting problem:

Machine is built around a Tyan S2880 dual Opteron motherboard.
Memory installed is 6GB.

Install is Red Hat Taroon, version 2
64 bit environment.

2 IDE disk running on the motherboard, set up as RAID1

We can load the system, fdisk the drives, do all manner of things in a 
normal fashion.

The moment we load the md driver the system locks up hard.

IF we set the kernel boot line to tell it to use under 4GB, no problems.

So as to avoid re-inventing any wheels I thought to post this here in hope 
somebody would know something..

Thanks!

