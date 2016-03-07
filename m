From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Caching raid with SSD.
Date: Sun, 6 Mar 2016 22:45:40 -0600
Message-ID: <56DD0774.3070601@gmail.com>
References: <56DB4A5C.7020901@gmail.com>
 <22236.57403.411891.23182@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22236.57403.411891.23182@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2016 07:58 PM, John Stoffel wrote:
> Ram> Any one here actually use SSD caches for RAID arrays? Can you
> Ram> share your experience and let me know your choice of the type of
> Ram> cache methods your tired/used and why you think one is better or
> Ram> worse than other? If it is possible, please provide raid
> Ram> type/size and ssd size used.
>
> I'm using a pair of 4Tb drives mirrored, and a pair of 512gb SSDs,
> also mirrored, along with lvmcache to setup my caching across a couple
> of volumes.
>
> I honestly haven't seen huge improvements, but I also haven't had the
> time to do any serious testing either.  Whcih I should do.  I've been
> sorta thinking that using the Phoronix testing stuff would be the way
> to go.
>
> My SSDs and 4Tb drives are all on an LSI 8-port SATA controller, PCI-E
> 4x I think.  It's an MPT SAS-2 controller.  I did this so that my boot
> drives are some partitions on the SSDs, and then I use two more
> mirrored partitions for the cache.
>
> And this is an NFS server for my home directories, etc.
>
> I didn't use bcache because you can't remove a cache device without
> rebooting, or at least bringing a device offline and back online,
> which doesn't fit my desires to be able to dynamically add/remove
> caches, esp for the testing I've never bothered to do.
>
> John
I do not have lvm, but already have a live (regular) file system. While 
I can accept downtime, I cannot accept formatting drives/disks. I simply 
do not have the extra space to copy back and forth. That is why I 
thought of dmcache. I ran a fio experiment on my ssd (old curial M4) and 
I am getting 6K (random) IOPs whereas my raid gives me about 1.5K. I 
really do not see much point unless my new SSD puts out some decent 
numbers stand alone.

Thanks for sharing the details of your setup.

Ramesh
