From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1] md: Convert to use int_pow()
Date: Fri, 26 Jul 2019 21:58:25 +0300
Message-ID: <20190726185825.GC9224@smile.fi.intel.com>
References: <20190723204155.71531-1-andriy.shevchenko@linux.intel.com>
 <20190726164823.GB9224@smile.fi.intel.com>
 <F7CF9393-B366-4810-B127-876C6D5A72A1@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F7CF9393-B366-4810-B127-876C6D5A72A1@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Coly Li <colyli@suse.de>, Mikulas Patocka <mpatocka@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 26, 2019 at 05:18:09PM +0000, Song Liu wrote:
> 
> 
> > On Jul 26, 2019, at 9:48 AM, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > 
> > On Tue, Jul 23, 2019 at 11:41:55PM +0300, Andy Shevchenko wrote:
> >> Instead of linear approach to calculate power of 10, use generic int_pow()
> >> which does it better.
> > 
> > I took into Cc drivers/dm guys as they might have known something about md raid
> > state of affairs. Sorry if I mistakenly added somebody.
> > 
> > Who is doing this?
> > Should it be orphaned?
> > 
> > (I got a bounce from Shaohua address)
> 
> I process the patch. Sorry for the delay.

Ah, no problem, thanks!

Perhaps someone can update MAINTAINERS data base?

-- 
With Best Regards,
Andy Shevchenko
