From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs: buffer: Modify alloc_page_buffers.
Date: Mon, 19 Jun 2017 17:03:16 +0100
Message-ID: <20170619160315.GD10672@ZenIV.linux.org.uk>
References: <1497877296-22441-1-git-send-email-fxinrong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1497877296-22441-1-git-send-email-fxinrong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sean Fu <fxinrong@gmail.com>
Cc: shli@kernel.org, anton@tuxera.com, jack@suse.cz, axboe@fb.com, ebiggers@google.com, rpeterso@redhat.com, bmarzins@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
List-Id: linux-raid.ids

On Mon, Jun 19, 2017 at 09:01:36PM +0800, Sean Fu wrote:
> Make alloc_page_buffers support circular buffer list and initialise
> b_state field.
> Optimize the performance by removing the buffer list traversal to create
> circular buffer list.

> -		bh = head = alloc_page_buffers(page, blocksize, 1);
> +		bh = head = alloc_page_buffers(page, blocksize, 1, 0, 0);

Frankly, I don't like that change of calling conventions; it's very easy to
mess the order of arguments when using interfaces like that and it's hell
to find when trying to debug the resulting mess.

Do you really get an observable change in performance?  What loads are
triggering it?
