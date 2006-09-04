From: "Julio Meca Hansen" <julio28@jumec.jazztel.es>
Subject: RAID-0 on the Intel ICH7R chipset and swap configuration...
Date: Mon, 4 Sep 2006 03:38:50 +0200
Message-ID: <000e01c6cfc2$df6bb220$0c01a8c0@mobilebox>
References: <S1751187AbWICWhh/20060903223813Z+56@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I would like to ask for advice on the following subject:

I've recently acquired a FOXCONN 945G7MA-8EKRS2 mATX board, which comes
with an Intel ICH7R chipset, and I would like to make a RAID-0 array
with 3 disks of equal size (750GB in this case) with an XFS filesystem
(system configuration is for a pure 64bit system)

but I have some concerns about the software raid under linux:

1. giving the fact the RAID management the chipset does is by software,
I should use mdadm for all management task, right? or does the driver in
the linux kernel tree take the work for me? (no lazyness intended, just
want to be sure I'm thinking on the right way of doing things)

2. is it advisable to make a RAID-0 array with only 3 disks? I mean... I
know it works with 2 or more disks but... would an odd number of drives
hinder the performance of the driver?

3. should I place /boot on the array or should it be better to place it
on the fourth disk I have (to place the /swap partition, among other
reasons)? I suppose if I place /boot on the array it could give me a
faster startup on disk access related processes, or is this assumption
wrong?

Sorry for so many questions, I have no real experience with RAID and I
would like to learn but would like some advice on this to be on the
right way

Thanks in advance,
Julio Meca Hansen


-- 
VGER BF report: U 0.912078
