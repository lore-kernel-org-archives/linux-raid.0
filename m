From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [md PATCH 2/4] md: add bio completion tracing for raid1/raid10
Date: Wed, 16 Nov 2016 06:32:33 -0800
Message-ID: <20161116143233.GA28615@infradead.org>
References: <147910131504.27168.6566119701315109161.stgit@noble>
 <147910142112.27168.16834874155342134173.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147910142112.27168.16834874155342134173.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 14, 2016 at 04:30:21PM +1100, NeilBrown wrote:
> raid5 already has this, as does dm.
> linear and raid0 do no see completions, only bio_chain_end() or bio_endio()
> see those.
> So just add it for raid1 and raid10.
> 
> Between
>  Commit: 3a366e614d08 ("block: add missing block_bio_complete() tracepoint")
> and
>  Commit: 0a82a8d132b2 ("Revert "block: add missing block_bio_complete() tracepoint"")
> in the 3.9-rc series, this was done centrally in bio_endio().
> Until/unless that is resurected, do the tracing in the md/raid code.

We're working on getting it back for 4.10, so please don't add these
tracepoints to the MD driver for now.  Next time please also ask
linux-block first and/or Cc the list on a patch like this.
