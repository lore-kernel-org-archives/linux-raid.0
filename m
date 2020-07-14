From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 17/23] initramfs: switch initramfs unpacking to struct
 file based APIs
Date: Tue, 14 Jul 2020 12:31:01 -0700
Message-ID: <CAHk-=whDbHL7x5Jx-CSz97=nVg4V_q45DsokX+X-Y-yZV4rPvw@mail.gmail.com>
References: <20200714190427.4332-1-hch@lst.de> <20200714190427.4332-18-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-18-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 14, 2020 at 12:09 PM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no good reason to mess with file descriptors from in-kernel
> code, switch the initramfs unpacking to struct file based write
> instead.

Looking at this diff, I realized this really should be cleaned up more.

 +                       wfile = filp_open(collected, openflags, mode);
> +                       if (IS_ERR(wfile))
> +                               return 0;
> +
> +                       vfs_fchown(wfile, uid, gid);
> +                       vfs_fchmod(wfile, mode);
> +                       if (body_len)
> +                               vfs_truncate(&wfile->f_path, body_len);
> +                       vcollected = kstrdup(collected, GFP_KERNEL);

That "vcollected" is ugly and broken, and seems oh-so-wrong.

Because it's only use is:


> -               ksys_close(wfd);
> +               fput(wfile);
>                 do_utime(vcollected, mtime);
>                 kfree(vcollected);

which should just have done the exact same thing that you did with
vfs_chown() and friends: we already have a "utimes_common()" that
takes a path, and it could have been made into "vfs_utimes()", and
then this whole vcollected confusion would go away and be replaced by

        vfs_truncate(&wfile->f_path, mtime);

(ok, with all the "timespec64 t[2]" things going on that do_utime()
does now, but you get the idea).

Talk about de-crufting that initramfs unpacking..

But I don't hate this patch, I'm just pointing out that there's room
for improvement.

             Linus
