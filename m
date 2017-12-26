From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 04/78] page cache: Use xa_lock
Date: Tue, 26 Dec 2017 19:56:24 +0300
Message-ID: <20171226165624.vdarbqqx5czgeqxc@node.shutemov.name>
References: <20171215220450.7899-1-willy@infradead.org>
 <20171215220450.7899-5-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20171215220450.7899-5-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 15, 2017 at 02:03:36PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Remove the address_space ->tree_lock and use the xa_lock newly added to
> the radix_tree_root.  Rename the address_space ->page_tree to ->pages,
> since we don't really care that it's a tree.  Take the opportunity to
> rearrange the elements of address_space to pack them better on 64-bit,
> and make the comments more useful.

The description sounds a lot like three commits ;)

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
