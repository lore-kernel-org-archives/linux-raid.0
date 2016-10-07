From: Richard Weinberger <richard@nod.at>
Subject: Re: md/raid1: Improve another size determination in setup_conf()
Date: Fri, 7 Oct 2016 11:06:29 +0200
Message-ID: <e5cddb79-1267-b2d8-c05b-1480096db21e@nod.at>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
 <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
 <20161007075345.GB6039@mwanda>
 <77d68bcd-1ae4-4808-fc0b-6183ae5fb6c4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <77d68bcd-1ae4-4808-fc0b-6183ae5fb6c4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

On 07.10.2016 10:53, SF Markus Elfring wrote:
>>>> Replace the specification of a data structure by a pointer dereference
>>>> as the parameter for the operator "sizeof" to make the corresponding size
>>>> determination a bit safer.
>>>
>>> Isn't this pure matter of taste?
>>> Some developers prefer sizeof(*ptr) because it is easier to type, other
>>> developers prefer sizeof(struct foo) because you can determine the type
>>> at first sight and makes review more easy.
>>
>> sizeof(*ptr) is more future proof and normally more obvious and easier
>> to review.
> 
> Is it interesting to see how different the software development opinions
> can be for such an implementation detail?
> 
> 
>> That said, I've tried to tell Markus to only send bugfix patches
> 
> Can any deviations from the Linux coding style become "bugs" also in
> your view of the software situation?
> 
> 
>> because these are a waste of time
> 
> How do you value compliance with coding styles?

Just stop sending these kind of patches, *please*.
Linux has tons of issues, fixes for real problems are very welcome.
But coding style bike shedding is just a waste of time.

Thanks,
//richard
