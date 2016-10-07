From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: md/raid1: Improve another size determination in setup_conf()
Date: Fri, 7 Oct 2016 17:27:05 +0200
Message-ID: <a3d1b5a7-4b4e-a37d-2952-bb2e01828c39@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
 <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
 <20161007075345.GB6039@mwanda>
 <77d68bcd-1ae4-4808-fc0b-6183ae5fb6c4@users.sourceforge.net>
 <e5cddb79-1267-b2d8-c05b-1480096db21e@nod.at>
 <522db506-1e1c-0563-7595-da6dc701d706@users.sourceforge.net>
 <6e2c26bc-d765-6225-af72-157832ab8785@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <6e2c26bc-d765-6225-af72-157832ab8785@gmail.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Richard Weinberger <richard@nod.at>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

>> Why do various software developers bother about coding style specifications
>> at all then?
> Coding style is important,

Thanks that you "dare" to express also such an opinion.


> but patches that just fix coding style are a bad thing

When you find such a change opportunity so "bad", are there any circumstances
left over where you would dare to touch the corresponding source code line.


> because they break things like `git blame`

I follow your concern to some degree.

But can this argument evolve against a lot of changes generally?


> and run the risk of introducing new bugs

Did this really "happen" because of an update suggestion for this software module?


> without any net benefit to end users.

Can the proposed adjustment help to make a function like "setup_conf"
a bit more robust (together with related update steps) so that an improved
coding style compliance will hopefully influence the error probability
in positive ways?


> This goes double for code you don't actually work on regularly
> or don't completely understand.

How does such a kind of general feedback fit to the shown change
possibilities in this patch series?

Do you reject this update step?

Regards,
Markus
