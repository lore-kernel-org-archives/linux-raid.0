From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 14 Mar 2005 15:43:52 +1100
Message-ID: <16949.5768.392061.95882@cse.unsw.edu.au>
References: <422F7621.8090602@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Paul Clements on Wednesday March 9
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 9, paul.clements@steeleye.com wrote:
> Neil,
> 
> here are a couple of patches -- this one for the kernel, the next for 
> mdadm. They fix a few issues that I found while testing the new bitmap 
> intent logging code.
> 
> Briefly, the issues were:
> 
> kernel:
> 
> added call to bitmap_daemon_work() from raid1d so that the bitmap would 
> actually get cleared

Yes... well... uhmm...  how did I miss that??
I would actually rather call it from md_check_recovery (which is
called from raid1d).  I should rename md_check_recovery at some
stage as it does more than it's name says.

> 
> fixed the marking of pages with BITMAP_CLEAN so that the bitmap would 
> get cleared correctly after resync and normal write I/O

I don't agree with this bit.  The BITMAP_PAGE_CLEAN bit needs to be
cleared before processing it rather than after as the current code
does.  However I see that this causes it to ignore all but the first
bit of the page, so I have fixed that with:

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-14 11:51:29.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-14 12:54:02.000000000 +1100
@@ -940,6 +940,7 @@ int bitmap_daemon_work(struct bitmap *bi
 
 		page = filemap_get_page(bitmap, j);
 		/* skip this page unless it's marked as needing cleaning */
+		if (page != lastpage)
 		if (!((attr=get_page_attr(bitmap, page)) & BITMAP_PAGE_CLEAN)) {
 			if (attr & BITMAP_PAGE_NEEDWRITE) {
 				page_cache_get(page);

> 
> pass back errors from write_page() since it now does actual writes
> itself

Yep, thanks.

> 
> sync_size changed to sectors (was array_size which was KB) -- some 
> divisions by 2 were needed

Yes.

> 
> mdadm:
> 
> avoid setting of sb->events_lo = 1 when creating a 0.90 superblock -- it 
> doesn't seem to be necessary and it was causing the event counters to 
> start at 4 billion+ (events_lo is actually the high part of the events 
> counter, on little endian machines anyway)

events_lo really should be the low part of the counter and it is for
me....  something funny must be happening for you...

> 
> some sync_size changes, as in the kernel

Yep.

> 
> if'ed out super1 definition which is now in the kernel headers

I don't like this.  I don't mdadm to include the kernel raid headers.
I want it to use it's own. 

> 
> included sys/time.h to avoid compile error

I wonder why I don't get an error.. What error do you get?

NeilBrown
