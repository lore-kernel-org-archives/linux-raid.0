From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH v2] block: make sure big bio is splitted into at most 256
 bvecs
Date: Fri, 12 Aug 2016 08:36:56 -0800
Message-ID: <20160812163656.GA13370@kmo-pixel>
References: <1459914212-9330-1-git-send-email-ming.lei@canonical.com>
 <alpine.LRH.2.11.1608102132120.10662@mail.ewheeler.net>
 <20160811140253.GA2867@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160811140253.GA2867@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Wheeler <bcache@lists.ewheeler.net>, Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Sebastian Roesner <sroesner-kernelorg@roesner-online.de>, "4.3+" <stable@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Thu, Aug 11, 2016 at 07:02:53AM -0700, Christoph Hellwig wrote:
> Please just fix bcache to not submit bios larger than BIO_MAX_PAGES for
> now, until we can support such callers in general and enable common
> used code to do so.

Christoph, what's wrong with Ming's patch? Leaving bcache aside, just
considering the block layer, do you think that patch is the wrong approach?
