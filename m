From: "John Stoffel" <john@stoffel.org>
Subject: Re: Caching raid with SSD.
Date: Mon, 7 Mar 2016 10:17:36 -0500
Message-ID: <22237.39824.242944.705693@quad.stoffel.home>
References: <56DB4A5C.7020901@gmail.com>
	<22236.57403.411891.23182@quad.stoffel.home>
	<56DD0774.3070601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56DD0774.3070601@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: John Stoffel <john@stoffel.org>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Ram" == Ram Ramesh <rramesh2400@gmail.com> writes:

Ram> On 03/06/2016 07:58 PM, John Stoffel wrote:
Ram> Any one here actually use SSD caches for RAID arrays? Can you
Ram> share your experience and let me know your choice of the type of
Ram> cache methods your tired/used and why you think one is better or
Ram> worse than other? If it is possible, please provide raid
Ram> type/size and ssd size used.
>> 
>> I'm using a pair of 4Tb drives mirrored, and a pair of 512gb SSDs,
>> also mirrored, along with lvmcache to setup my caching across a couple
>> of volumes.
>> 
>> I honestly haven't seen huge improvements, but I also haven't had the
>> time to do any serious testing either.  Whcih I should do.  I've been
>> sorta thinking that using the Phoronix testing stuff would be the way
>> to go.
>> 
>> My SSDs and 4Tb drives are all on an LSI 8-port SATA controller, PCI-E
>> 4x I think.  It's an MPT SAS-2 controller.  I did this so that my boot
>> drives are some partitions on the SSDs, and then I use two more
>> mirrored partitions for the cache.
>> 
>> And this is an NFS server for my home directories, etc.
>> 
>> I didn't use bcache because you can't remove a cache device without
>> rebooting, or at least bringing a device offline and back online,
>> which doesn't fit my desires to be able to dynamically add/remove
>> caches, esp for the testing I've never bothered to do.
>> 
>> John

Ram> I do not have lvm, but already have a live (regular) file
Ram> system. While I can accept downtime, I cannot accept formatting
Ram> drives/disks. I simply do not have the extra space to copy back
Ram> and forth. That is why I thought of dmcache. I ran a fio
Ram> experiment on my ssd (old curial M4) and I am getting 6K (random)
Ram> IOPs whereas my raid gives me about 1.5K. I really do not see
Ram> much point unless my new SSD puts out some decent numbers stand
Ram> alone.

I'm not sure fio is the right test here, but it all depends on what
you do, which is the curse of performance testing!

I kinda like kernel compiles, and doing lots of image viewing
(building of thumbnails, etc) to see how things will speed up in my
common usecase.  

Ram> Thanks for sharing the details of your setup.

Good luck with your testing, I'd love to see your results when you've
decided which way to go.
