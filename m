From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3 02/14] md: move two macros into md.h
Date: Fri, 24 Mar 2017 09:53:25 -0700
Message-ID: <20170324165325.nek4kb4yezz2xmow@kernel.org>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
 <20170316161235.27110-3-tom.leiming@gmail.com>
 <87tw6j8be6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87tw6j8be6.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Mar 24, 2017 at 04:57:37PM +1100, Neil Brown wrote:
> On Fri, Mar 17 2017, Ming Lei wrote:
> 
> > Both raid1 and raid10 share common resync
> > block size and page count, so move them into md.h.
> 
> I don't think this is necessary.
> These are just "magic" numbers.  They don't have any real
> meaning and so don't belong in md.h, or and .h file.
> 
> Possibly we should find more meaningful numbers, or make them auto-size
> or something.  I'm also happy for them to stay as they are for now.
> But I don't think we should pretend that they are meaningful.

I had the same concern when I looked at this patch firstly. The number for
raid1/10 doesn't need to be the same. But if we don't move the number to a
generic header, the third patch will become a little more complicated. I
eventually ignored this issue. If we really need different number for raid1/10,
lets do it at that time.

I think your suggestion that moving the number to raid1-10.h makes sense, and
add a comment declaring the number isn't required to be the same for raid1/10.

Thanks,
Shaohua
