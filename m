From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 24/54] md/raid1: Improve another size determination in setup_conf()
Date: Wed, 12 Oct 2016 08:18:37 -0400
Message-ID: <wrfjmvi9221u.fsf@redhat.com>
References: <566ABCD9.1060404@users.sourceforge.net>
        <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
        <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
        <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
        <20161007075345.GB6039@mwanda> <wrfjvax0bbb4.fsf@redhat.com>
        <20161012074307.GB5687@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161012074307.GB5687@mwanda> (Dan Carpenter's message of "Wed,
        12 Oct 2016 11:28:39 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, SF Markus Elfring <elfring@users.sourceforge.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

Dan Carpenter <dan.carpenter@oracle.com> writes:
> Compare:
>
> 	foo = kmalloc(sizeof(*foo), GFP_KERNEL);
>
> This says you are allocating enough space for foo.  It can be reviewed
> by looking at one line.  If you change the type of foo it will still
> work.
>
> 	foo = kmalloc(sizeof(struct whatever), GFP_KERNEL);
>
> There isn't enough information to say if this is correct.  If you change
> the type of foo then you have to update the allocation as well.
>
> It's not a super common type of bug, but I see it occasionally.

I know what you are saying, but the latter in my book is easier to read
and reminds you what the type is when you review the code.

Point being this comes down to personal preference and stating that the
former is the right way or making that a rule and using checkpatch to
harrass people with patches to change it is bogus.

Jes
