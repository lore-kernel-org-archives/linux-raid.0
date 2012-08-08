From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID10 Performance
Date: Wed, 08 Aug 2012 13:49:16 +1000
Message-ID: <5021E1BC.3060607@websitemanagers.com.au>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com> <50129176.3050604@websitemanagers.com.au> <5012DE22.10108@hardwarefreak.com> <50138853.5030100@websitemanagers.com.au> <50140657.8010802@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50140657.8010802@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just some followup questions, hopefully this isn't too off-topic for 
this list, if it is please let me know.

On 07/29/2012 01:33 AM, Stan Hoeppner wrote:
> On 7/28/2012 1:36 AM, Adam Goryachev wrote:
>> On 28/07/12 04:29, Stan Hoeppner wrote:
> But I think you should go with the 10K rpm Raptors.  Same capacity but
> with a 40% increase in spindle speed for only 30% more cost, at Newegg
> prices anyway, but I don't think Newegg ships to Australia.  If money
> were of no concern, which is rarely the case, I'd recommend 15K drives.
>   But they're just so disproportionately expensive compared to 10K drives
> given the capacities offered.
>
> If cost isn't an overriding concern, my recommendation would be to add 8
> of the 10k 1TB Raptor drives and use them for your iSCSI LUN exports,
> and redeploy the RE4 drives.
>
> The performance gain with either 6 or 8 of the Raptors will be substantial.

OK, with the given budget, we currently have a couple of options:
1) Replace the primary SAN (which currently has 2 x 2TB WD Caviar Black 
RE4 drives in RAID1 + a hot spare) with 5 x 1TB Raptors you suggested 
above (4 x 1TB in RAID10 + 1 hot spare).

2) Replace the primary SAN with 3 x 480GB SSD drives in linear + one of 
the existing 2TB drives combined as RAID1 with the 2TB drive in write 
only mode. This reduces overall capacity, but it does provide enough 
capacity for at least 6 to 12 months. If needed, one additional SSD will 
provide almost 2TB across the entire san.

Further expansion becomes expensive, but this enterprise doesn't have a 
lot of data growth (over the past 10 years), so I don't expect it to be 
significant, also given the rate of increasing SSD storage, and 
decreasing cost. Long term it would be ideal to make this system use 8 x 
480G in RAID10, and eventually another 8 on the secondary SAN.

I'm aware that a single SSD failure will reduce performance back to 
current levels.

> And don't use the default 512KB chunk size of metadata 1.2.  512KB per
> chunk is insane.  With your Win server VM workload, where no server does
> much writing of large files or at a sustained rate, usually only small
> files, you should be using a small chunk size, something like 32KB,
> maybe even 16KB.  If you use a large chunk size you'll rarely be able to
> fill a full stripe write, and you'll end up with IO hot spots on
> individual drives, decreasing performance.

I'm assuming that this can't be changed?

Currently, I have:
md RAID
DRBD
LVM

Could I simply create a new MD array with the smaller chunk size, tell 
DRBD to sync from the remote to this new array, and then do the same for 
the other SAN?

Would this explain why one drive has significantly more activity now? I 
don't think so, since it is really just a 2 disk RAID1, so both drives 
should be doing the same writes, and both drives should be servicing the 
read requests. This doesn't seem to be happening, during very high read 
IO this morning (multiple VM's running a full antivirus scan 
simultaneously), one drive activity light was "solid" and the second was 
"flashing slowly".

Added to this, I've just noticed that the array is currently doing a 
"check", would that explain the drive activity and also reduced performance?

> And of course you'll have ~1/3rd the IOPS and throughput should you have
> to deploy the standby in production.
>
> Many people run a DRBD standby server of lesser performance than their
> primary, treating it as a hedge against primary failure, and assuming
> they'll never have to use it.  But it's there just in case.  Thus they
> don't put as much money or capability in it.  I.e. you'd have lots of
> company if you did this.

Understood, and in the case of primary SAN failure, at least work can 
still be completed, even if it is at reduced performance. Replacement 
drives can be done within one working day, so we are further limiting 
that reduced performance to one working day. This would be a perfect 
risk strategy for us, though again, long term we will look at upgrading 
the secondary san to be more similar to the primary.

> Did you happen to notice the domain in my email address? ;)  If you need
> hardware information/advice, on anything from channel
> CPUs/mobos/drives/RAID/NICs/etc to 2560 CPU SGI supercomputers and 1200+
> drive FC SAN storage arrays, FC switch fabrics, and anything in between,
> I can usually provide the info you seek.

My direct emails to you bounced due to my mail server "losing" it's 
reverse DNS. That is a local matter, delayed while "proving" we have 
ownership of the IP space to APNIC.

Thanks again for your advise.

Regards,
Adam

