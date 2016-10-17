From: Hannes Reinecke <hare@suse.de>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 17:33:31 +0200
Message-ID: <05d0cade-7922-9d8a-a974-34b2cc9150fb@suse.de>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
 <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
 <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
 <1e151094-e228-5307-ae2f-b376b31f5628@suse.de>
 <83e720c6-9037-a3c1-6e83-27505805f37f@users.sourceforge.net>
 <2cc42b2f-1f1a-e95c-91fa-54e1dd3b6d49@suse.de>
 <653e60ee-f862-8828-3e4f-498c7cc34bdc@users.sourceforge.net>
 <c2500336-5848-66c3-ecf0-1ade04decf75@suse.de>
 <a0f96e19-fa24-8507-2b77-344a342113aa@users.sourceforge.net>
 <1476703920.2520.105.camel@petrovitsch.priv.at>
 <97f31b70-e3ff-f194-c753-54da1fe3e664@users.sourceforge.net>
 <57299b72-8e6b-0b92-4374-1b7a0907e810@suse.de>
 <cb9beadc-3ea2-c09c-f621-a54cd73e3647@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cb9beadc-3ea2-c09c-f621-a54cd73e3647@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, kbuild-all@01.org, ltp@lists.linux.it
List-Id: linux-raid.ids

On 10/17/2016 04:30 PM, SF Markus Elfring wrote:
>>> Am I the only software developer so far who would dare to reconsider
>>> implementation details from three status functions?
>>>
>> No.
>
> Thanks for this kind of promising feedback.
>
>
>> But we're waiting for you showing is that it is an improvement.
>
> Can this aspect also be clarified to some degree from a logical point of view?
>
I sincerely doubt that.
We've discussed the logical implications already, and failed to come to 
a consensus. So we need some proof (as in: on this architecture I'm 
seeing this and that performance improvements).
Which you have to deliver.

> * Would you really like to know under which circumstances data processing
>   will be faster for a single character instead of using a string pointer
>   and corresponding two characters?
>
It's not a problem of the interface, it's a problem of the resulting 
code (ie assembler output). We can discuss all we like, if the compiler 
decides to throw in an optimisation none of the arguments even apply.

> * Do you care for a changed memory allocation characteristic?
>
> * Will it occasionally be useful to avoid the storage for another string literal?
>
Occasionally: yes.
In this particular case: hardly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
