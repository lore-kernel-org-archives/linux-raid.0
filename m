From: Andy Smith <andy@strugglers.net>
Subject: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 9 Oct 2013 12:31:35 +0000
Message-ID: <20131009123135.GT1779@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Due to increasing load of random read IOPS I am considering using 8
SSDs and md in my next server, instead of 8 SATA HDDs with
battery-backed hardware RAID. I am thinking of using Crucial m500s.

Are there any gotchas to be aware of? I haven't much experience with
SSDs.

If these were normal HDDs then (aside from small partitions for
/boot) I'd just RAID-10 for the main bulk of the storage. Is there
any reason not to do that with SSDs currently?

I think I read somewhere that offline TRIM is only supported by md
for RAID-1, is that correct? If so, should I be finding a way to use
four pairs of RAID-1s, or does it not matter?

Any insights appreciated.

Cheers,
Andy
