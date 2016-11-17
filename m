From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [md PATCH 2/4] md: add bio completion tracing for raid1/raid10
Date: Thu, 17 Nov 2016 04:51:31 -0800
Message-ID: <20161117125131.GC14814@infradead.org>
References: <147910131504.27168.6566119701315109161.stgit@noble>
 <147910142112.27168.16834874155342134173.stgit@noble>
 <20161116143233.GA28615@infradead.org>
 <87r36ahdn0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r36ahdn0.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 17, 2016 at 04:35:47PM +1100, NeilBrown wrote:
> Oh good, thanks for letting me know. I'll drop that one.
> Do you know if there is any plan to include trace_block_split() in
> bio_split()??

Not that I know off.  But doing so seems sensible, and I'm pretty
sure patches would be welcome.
