From: "John Stoffel" <john@stoffel.org>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 23 Jan 2014 09:28:09 -0500
Message-ID: <21217.9977.5869.747472@quad.stoffel.home>
References: <20140121073540.GF10140@merlins.org>
	<20140121163755.GG10140@merlins.org>
	<52DF7976.6070808@hardwarefreak.com>
	<20140122174854.GF26014@merlins.org>
	<52E051A3.3050103@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E051A3.3050103@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Stan" == Stan Hoeppner <stan@hardwarefreak.com> writes:

Stan> On 1/22/2014 11:48 AM, Marc MERLIN wrote:
Stan> ...
>> If crypt is on top of raid5, it seems (and that makes sense) that no
>> encryption is neded for the rebuild. However in my test I can confirm that
>> the rebuild time is exactly the same. I only get 19MB/s of rebuild bandwidth
>> and I think tha'ts because of the port multiplier.

Stan> Ok, now I think we're finally getting to the heart of this.  Given the
Stan> fact that you're doing full array encryption, and after reading your bio
Stan> on your website the other day, I think I've been giving you too much
Stan> credit.  So let's get back to md basics.  Have you performed any md
Stan> optimizations?  The default value of

Stan> /sys/block/mdX/md/stripe_cache_size

Stan> is 256.  This default is woefully inadequate for modern systems, and
Stan> will yield dreadfully low throughput.  To fix this execute

Stan> ~$ echo 2048 > /sys/block/mdX/md/stripe_cache_size

Which Linux kernel version is this in?  I'm running 3.9.3 on my main
home server and I'm not finding this at all.  Nor do I find it on my
Linux Mint 16 desktop running 3.11.0-12-generic either.  

# cat /proc/version
Linux version 3.9.3 (root@quad) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Wed May 22 12:15:10 EDT 2013
# find /sys -name "*stripe*"
# find /dev -name "*stripe*"
# find /proc -name "stripe*"
#

Oh wait... I'm a total moron here.  This feature is only for RAID[456]
arrays, and all I have are RAID1 mirrors for all my disks.  Hmm... it
would almost make more sense for it to be named something different,
but legacy systems would be impacted.  

But more importantly, maybe it would make sense to have this number
automatically scale with memory size?  If you only have 1gig stay at
256, but then jump more aggresively to 1024, 2048, 4196 and 8192 and
then (for now) capping at 8192.  

John
