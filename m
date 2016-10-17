From: Hannes Reinecke <hare@suse.de>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 10:09:50 +0200
Message-ID: <2cc42b2f-1f1a-e95c-91fa-54e1dd3b6d49@suse.de>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
 <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
 <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
 <1e151094-e228-5307-ae2f-b376b31f5628@suse.de>
 <83e720c6-9037-a3c1-6e83-27505805f37f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <83e720c6-9037-a3c1-6e83-27505805f37f@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On 10/17/2016 09:39 AM, SF Markus Elfring wrote:
>>>> Does it improve code? Does it improve anything?
>>>
>>> Yes. - I got such an impression.
>>>
>>> * Is it more efficient to call the function "seq_printf" for the desired data processing
>>>   for a single character than to pass it to the function "" in a string?
>>>
>>> * Will the required data transfer shrink a bit for the affected functions because of
>>>   such a change?
>>>
>> Which are questions _you_ should be able to answer.
> 
> I wonder that the answers are not obvious for you already.
> 
> Calling the function "seq_putc" will be more efficient than "seq_printf"
> in this case because of the following reasons.
> 
> 1. How does the distribution look like for supported processor architectures
>    where the data transfer for bytes (as a function call parameter)
>    is faster than for (string) pointers?
> 
How would I know? I would assume that _you_ did some measurements here;
after all, _you_ are trying to push this patch.
I could easily claim that seq_printf() is more efficient than
seq_putc(), and won't apply your patch.
So _you_ have to prove that your patch is more efficient.

> 2. Did anybody measure already how many the execution times can vary
>    for these functions?
> 
Probably not.
But referring to the previous topic:
Unless _you_ prove that _your_ patch is more efficient it won't get
applied. _You_ want us to apply your patch, so the burden is on _you_ to
provide the required data.


>    Where do you get doubts about its efficiency for the data processing
>    of a single character?
> 
Because it's being called at the end of a function calling seq_printf()
already. So exchanging a single call is probably not helping anything,
as the compiler will optimize it anyway.
Case in point: with your patch the x86_64 compiler generates nearly
identical code for driver/md/raid1.c, but with one instruction _more_
after your patch has been applied.

So it's not immediately obvious that your patch is an improvement.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
