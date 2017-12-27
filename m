From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 05/78] xarray: Replace exceptional entries
Date: Tue, 26 Dec 2017 19:05:34 -0800
Message-ID: <20171227030534.GA24828@bombadil.infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-6-willy@infradead.org>
 <20171226171542.v25xieedd46y5peu@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171226171542.v25xieedd46y5peu-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Rehas Sachdeva <aquannie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Tue, Dec 26, 2017 at 08:15:42PM +0300, Kirill A. Shutemov wrote:
> >  28 files changed, 249 insertions(+), 240 deletions(-)
> 
> Everything looks fine to me after quick scan, but hat's a lot of changes for
> one patch...

Yeah.  It's pretty mechanical though.

> > -			if (radix_tree_exceptional_entry(page)) {
> > +			if (xa_is_value(page)) {
> >  				if (!invalidate_exceptional_entry2(mapping,
> >  								   index, page))
> >  					ret = -EBUSY;
> 
> invalidate_exceptional_entry? Are we going to leave the terminology here as is?

That is a great question.  If the page cache wants to call its value
entries exceptional entries, it can continue to do that.  I think there's
a better name for them, but I'm not sure what it is.  Right now, the
page cache uses value entries to store:

1. Shadow entries (for workingset)
2. Swap entries (for shmem)
3. DAX entries

I can't come up with a good name for these three things.  'nonpage' is
the only thing which hasn't immediately fallen off my ideas list.  But
I think renaming exceptional entries in the page cache is a great idea,
and I don't want to do it as part of this patch set ;-)
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
