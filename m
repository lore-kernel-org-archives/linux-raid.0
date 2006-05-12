From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 008 of 8] md/bitmap: Change md/bitmap file handling to
 use bmap to file blocks.
Date: Fri, 12 May 2006 10:47:50 -0700
Message-ID: <20060512104750.0f5cb10a.akpm@osdl.org>
References: <20060512160121.7872.patches@notabene>
	<1060512060809.8099@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060512060809.8099@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> If md is asked to store a bitmap in a file, it tries to hold onto the
> page cache pages for that file, manipulate them directly, and call a
> cocktail of operations to write the file out.  I don't believe this is
> a supportable approach.

erk.  I think it's better than...

> This patch changes the approach to use the same approach as swap files.
> i.e. bmap is used to enumerate all the block address of parts of the file
> and we write directly to those blocks of the device.

That's going in at a much lower level.  Even swapfiles don't assume
buffer_heads.

When playing with bmap() one needs to be careful that nobody has truncated
the file on you, else you end up writing to disk blocks which aren't part
of the file any more.

All this (and a set_fs(KERNEL_DS), ug) looks like a step backwards to me. 
Operating at the pagecache a_ops level looked better, and more
filesystem-independent.

I haven't looked at this patch at all closely yet.  Do I really need to?
