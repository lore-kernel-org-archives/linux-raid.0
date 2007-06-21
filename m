From: David Greaves <david@dgreaves.com>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 09:49:06 +0100
Message-ID: <467A3B82.1030607@dgreaves.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>	<18034.479.256870.600360@notabene.brown>	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>	<18034.3676.477575.490448@notabene.brown>	<20070616020320.GB2002@animx.eu.org>	<18035.23867.576212.859440@notabene.brown>	<4673E69A.4020309@dgreaves.com> <18041.59928.812167.453118@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18041.59928.812167.453118@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Wakko Warner <wakko@animx.eu.org>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> This isn't quite right.
Thanks :)

> Firstly, it is mdadm which decided to make one drive a 'spare' for
> raid5, not the kernel.
> Secondly, it only applies to raid5, not raid6 or raid1 or raid10.
> 
> For raid6, the initial resync (just like the resync after an unclean
> shutdown) reads all the data blocks, and writes all the P and Q
> blocks.
> raid5 can do that, but it is faster the read all but one disk, and
> write to that one disk.

How about this:

Initial Creation

When mdadm asks the kernel to create a raid array the most noticeable activity 
is what's called the "initial resync".

Raid level 0 doesn't have any redundancy so there is no initial resync.

For raid levels 1,4,6 and 10 mdadm creates the array and starts a resync. The 
raid algorithm then reads the data blocks and writes the appropriate 
parity/mirror (P+Q) blocks across all the relevant disks. There is some sample 
output in a section below...

For raid5 there is an optimisation: mdadm takes one of the disks and marks it as 
'spare'; it then creates the array in degraded mode. The kernel marks the spare 
disk as 'rebuilding' and starts to read from the 'good' disks, calculate the 
parity and determines what should be on the spare disk and then just writes to it.

Once all this is done the array is clean and all disks are active.

This can take quite a time and the array is not fully resilient whilst this is 
happening (it is however fully useable).





Also is raid4 like raid5 or raid6 in this respect?
