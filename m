From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 24/54] md/raid1: Improve another size determination in
 setup_conf()
Date: Wed, 12 Oct 2016 11:28:39 +0300
Message-ID: <20161012074307.GB5687@mwanda>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
 <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
 <20161007075345.GB6039@mwanda>
 <wrfjvax0bbb4.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wrfjvax0bbb4.fsf@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, SF Markus Elfring <elfring@users.sourceforge.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

Compare:

	foo = kmalloc(sizeof(*foo), GFP_KERNEL);

This says you are allocating enough space for foo.  It can be reviewed
by looking at one line.  If you change the type of foo it will still
work.

	foo = kmalloc(sizeof(struct whatever), GFP_KERNEL);

There isn't enough information to say if this is correct.  If you change
the type of foo then you have to update the allocation as well.

It's not a super common type of bug, but I see it occasionally.

regards,
dan carpenter
