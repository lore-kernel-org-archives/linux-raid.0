From: Matthias Urlichs <matthias@urlichs.de>
Subject: raid6 recovery with read errors
Date: Mon, 3 Aug 2009 08:36:06 +0000 (UTC)
Message-ID: <h567hm$u6a$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a rather large RAID6 array where multiple disks have developed
read errors. The problem is that the RAID6 is built from LVM-mapped disks,
which (I think) isolated the MD driver from write errors. Thus it thought
that a re-write of the bad sectors succeeded. WRONG. Thus the bad disks
were never unmapped.

The problem is that yesterday, three of these TByte disks failed in
_exactly_ the same 1k-sized spot. So, no more RAID6. :-(

So, how do I get the data back?

I've copied the individual partitions with ddrescue, which conveniently
left me a log file pointing to the sectors which need to be recovered.
However, I'm sure that there's no way to tell the kernel about individual
"bad spots".

Is there a standalone program that can do that?

-- 
Matthias Urlichs

