From: Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 16/17] init: open code setting up stdin/stdout/stderr
Date: Thu, 9 Jul 2020 14:32:54 -0400
Message-ID: <CAMzpN2gn_5bXt3RNOwvCSAo+79FevWgMYROxbdFAd1mzo9EOhQ@mail.gmail.com>
References: <20200709151814.110422-1-hch@lst.de> <20200709151814.110422-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-17-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 9, 2020 at 11:19 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Don't rely on the implicit set_fs(KERNEL_DS) for ksys_open to work, but
> instead open a struct file for /dev/console and then install it as FD
> 0/1/2 manually.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/file.c                |  7 +------
>  include/linux/syscalls.h |  1 -
>  init/main.c              | 16 ++++++++++------
>  3 files changed, 11 insertions(+), 13 deletions(-)
>
> diff --git a/fs/file.c b/fs/file.c
> index abb8b7081d7a44..85b7993165dd2f 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -985,7 +985,7 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
>         return ksys_dup3(oldfd, newfd, 0);
>  }
>
> -int ksys_dup(unsigned int fildes)
> +SYSCALL_DEFINE1(dup, unsigned int, fildes)
>  {
>         int ret = -EBADF;
>         struct file *file = fget_raw(fildes);
> @@ -1000,11 +1000,6 @@ int ksys_dup(unsigned int fildes)
>         return ret;
>  }
>
> -SYSCALL_DEFINE1(dup, unsigned int, fildes)
> -{
> -       return ksys_dup(fildes);
> -}
> -

Please split the removal of the now unused ksys_*() functions into a
separate patch.

--
Brian Gerst
