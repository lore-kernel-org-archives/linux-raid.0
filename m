From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 05/24] devtmpfs: open code ksys_chdir and ksys_chroot
Date: Tue, 21 Jul 2020 09:49:17 -0700
Message-ID: <CAHk-=wi0GQqAq6VSY=O2iWnPuuS54TkyRBH5B9Ca0Kg5A9d2aA@mail.gmail.com>
References: <20200721162818.197315-1-hch@lst.de> <20200721162818.197315-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200721162818.197315-6-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 9:28 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> +
> +       /* traverse into overmounted root and then chroot to it */
> +       if (!kern_path("/..", LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path) &&
> +           !inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR) &&
> +           ns_capable(current_user_ns(), CAP_SYS_CHROOT) &&
> +           !security_path_chroot(&path)) {
> +               set_fs_pwd(current->fs, &path);
> +               set_fs_root(current->fs, &path);
> +       }
> +       path_put(&path);

This looks wrong.

You're doing "path_put()" even if kern_path() didn't succeed.

As far as I can tell, that will either put some uninitialized garbage
and cause an oops, or put something that has already been released by
the failure path.

Maybe that doesn't happen in practice in this case, but it's still
very very wrong.

Plus you shouldn't have those kinds of insanely complex if-statements
in the first place. That was what caused the bug - trying to be
clever, instead of writing clear code.

I'm not liking how I'm finding fundamental mistakes in patches that
_should_ be trivial conversions with no semantic changes.

               Linus
