From: Neil Brown <neilb@suse.de>
Subject: Re: RAID0 performance question
Date: Wed, 21 Dec 2005 12:40:35 +1100
Message-ID: <17320.45715.533255.759042@cse.unsw.edu.au>
References: <437E2CB6.2030903@xss.co.at>
	<200511272040.47644.a1426z@gawab.com>
	<041e01c5f605$6a7c0830$0400a8c0@dcccs>
	<200512022253.17282.a1426z@gawab.com>
	<00fd01c60367$d8d8f5d0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Sunday December 18
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 18, djani22@dynamicweb.hu wrote:
> 
> The raid (md) device why dont have scheduler in sysfs?
> And if it have scheduler, where can i tune it?

raid0 doesn't do any scheduling.
All it does is take requests from the filesystem, decide which device
they should go do (possibly splitting them if needed) and forwarding
them on to the device.  That is all.

> The raid0 can handle multiple requests at one time?

Yes.  But raid0 doesn't exactly 'handle' requests.  It 'directs'
requests for other devices to 'handle'.

> 
> For me, the performance bottleneck is cleanly about RAID0 layer used exactly
> as "concentrator" to join the 4x2TB to 1x8TB.
> But it is only a software, and i cant beleave it is unfixable, or
> tunable.

There is really nothing to tune apart from chunksize.

You can tune the way the filesystem/vm accesses the device by setting
readahead (readahead on component devices of a raid0 has exactly 0
effect). 

You can tune the underlying devices by choosing a scheduler (for a
disk drive) or a packet size (for over-the-network devices) or
whatever. 

But there is nothing to tune in raid0.


Also, rather than doing measurements on the block devices (/dev/mdX)
do measurements on a filesystem created on that device.
I have often found that the filesystem goes faster than the block
device.


NeilBrown
