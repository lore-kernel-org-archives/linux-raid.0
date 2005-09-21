From: "bart@ardistech.com" <bart@ardistech.com>
Subject: Setting NR_STRIPES high increases RAID5 performance
Date: Wed, 21 Sep 2005 11:33:46 +0200
Message-ID: <433128FA.200E7018@ardistech.com>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

When testing a soft RAID5 (8 SATA drives, Marvell chip) with iometer I noticed
that the read performance did drop much less when adding randomness to the drive
access as the write performance (read 80MB/s->40MB/s, write 70MB/s->9MB/s). Such a
difference I can't explain by the read-compute-write of the parity stripe.
I found that increasing NR_STRIPES from 256 to (8*1024) did increase the throughput
for write from 9MB/s to 35 MB/s. This is still less as I would expect from 8
SATA disks in parallel. Could it be the raid5d thread is not waken up enough
or has not enough priority? Anybody knows any other #defines that could help
here?

	Bart
