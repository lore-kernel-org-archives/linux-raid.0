From: Curt Hartung <curt@northarc.com>
Subject: Stupid question regarding RAID-1 access pattern
Date: Wed, 06 Jan 2010 14:58:16 -0500
Message-ID: <4B44EB58.2090400@northarc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tried to ferret out the answer to this myself and so far so bad.

This just 'popped in there' while I was optimizing something completely 
different... in a RAID-1, writes have to be mirrored of course, thats 
what RAID-1 is, but for reads, could they not be sped up by a 
significant amount if a storage pattern was chosen such that large 
blocks of data were "striped" in an in-order/out-of-order scheme? In 
other words, store all the data on both drives, but in huge (2x cache 
size) -ish blocks that might allow 50% of a given [large] access to come 
from each drive, with trivial [smaller] reads always coming from one or 
the other chosen at random.

Downside, I know, is that the data would be organized ina  way only the 
raid subsystem would understand, so the niceness of pulling a mirrored 
drive out of service and it being a literal copy of the otehr drive 
would be lost, but for such a speedup I'd be willing to pay the price of 
always having to access it as a failed set (worst case) through the 
md-daemon.

Am I off into the weeds?

-Curt
