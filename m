From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 13:01:44 +1000
Message-ID: <18041.59928.812167.453118@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<20070616020320.GB2002@animx.eu.org>
	<18035.23867.576212.859440@notabene.brown>
	<4673E69A.4020309@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Saturday June 16
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Wakko Warner <wakko@animx.eu.org>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 16, david@dgreaves.com wrote:
> Neil Brown wrote:
> > On Friday June 15, wakko@animx.eu.org wrote:
> >  
> >>                                                   As I understand the way
> >> raid works, when you write a block to the array, it will have to read all
> >> the other blocks in the stripe and recalculate the parity and write it out.
> > 
> > Your understanding is incomplete.
> 
> Does this help?
> [for future reference so you can paste a url and save the typing for code :) ]
> 
> http://linux-raid.osdl.org/index.php/Initial_Array_Creation
> 
> David
> 
> 
> 
> Initial Creation
> 
> When mdadm asks the kernel to create a raid array the most noticeable activity 
> is what's called the "initial resync".
> 
> The kernel takes one (or two for raid6) disks and marks them as 'spare'; it then 
> creates the array in degraded mode. It then marks spare disks as 'rebuilding' 
> and starts to read from the 'good' disks, calculate the parity and determines 
> what should be on any spare disks and then writes it. Once all this is done the 
> array is clean and all disks are active.

This isn't quite right.
Firstly, it is mdadm which decided to make one drive a 'spare' for
raid5, not the kernel.
Secondly, it only applies to raid5, not raid6 or raid1 or raid10.

For raid6, the initial resync (just like the resync after an unclean
shutdown) reads all the data blocks, and writes all the P and Q
blocks.
raid5 can do that, but it is faster the read all but one disk, and
write to that one disk.

NeilBrown
