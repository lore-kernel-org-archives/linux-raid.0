From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] md: stop using do_sync_mapping_range
Date: Sat, 26 Sep 2009 17:13:54 +0200
Message-ID: <20090926151354.GD11623@lst.de>
References: <20090923131822.GA12287@lst.de> <19130.42676.5539.459956@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19130.42676.5539.459956@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 24, 2009 at 08:52:36AM +1000, Neil Brown wrote:
> On Wednesday September 23, hch@lst.de wrote:
> > It's a very awkward way to write out all data and wait for it, so just
> > call filemap_write_and_wait.  I still can't figure what the point of
> > all this is, so a comment would surely be helpful.
> 
> When md/bitmap accesses a file, it uses bmap to find addresses and then
> submit_bh to do IO, so it completely by-passes the page cache.
> So this code is present to ensure that the page cache has no dirty
> pages for the file before we start using the file.
> 
> I don't recall exactly why I used do_sync_mapping_range.  I suspect
> that I looked at what "sys_fsync" used (do_fsync?) and found that
> wasn't exported, so I looked at what sys_sync_file_range used, found
> that was exported, and so used that.
> 
> Looking at the current state of the VFS, I think I would rather use
> vfs_fsync.

Using vfs_fsync is better, but using bmap is extremly dangerous, I'm
kinda suprised how this managed to get sneaked in without notice.  bmap
really is just an advisory interface as the mappings by change
underneath all the time.  Some modern filesystems like btrfs really
can't implement it at all.


> So would you be happy with something like the following?

It's at least a small improvement..

