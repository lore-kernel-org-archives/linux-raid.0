From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Mon, 13 Feb 2017 08:37:24 +0100
Message-ID: <20170213073724.GA16666@lst.de>
References: <cover.1486485935.git.shli@fb.com> <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com> <87r336tw5l.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r336tw5l.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, khlebnikov@yandex-team.ru, hch@lst.de
List-Id: linux-raid.ids

On Fri, Feb 10, 2017 at 05:08:54PM +1100, NeilBrown wrote:
> I must say that I don't really like this approach.
> Temporarily modifying ->bi_private and ->bi_end_io seems
> .... intrusive.   I suspect it works, but I wonder if it is really
> robust in the long term.
> 
> How about a different approach..  Your main concern with my first patch
> was that it called md_write_start() and md_write_end() much more often,
> and these performed atomic ops on "global" variables, particular
> writes_pending.
> 
> We could change writes_pending to a per-cpu array which we only count
> occasionally when needed.  As writes_pending is updated often and
> checked rarely, a per-cpu array which is summed on demand seems
> appropriate.

FYI, I much prefer you original approach, it's much closer to how
the rest of the block stack works. 
