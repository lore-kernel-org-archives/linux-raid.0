From: Jiri Kosina <jikos@kernel.org>
Subject: Re: md/raid1: Improve another size determination in setup_conf()
Date: Fri, 7 Oct 2016 17:35:24 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.1610071729340.8015@gjva.wvxbf.pm>
References: <566ABCD9.1060404@users.sourceforge.net> <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net> <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net> <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
 <20161007075345.GB6039@mwanda> <77d68bcd-1ae4-4808-fc0b-6183ae5fb6c4@users.sourceforge.net> <e5cddb79-1267-b2d8-c05b-1480096db21e@nod.at> <522db506-1e1c-0563-7595-da6dc701d706@users.sourceforge.net> <6e2c26bc-d765-6225-af72-157832ab8785@gmail.com>
 <a3d1b5a7-4b4e-a37d-2952-bb2e01828c39@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a3d1b5a7-4b4e-a37d-2952-bb2e01828c39@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>, Richard Weinberger <richard@nod.at>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

On Fri, 7 Oct 2016, SF Markus Elfring wrote:

> > but patches that just fix coding style are a bad thing
> 
> When you find such a change opportunity so "bad", are there any 
> circumstances left over where you would dare to touch the corresponding 
> source code line.

If you actually rewrite the code or fix some real bug there.

> > because they break things like `git blame`
> 
> I follow your concern to some degree.
> 
> But can this argument evolve against a lot of changes generally?

If I have to reiterate git blame multiple times just because of whitespace 
or codingstyle changes, it's a pure waste of my time.

If I have to reiterate git blame multiple times to skip actual real 
changes, I have no other option than to live with that (because there was 
an actual functional reason for the change).

-- 
Jiri Kosina
SUSE Labs
