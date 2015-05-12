From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] a caching layer for raid 5/6
Date: Tue, 12 May 2015 00:18:54 -0700
Message-ID: <20150512071854.GA16731@infradead.org>
References: <cover.1430954848.git.shli@fb.com>
 <20150511122347.GA5082@infradead.org>
 <20150511160349.GA545551@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150511160349.GA545551@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

On Mon, May 11, 2015 at 09:03:51AM -0700, Shaohua Li wrote:
> >   - What is the reason for retry_bio_list?  If a driver returns an
> >     I/O error to the higher levels it already has retried and came
> >     to the conclusion this is a permanent error.
> 
> The retry_bio_list is to handle io to cache disk. If IO to cache disk
> has error, it's not a permanent error here. The cache disk is a cache,
> We can still dispatch the IO to its final destination, the raid disks.

How does this work in practice?  We've filled our cache disk with
dirty data, and it now returns non-correctable write errors.  At this
point we had claimed to caller that data is on stable disk, but our
cache disk is toast now.  Is it really a good idea to now start a large
window where we do not actually have the cache data on stable storage
we can get back at but pretent business as usual?

IMHO the only sane way is to shut down the array when write to the cache
disk fail.  Hopefully the disk will still allow reading from it.  Note
that to be on the safe side you'll need a mirrored cache disk anyway.

