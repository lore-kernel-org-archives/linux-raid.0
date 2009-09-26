From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] md: stop using do_sync_mapping_range
Date: Sat, 26 Sep 2009 17:11:19 +0200
Message-ID: <20090926151119.GC11623@lst.de>
References: <20090923131822.GA12287@lst.de> <20090923134715.GA15256@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090923134715.GA15256@shareable.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@lst.de>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 23, 2009 at 02:47:15PM +0100, Jamie Lokier wrote:
> Christoph Hellwig wrote:
> > -		do_sync_mapping_range(file->f_mapping, 0, LLONG_MAX,
> > -				      SYNC_FILE_RANGE_WAIT_BEFORE |
> > -				      SYNC_FILE_RANGE_WRITE |
> > -				      SYNC_FILE_RANGE_WAIT_AFTER);
> > +		filemap_write_and_wait(file->f_mapping);
> >
> > It's a very awkward way to write out all data and wait for it, so just
> > call filemap_write_and_wait.  I still can't figure what the point of
> > all this is, so a comment would surely be helpful.
> 
> The SYNC_FILE_RANGE_WAIT_BEFORE is to make sure that writes which were
> started before the most recent dirtying are completed before
> initiating a second write on the same pages to make sure the most
> recently dirty data is written.
> 
> Does filemap_write_and_wait() do that?

Yes, for WB_SYNC_ALL syncs write_cache_pages or the fs-specific
equivalent waits for pages marked writeback before starting starting
the writeout.
