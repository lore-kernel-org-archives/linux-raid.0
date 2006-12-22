From: Ric Wheeler <ric@emc.com>
Subject: Re: [patch] latency problem in md driver
Date: Fri, 22 Dec 2006 10:37:14 -0500
Message-ID: <458BFBAA.3060805@emc.com>
References: <20061222143215.GD7477@soda.linbit> <458BF799.6010703@garzik.org>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <458BF799.6010703@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Lars Ellenberg <Lars.Ellenberg@linbit.com>, Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Lars Ellenberg wrote:
>> md raidX make_request functions strip off the BIO_RW_SYNC flag,
>> this introducing additional latency.
>>
>> below is a suggested patch for the raid1.c .
>> other suggested solutions would be to let the bio_clone do its work,
>> and not reassign thereby stripping off all flags.
>> at most strip off known unwanted flags (the BARRIER flag).
> 
> It sounds like a major bug to strip the barrier flag.  I quite 
> understand that a barrier to a RAID device as a whole behaves 
> differently from a barrier to an ATA or SCSI device, but that's no 
> excuse to avoid the problem.
> 
> If MD does not pass barriers, it is unilaterally dropping the "data made 
> it to the media" guarantee.
> 
>     Jeff

Exactly right - if we do not pass the barrier request down to the 
members of the RAID group, then we lose the data integrity needed.

Of course, in a RAID group, this will be introduce latency, but that is 
the correct behavior.

ric
