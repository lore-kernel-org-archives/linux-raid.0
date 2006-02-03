From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: raid 4, and bitmap.
Date: Fri, 3 Feb 2006 01:31:59 +0100
Message-ID: <04f401c62859$407f6910$9d00a8c0@dcccs>
References: <04c201c62855$5efda450$9d00a8c0@dcccs><17378.40767.339455.85486@cse.unsw.edu.au><04d701c62857$9eb02e90$9d00a8c0@dcccs> <17378.41629.709430.775224@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linix-raid@vger.kernel.org>
Sent: Friday, February 03, 2006 1:23 AM
Subject: Re: raid 4, and bitmap.


> On Friday February 3, djani22@dynamicweb.hu wrote:
> > >
> > > If it is an internal bitmap.... it should work.
> > > Are there any kernel messages during boot that might be interesting?
> >
> > Sorry, i did not log this, and i dont want to restart the sync and
system
> > for this.
> > Anyway, i add back the bitmap, and the next crash we will see....
> >
> > I mean this was:
> > "bitmap is only support in raid1.
> > bitmap is removed."
> >
> > But not so sure. :(
>
> Close enough.  Here is the fix.

Thanks!

This was fast! :)

Ahh, i almost forget!
The mdadm is sometimes drop "cannot allocate memory" and next try "segfault"
when i try -G --bitmap=internal on 2TB arrays!
And after segfault, the full raid is stops...

Cheers,
Janos

>
> NeilBrown
>
> Signed-off-by: Neil Brown <neilb@suse.de>
>
> ### Diffstat output
>  ./drivers/md/md.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> --- ./drivers/md/md.c~current~ 2006-02-03 08:57:28.000000000 +1100
> +++ ./drivers/md/md.c 2006-02-03 11:22:57.000000000 +1100
> @@ -763,7 +763,8 @@ static int super_90_validate(mddev_t *md
>
>   if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
>       mddev->bitmap_file == NULL) {
> - if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6
> + if (mddev->level != 1 && && mddev->level != 4
> +     && mddev->level != 5 && mddev->level != 6
>       && mddev->level != 10) {
>   /* FIXME use a better test */
>   printk(KERN_WARNING "md: bitmaps not supported for this level.\n");

