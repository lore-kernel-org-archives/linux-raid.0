From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Why 4k native drives haven't arrived
Date: Thu, 02 Jan 2014 19:53:11 -0600
Message-ID: <52C61807.6050906@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Until someone demonstrates otherwise I will continue to state that 4K
native drives are still not on the open market.  And the reason for this
is quite logical if given a moment of thought.

Advanced Format 512e drives, drives with 4K native sectors but 512B
sectors presented to the host, fully accomplished the goal of the
spinning disk drive manufacturers.  That goal was simply to pack more
data per platter, on average about 11% more, by reducing the amount of
bits consumed for ECC.  I.e. they can sell a lager capacity drive using
the same hardware as a native 512 byte/sector drive, or with some drive
capacities, reduce the number of platters while maintaining the same
capacity, thus reducing component and production cost, and hopefully
retail price.

The physical sector size presented to the host is irrelevant to the
drive manufacturers, given the singular goal above.  Switching to a
native 4K sector does not benefit the manufacturers.  At the current
time it actually will cause them tremendous problems.

If they were to put 4K native drives on the market today, many millions
of Windows XP users would buy the drives, ignoring, or simply not
reading far enough to find the "4K native" warnings.  They then return
the drives when they don't work, causing great ill will, bad reviews
tarnishing manufacturers' reputations, and decreasing repeat business.
Thus native 4K drives will not be on the open market until the
manufacturers are comfortable that most legacy machines have been
retired, eliminating the possibility of the scenario above.

The first units of native 4K drives will be, or possibly already have
been, to OEMs who exercise control over which systems and disk arrays in
which the drives will be installed.  This prevents such a problem in the
enterprise space, as purchasers typically rely on their vendors to do
compatibility matching.  Enterprise OEMs have long maintained such
product compatibility databases.

-- 
Stan


