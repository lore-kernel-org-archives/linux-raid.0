From: Neil Brown <neilb@suse.de>
Subject: Re: weird issues with raid1
Date: Thu, 18 Dec 2008 17:21:16 +1100
Message-ID: <18761.60380.938542.26851@notabene.brown>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	<18757.62097.166706.244330@notabene.brown>
	<cccedfc60812150542y5607d168q94c09d8dc3438226@mail.gmail.com>
	<18758.52536.345145.238926@notabene.brown>
	<cccedfc60812151347j659112c5na3aa8cd0eb044669@mail.gmail.com>
	<18759.678.74091.236787@notabene.brown>
	<18761.54425.725696.255055@notabene.brown>
	<cccedfc60812172050h58697665y975a18550842aebb@mail.gmail.com>
	<cccedfc60812172055n58181ad4lcdff8f172c6a496c@mail.gmail.com>
	<18761.56537.935250.561921@notabene.brown>
	<cccedfc60812172147q240466a8w53c5bd2540edf6a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Wednesday December 17
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday December 17, jnelson-linux-raid@jamponi.net wrote:
> On Wed, Dec 17, 2008 at 11:17 PM, Neil Brown <neilb@suse.de> wrote:
> > On Wednesday December 17, jnelson-linux-raid@jamponi.net wrote:
> >> >
> >> >> It could be that you are hitting the bug fixed by
> >> >>  commit a0da84f35b25875870270d16b6eccda4884d61a7
> >> >
> >> > That sure sounds like it. I'd have to log to see what happened,
> >> > exactly, but I've added substantial logging around the device
> >> > discovery and addition section which manages this particular raid.
> >> >
> >> >> You would need 2.6.26 or later to have that fixed.
> >> >> Can you try with a newer kernel???
> >> >
> >> > I hope to be giving opensuse 11.1 a try soon, which uses 2.6.27.X
> >> > afaik.  I suspect I can also backport that patch to 2.6.25 easily.
> >>
> >> The kernel source for 2.6.25.18-0.2 (from suse) has this patch
> >> already, so I was already using it.
> >
> > Are you sure?  I just looked in the openSUSE-11.0 kernel tree and I
> > cannot see it there....
> >
> > NeilBrown
> >
> >
> >>
> >> Perhaps this weekend or some night this week I'll find time to try to
> >> break things again.
> >>
> >> --
> >> Jon
> >
> 
> jnelson@turnip:~/kernels> rpm -qf /usr/src/linux-2.6.25.18-0.2
> kernel-source-2.6.25.18-0.2
> jnelson@turnip:~/kernels> rpm -V kernel-source-2.6.25.18-0.2
> jnelson@turnip:~/kernels> (cd linux-2.6 && git diff
> a0da84f35b25875870270d16b6eccda4884d61a7
> a0da84f35b25875870270d16b6eccda4884d61a7^ ) > d.diff

This is requesting the diff between a given version, and the previous
version.  So it will be a reversed diff.

> jnelson@turnip:~/kernels> head d.diff
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index dedba16..b26927c 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -454,11 +454,8 @@ void bitmap_update_sb(struct bitmap *bitmap)
>         spin_unlock_irqrestore(&bitmap->lock, flags);
>         sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
>         sb->events = cpu_to_le64(bitmap->mddev->events);
> -       if (bitmap->mddev->events < bitmap->events_cleared) {
> -               /* rocking back to read-only */

i.e. these two lines are *added* by the patch.
I usually use e.g.
   git log -p a0da84f35b25875870270d16b6eccda4884d61a7
to look at diffs.  Less room for confusion. (or gitk).

> jnelson@turnip:~/kernels> cp -r /usr/src/linux-2.6.25.18-0.2 .
> jnelson@turnip:~/kernels/linux-2.6.25.18-0.2> tail -n +454
> drivers/md/bitmap.c | head -n 20
> {
>         bitmap_super_t *sb;
>         unsigned long flags;
> 
>         if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
>                 return;
>         spin_lock_irqsave(&bitmap->lock, flags);
>         if (!bitmap->sb_page) { /* no superblock */
>                 spin_unlock_irqrestore(&bitmap->lock, flags);
>                 return;
>         }
>         spin_unlock_irqrestore(&bitmap->lock, flags);
>         sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
>         sb->events = cpu_to_le64(bitmap->mddev->events);
>         if (!bitmap->mddev->degraded)
>                 sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
>         kunmap_atomic(sb, KM_USER0);
>         write_page(bitmap, bitmap->sb_page, 1);
> }

and as those two lines are not present here, the patch as not been
applied. 
:-)

NeilBrown
