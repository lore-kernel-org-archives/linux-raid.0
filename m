From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Better handling of readerrors with raid5.
Date: Thu, 22 Dec 2005 14:45:01 -0800
Message-ID: <200512222245.jBMMj1r0007687@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>i recovered my raid by using dd_rescue the last failed disk to a spare 
>disk (with 4 read errors)
>(and doing a mdadm -A -force)

>(so I should have a corrupted file somewhere?)

Or a corrupted filesystem, which e2fsck will find & fix.

Did you write down the bad sectors?  If so, you can use debugfs to find out
where they are on the filesystem. Computing the filesystem block number from
the device sector number will be an exercise...

