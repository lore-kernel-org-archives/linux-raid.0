From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: md/raid1: Improve another size determination in setup_conf()
Date: Fri, 7 Oct 2016 07:52:22 -0400
Message-ID: <6e2c26bc-d765-6225-af72-157832ab8785@gmail.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
 <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
 <20161007075345.GB6039@mwanda>
 <77d68bcd-1ae4-4808-fc0b-6183ae5fb6c4@users.sourceforge.net>
 <e5cddb79-1267-b2d8-c05b-1480096db21e@nod.at>
 <522db506-1e1c-0563-7595-da6dc701d706@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <522db506-1e1c-0563-7595-da6dc701d706@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Richard Weinberger <richard@nod.at>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

On 2016-10-07 06:50, SF Markus Elfring wrote:
>> Linux has tons of issues, fixes for real problems are very welcome.
>
> Is a spectrum of software improvements to reconsider there?
>
>
>> But coding style bike shedding is just a waste of time.
>
> Why do various software developers bother about coding style specifications
> at all then?
Coding style is important, but patches that just fix coding style are a 
bad thing because they break things like `git blame` and run the risk of 
introducing new bugs without any net benefit to end users.  This goes 
double for code you don't actually work on regularly or don't completely 
understand.
