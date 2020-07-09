From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 15/17] initramfs: switch initramfs unpacking to struct
 file based APIs
Date: Thu, 9 Jul 2020 11:23:03 -0700
Message-ID: <CAHk-=wgXtjWb_sVfaSGTaCToHZmxRs4EHpQ1ck=6B=zGTLuQdQ@mail.gmail.com>
References: <20200709151814.110422-1-hch@lst.de> <20200709151814.110422-16-hch@lst.de>
 <CAHk-=whXq_149rcDv9ENkKeKpcEQ93MAvcmAOAbU8=bWG55X2A@mail.gmail.com> <20200709181227.GA20954@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200709181227.GA20954@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 9, 2020 at 11:12 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Jul 09, 2020 at 11:07:08AM -0700, Linus Torvalds wrote:
> > On Thu, Jul 9, 2020 at 8:18 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > There is no good reason to mess with file descriptors from in-kernel
> > > code, switch the initramfs unpacking to struct file based write
> > > instead.  As we don't have nice helper for chmod or chown on a struct
> > > file or struct path use the pathname based ones instead there.  This
> > > causes additional (cached) lookups, but keeps the code much simpler.
> >
> > This is the only one I'm not a huge fan of.
> >
> > I agree about moving to 'struct file'. But then you could just do the
> > chown/chmod using chown/chmod_common() on file->f_path.
> >
> > That would keep the same semantics, and it feels like a more
> > straightforward patch.
> >
> > It would still remove the nasty ksys_fchmod/fchmod, it would just
> > require our - already existing - *_common() functions to be non-static
> > (and maybe renamed to "vfs_chown/chmod()" instead, that "*_common()"
> > naming looks a bit odd compared to all our other "vfs_operation()"
> > helpers).
>
> Sure, we can do that.  It requires a little more boilerplate that I
> thought we could just skip.

Yeah, it makes the patch perhaps a bit larger (or rather, it adds one
new patch to do that "introduce new names for *_common() and add them
to the headers"), but just looking at your current patch:

+                       ksys_chown(collected, uid, gid);
+                       ksys_chmod(collected, mode);
+                       if (body_len)
+                               vfs_truncate(&wfile->f_path, body_len);

and I go "wouldn't that look a _lot_ more regular something like this":

+                       vfs_chown(&wfile->f_path, uid, gid);
+                       vfs_chmod(&wfile->f_path, mode);
+                       if (body_len)
+                               vfs_truncate(&wfile->f_path, body_len);

so I think that I'd prefer it simply because it makes all our
interfaces much more natural.

I note that we still need that ksys_chown() because of disgusting
issues with the legacy 16-bit uid support. Which is likely not used
any more now that a.out support is gone (well, alpha and m68k still
define HAVE_AOUT, so it's not "gone" gone, but it's gone).

I can't imagine that anybody would have ELF and 16-bit uid's.

Except users are crazy. So who knows. But it might definitely be time
to deprecate UID16.

That's a separate issue, though, it just came up because of that ksys_chown().

                Linus
