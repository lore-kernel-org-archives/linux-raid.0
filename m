From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: reconstructing raid5 with bad sectors
Date: Mon, 4 Aug 2003 10:08:15 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0308041002360.21796@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i have a 4 disk array which (due to power problems) has bad sectors on two
of the disks.  as far as i can tell the bad sectors are not in overlapping
stripes of the raid -- so in theory every stripe has 3 components still
available.  but the kernel doesn't like this situation because it
considers a disk to be either all good or all bad :)

is there an offline tool which can reconstruct such an array?  or even an
offline tool which already has the parity calculation code and such which
i could extend to support such reconstruction?

i considered copying the two bad disks with "dd conv=noerror,sync", which
would stop the kernel from marking the drives as bad, but that seems a bit
less than ideal because i really would like to reconstruct the bad stripes
using the 3 valid copies and not include an all-zeroes copy created by dd.

-dean
