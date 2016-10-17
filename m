From: Hannes Reinecke <hare@suse.de>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 07:58:52 +0200
Message-ID: <1e151094-e228-5307-ae2f-b376b31f5628@suse.de>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
 <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
 <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On 10/16/2016 07:10 PM, SF Markus Elfring wrote:
>> Does it improve code? Does it improve anything?
> 
> Yes. - I got such an impression.
> 
> * Is it more efficient to call the function "seq_printf" for the desired data processing
>   for a single character than to pass it to the function "" in a string?
> 
> * Will the required data transfer shrink a bit for the affected functions because of
>   such a change?
> 
Which are questions _you_ should be able to answer.
It's your patch, after all.
Once you do (and prove that the answer is 'yes' to the above two
questions) the patch will be applied.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
