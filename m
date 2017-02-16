From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 00/17] md: cleanup on direct access to bvec table
Date: Thu, 16 Feb 2017 14:16:42 -0800
Message-ID: <20170216221642.sobqndndd7fbjoo7@kernel.org>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Thu, Feb 16, 2017 at 07:45:30PM +0800, Ming Lei wrote:
> In MD's resync I/O path, there are lots of direct access to bio's
> bvec table. This patchset kills most of them, and the conversion
> is quite straightforward.

I don't like this approach. The MD uses a hacky way to manage pages allocated,
this is the root of the problem. The patches add another hack way to do the
management. I'd like to see explict management of the pages, for example, add
data structure in r1bio to manage the pages, then we can use existing API for
all the stuffes we need.

Thanks,
Shaohua
