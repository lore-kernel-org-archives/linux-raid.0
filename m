From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH V2 1/9] include/linux/pagemap.h: introduce
 attach/clear_page_private
Date: Thu, 30 Apr 2020 15:13:38 -0700
Message-ID: <20200430221338.GY29705@bombadil.infradead.org>
References: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
 <20200430214450.10662-2-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200430214450.10662-2-guoqing.jiang@cloud.ionos.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, david@fromorbit.com, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, William Kucharski <william.kucharski@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andreas Gruenbacher <agruenba@redhat.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, Anton
List-Id: linux-raid.ids

On Thu, Apr 30, 2020 at 11:44:42PM +0200, Guoqing Jiang wrote:
> +/**
> + * attach_page_private - attach data to page's private field and set PG_private.
> + * @page: page to be attached and set flag.
> + * @data: data to attach to page's private field.
> + *
> + * Need to take reference as mm.h said "Setting PG_private should also increment
> + * the refcount".
> + */

I don't think this will read well when added to the API documentation.
Try this:

/**
 * attach_page_private - Attach private data to a page.
 * @page: Page to attach data to.
 * @data: Data to attach to page.
 *
 * Attaching private data to a page increments the page's reference count.
 * The data must be detached before the page will be freed.
 */

> +/**
> + * clear_page_private - clear page's private field and PG_private.
> + * @page: page to be cleared.
> + *
> + * The counterpart function of attach_page_private.
> + * Return: private data of page or NULL if page doesn't have private data.
> + */

Seems to me that the opposite of "attach" is "detach", not "clear".

/**
 * detach_page_private - Detach private data from a page.
 * @page: Page to detach data from.
 *
 * Removes the data that was previously attached to the page and decrements
 * the refcount on the page.
 *
 * Return: Data that was attached to the page.
 */
