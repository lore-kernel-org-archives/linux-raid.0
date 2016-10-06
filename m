From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: md/raid10: Replace printk() calls by the usage of higher level
 interfaces
Date: Thu, 6 Oct 2016 20:32:42 +0200
Message-ID: <bb3de1aa-f646-82f6-24af-a77ab75b6146@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <f9f16d1c-c50d-d4be-a6ba-2cb7081eb9b5@users.sourceforge.net>
 <1475771616.1914.9.camel@perches.com>
 <321cc4aa-679a-a2fe-be0b-96285b19e489@users.sourceforge.net>
 <1475775546.1914.15.camel@perches.com>
 <21fb08b6-d5b7-0dd6-0cbd-0f0a4bf56a9e@users.sourceforge.net>
 <1475777887.1820.1.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475777887.1820.1.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

>> Would it be nicer if a single call will be sufficient for such a log message?
>>
>> Can an idea picked up which was discussed for the update suggestion
>> "[PATCH 4/4] Input-gameport: Replace some printk() calls by pr_info() in joydump_connect()"
>> for a moment (on 2016-09-24)?
>> https://lkml.kernel.org/r/<1474735656.23838.6.camel@perches.com>;
>> https://lkml.org/lkml/2016/9/24/149
> 
> That'd be great.
> Pease come back only after you've implemented that.

Does this use case show another improvement opportunity for involved
software developers (besides me)?

Are there any more contributors around who would like to tackle such a challenge?

Regards,
Markus
