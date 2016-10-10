From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 24/54] md/raid1: Improve another size determination in
 setup_conf()
Date: Mon, 10 Oct 2016 14:12:34 +0300
Message-ID: <20161010110050.GA5687@mwanda>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
 <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvx0Fr-WNvKYACdvNiZwYzHW4ocna9HPH8J_WPSXWc+ngg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

On Thu, Oct 06, 2016 at 11:29:20AM +0200, Richard Weinberger wrote:
> On Thu, Oct 6, 2016 at 11:22 AM, SF Markus Elfring
> <elfring@users.sourceforge.net> wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Tue, 4 Oct 2016 21:46:18 +0200
> >
> > Replace the specification of a data structure by a pointer dereference
> > as the parameter for the operator "sizeof" to make the corresponding size
> > determination a bit safer.
> 
> Isn't this pure matter of taste?
> Some developers prefer sizeof(*ptr) because it is easier to type, other
> developers prefer sizeof(struct foo) because you can determine the type
> at first sight and makes review more easy.
> 

I am ignoring Markus patches and have told him that he should focus on
bug fixes.  These patches don't add any value and regularly introduce
bugs.

That said, "sizeof(*ptr)" is sort of official style.  It's slightly
more obvious and easier to review because all the information you need
is on that one line.  Also if we change the datatype of ptr then that
format is slightly more future proof.

regards,
dan carpenter
