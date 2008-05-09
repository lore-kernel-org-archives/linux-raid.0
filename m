From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Fri, 9 May 2008 11:00:47 -0400
Message-ID: <170fa0d20805090800p45654901p36eea51e1ea7e9c7@mail.gmail.com>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18464.134.236488.251879@notabene.brown>
	 <170fa0d20805060458i43c9a4a7r1e30147bdcd40f20@mail.gmail.com>
	 <18466.39418.578722.92979@notabene.brown>
	 <170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	 <18467.43895.220708.254814@notabene.brown>
	 <170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	 <18467.59565.676987.926988@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18467.59565.676987.926988@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Fri, May 9, 2008 at 2:01 AM, Neil Brown <neilb@suse.de> wrote:
>
> On Friday May 9, snitzer@gmail.com wrote:

>  > Unfortunately my testing with this patch results in a full resync.
>  >
>  > Here is the state of the array after shutdown:
>  > # mdadm -X /dev/nbd0 /dev/sdq
>  >         Filename : /dev/nbd0
>  >            Magic : 6d746962
>  >          Version : 4
>  >             UUID : 7140cc3c:8681416c:12c5668a:984ca55d
>  >           Events : 896
>  >   Events Cleared : 897
>
>  Events Cleared is *larger* than Events!!! Is that repeatable?  I can
>  only see it happening if a very small race were lost.  You don't have
>  any other patches in there do you?

Yes, it is repeatable with your previous patch.  But with your most
recent patch I had the following after shutdown:

# mdadm -X /dev/nbd0 /dev/sdq
        Filename : /dev/nbd0
          Events : 1732
  Events Cleared : 1732
          Bitmap : 409600 bits (chunks), 1 dirty (0.0%)

        Filename : /dev/sdq
          Events : 1736
  Events Cleared : 1736
          Bitmap : 409600 bits (chunks), 1 dirty (0.0%)

Unfortunately sdq's events_cleared appears to have been updated
_after_ the array became degraded.
As such a full resync occurred because 1732 < 1736.

>  This patch should close the race, though I still find it hard to
>  believe that you lost the race.

Comments inlined below.

>  Signed-off-by: Neil Brown <neilb@suse.de>
>
>  ### Diffstat output
>   ./drivers/md/bitmap.c |   20 +++++++++++++++-----
>   1 file changed, 15 insertions(+), 5 deletions(-)
>
>
>  diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
>  --- .prev/drivers/md/bitmap.c   2008-05-09 11:02:13.000000000 +1000
>  +++ ./drivers/md/bitmap.c       2008-05-09 16:00:07.000000000 +1000
>
> @@ -465,8 +465,6 @@ void bitmap_update_sb(struct bitmap *bit
>         spin_unlock_irqrestore(&bitmap->lock, flags);
>         sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
>         sb->events = cpu_to_le64(bitmap->mddev->events);
>  -       if (!bitmap->mddev->degraded)
>  -               sb->events_cleared = cpu_to_le64(bitmap->mddev->events);

Before, events_cleared was _not_ updated if the array was degraded.
Your patch doesn't appear to maintain that design.

I tried adding the following degraded check to your below conditional
but that resulted in nbd0's events < mddev->bitmap->events_cleared
again, so I'm back to square one:

                        if (!bitmap->mddev->degraded &&
                            bitmap->events_cleared < bitmap->mddev->events) {

In addition no bits were set in sdq's bitmap:
# mdadm -X /dev/nbd0 /dev/sdq
        Filename : /dev/nbd0
          Events : 2616
  Events Cleared : 2617
          Bitmap : 409600 bits (chunks), 0 dirty (0.0%)

        Filename : /dev/sdq
          Events : 2618
  Events Cleared : 2617
          Bitmap : 409600 bits (chunks), 0 dirty (0.0%)

>  @@ -1094,9 +1092,21 @@ void bitmap_daemon_work(struct bitmap *b
>
>                         } else
>                                 spin_unlock_irqrestore(&bitmap->lock, flags);
>                         lastpage = page;
>  -/*
>  -                       printk("bitmap clean at page %lu\n", j);
>  -*/
>  +
>  +                       /* We are possibly going to clear some bits, so make
>  +                        * sure that events_cleared is up-to-date.
>  +                        */
>  +                       if (bitmap->events_cleared < bitmap->mddev->events) {
>  +                               bitmap_super_t *sb;
>  +                               bitmap->events_cleared = bitmap->mddev->events;
>  +                               wait_event(mddev->sb_wait,
>  +                                   !test_bit(MD_CHANGE_CLEAN, &mddev->flags));

I needed "bitmap->mddev->sb_wait" and "bitmap->mddev->flags" to get
the code to compile.

Mike
