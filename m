From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: md/raid1: Improve another size determination in setup_conf()
Date: Mon, 10 Oct 2016 09:11:25 -0400
Message-ID: <wrfjr37obb7m.fsf@redhat.com>
References: <566ABCD9.1060404@users.sourceforge.net>
        <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
        <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
        <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
        <20161007075345.GB6039@mwanda>
        <77d68bcd-1ae4-4808-fc0b-6183ae5fb6c4@users.sourceforge.net>
        <e5cddb79-1267-b2d8-c05b-1480096db21e@nod.at>
        <522db506-1e1c-0563-7595-da6dc701d706@users.sourceforge.net>
        <6e2c26bc-d765-6225-af72-157832ab8785@gmail.com>
        <a3d1b5a7-4b4e-a37d-2952-bb2e01828c39@users.sourceforge.net>
        <alpine.LRH.2.00.1610071729340.8015@gjva.wvxbf.pm>
        <dd69629f-abf4-cc03-dddb-b2f3e7cb92fd@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dd69629f-abf4-cc03-dddb-b2f3e7cb92fd@users.sourceforge.net> (SF
        Markus Elfring's message of "Fri, 7 Oct 2016 18:38:52 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jiri Kosina <jikos@kernel.org>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>, Richard Weinberger <richard@nod.at>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

SF Markus Elfring <elfring@users.sourceforge.net> writes:
>>>> but patches that just fix coding style are a bad thing
>>>
>>> When you find such a change opportunity so "bad", are there any 
>>> circumstances left over where you would dare to touch the corresponding 
>>> source code line.
>> 
>> If you actually rewrite the code or fix some real bug there.
>
> Do the proposed update steps 12 - 16 for the function "setup_conf"
> (in this software module) fit to your condition?
>
> Do you reject this update step?

I do - those changes do nothing to improve the code and simply hides a
lot of history.

Jes
