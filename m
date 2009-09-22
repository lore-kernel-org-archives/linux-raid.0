From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Random bit flips - better data integrity needed [Was: Re:
	mismatch_count != 0 on multiple hosts]
Date: Tue, 22 Sep 2009 11:18:42 +0000 (UTC)
Message-ID: <h9abqh$e1m$2@ger.gmane.org>
References: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Sep 2009 12:10:34 -0400, Greg Freemyer wrote:

> Specifically you could steal the second parity stripe from a raid 6
> setup and replace it with this end-to-end data integrity checksum / crc.

If you're willing to add that kind of overhead, simply read all of the 
RAID6 stripes into memory and check whether they're consistent.

If not, it's easy to decide (for RAID6) whether the data or the parity is 
wrong: simply check both P and Q. If only one is broken, fix it. If both 
are, correct the data according to P and check if Q is now correct. If 
so, fix it. Otherwise the only thing you can do is to fail the whole 
array, and to alert the operator that they have major hardware issues. :-/

For RAID45, you can do the same, except that there's no way to fix any 
problems since you don't know whether data or parity is right. As the 
error may have crept in upon writing, rereading is of limited use.

For RAID1 (and maybe even multipath), the same idea applies; add majority 
rule when you have more than two disks.

Adding this kind of checking to the RAID456 driver should be rather easy 
for somebody who knows its internals. Its effect on read throughput is 
anyone's guess, of course.


