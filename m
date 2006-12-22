From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] latency problem in md driver
Date: Fri, 22 Dec 2006 10:19:53 -0500
Message-ID: <458BF799.6010703@garzik.org>
References: <20061222143215.GD7477@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061222143215.GD7477@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <Lars.Ellenberg@linbit.com>
Cc: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-raid.ids

Lars Ellenberg wrote:
> md raidX make_request functions strip off the BIO_RW_SYNC flag,
> this introducing additional latency.
> 
> below is a suggested patch for the raid1.c .
> other suggested solutions would be to let the bio_clone do its work,
> and not reassign thereby stripping off all flags.
> at most strip off known unwanted flags (the BARRIER flag).

It sounds like a major bug to strip the barrier flag.  I quite 
understand that a barrier to a RAID device as a whole behaves 
differently from a barrier to an ATA or SCSI device, but that's no 
excuse to avoid the problem.

If MD does not pass barriers, it is unilaterally dropping the "data made 
it to the media" guarantee.

	Jeff


