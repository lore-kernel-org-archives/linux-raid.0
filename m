From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 010 of 14] Convert various kmap calls to kmap_atomic
Date: Thu, 1 Dec 2005 14:46:37 -0800
Message-ID: <20051201144637.289592c8.akpm@osdl.org>
References: <20051201141508.29384.patches@notabene>
	<1051201032339.29666@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051201032339.29666@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +				paddr = kmap_atomic(page, KM_USER0);
>  +				memset(paddr + offset, 0xff,
>   				       PAGE_SIZE - offset);

This page which is being altered is a user-visible one, no?  A pagecache
page?

We must always run flush_dcache_page() against a page when the kernel
modifies a user-visible page's contents.  Otherwise, on some architectures,
the modification won't be visible at the different virtual address.
