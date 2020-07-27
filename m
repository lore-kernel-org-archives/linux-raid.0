From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 18/23] init: open code setting up stdin/stdout/stderr
Date: Mon, 27 Jul 2020 08:49:57 +0200
Message-ID: <20200727064957.GB2317@lst.de>
References: <20200714190427.4332-1-hch@lst.de> <20200714190427.4332-19-hch@lst.de> <20200727030534.GD795125@ZenIV.linux.org.uk> <F3DAF5DA-82C2-4833-805D-4F54F7C4326E@zytor.com> <20200727062425.GA2005@lst.de> <366377E2-6F19-45E1-9285-CFA5E660C6B5@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <366377E2-6F19-45E1-9285-CFA5E660C6B5@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: hpa@zytor.com
Cc: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 26, 2020 at 11:36:15PM -0700, hpa@zytor.com wrote:
> >Err, why?  The changes have been pretty simple, and I'd rather not come
> >up with new crazy ways just to make things complicated.
> 
> Why? To avoid this neverending avalanche of special interfaces and layering violations. Neatly deals with non-contiguous contents and initramfs in device memory, etc. etc. etc.

I don't think it will be all that simple.  But given that linux-next
is just missing one series Al was already ok with to kill off set_fs
entirely for about half of our architectures I'd rather go ahead with
this series.  If you can send a series mapping user memory that actually
cleans things up on top of it I'm not going to complain, but I'm not
sure it really is going to be all that much cleaner.
