From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v4
Date: Fri, 31 Jul 2020 08:33:16 +0200
Message-ID: <20200731063316.GA5145@lst.de>
References: <20200728163416.556521-1-hch@lst.de> <20200729195117.GE951209@ZenIV.linux.org.uk> <20200730062524.GA17980@lst.de> <20200731021424.GG1236603@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200731021424.GG1236603-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Fri, Jul 31, 2020 at 03:14:24AM +0100, Al Viro wrote:
> Christoph Hellwig (28):
> [snip]
>       initramfs: switch initramfs unpacking to struct file based APIs
>       initramfs: switch initramfs unpacking to struct file based APIs
> [snip]
> 
> It's not a bisect hazard, of course, but if you don't fold those
> together, you might at least want to give the second one a different
> commit summary...  I hadn't been able to find an analogue of #init_path on
> top of that either.
> 
> As it is, #init-user-pointers is fine (aside of that SNAFU with unfolded
> pair of commits), and so's the contents of #init_path part following what
> used to be #init-user-pointers, but it'll be an awful mess on merge in
> the current shape.
> 
> I can sort it out myself, if you don't mind that; again, I'm OK with
> the contents and I've no problem with doing reordering/folding.

I've fixed the folding issues in init-user-pointers and rebased init_path
on top of that.  Feel free to pull it.  I don't think it is worth
reposting.
