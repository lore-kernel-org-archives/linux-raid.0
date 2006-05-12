From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 002 of 8] md/bitmap: Remove bitmap writeback daemon.
Date: Fri, 12 May 2006 10:40:35 -0700
Message-ID: <20060512104035.5fee4e66.akpm@osdl.org>
References: <20060512160121.7872.patches@notabene>
	<1060512060736.8006@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060512060736.8006@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
>  ./drivers/md/bitmap.c         |  115 ++----------------------------------------

hmm.  I hope we're not doing any of that filesystem I/O within the context
of submit_bio() or kblockd or anything like that.  Looks OK from a quick
scan.

a_ops->commit_write() already ran set_page_dirty(), so you don't need that
in there.

I assume this always works in units of a complete page?  It's strange to do
prepare_write() followed immediately by commit_write().  Normally
prepare_write() will do some prereading, but it's smart enough to not do
that if the caller is preparing to write the whole page.

We normally use PAGE_CACHE_SIZE for these things, not PAGE_SIZE.  Same diff.

If you have a page and you want to write the whole thing out then there's
really no need to run prepare_write or commit_write at all.  Just
initialise the whole page, run set_page_dirty() then write_one_page().

Perhaps it should check that the backing filesystem actually implements
commit_write(), prepare_write(), readpage(), etc.  Some might not, and the
user will get taught not to do that via an oops.


