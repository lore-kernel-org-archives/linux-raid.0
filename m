From: Song Liu <song@kernel.org>
Subject: Re: [PATCH 1/2] super1.0 calculates max sectors in a wrong way
Date: Tue, 28 Jul 2020 17:43:48 -0700
Message-ID: <CAPhsuW5RAEb7i-VQ+MS0XfGKNyd=2_=VoGVjk2SU6A30cW9PKg@mail.gmail.com>
References: <1593503737-5067-1-git-send-email-xni@redhat.com>
 <1593503737-5067-2-git-send-email-xni@redhat.com> <CAPhsuW7WY7kQ77BKBqev2CVFPS63C7u0HtBqkB49XtbRCysWmg@mail.gmail.com>
 <9626595c-cdd8-f46d-629e-67f9b11d2b6a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9626595c-cdd8-f46d-629e-67f9b11d2b6a@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>
List-Id: linux-raid.ids

On Mon, Jul 27, 2020 at 6:18 PM Xiao Ni <xni@redhat.com> wrote:
>
>
>
> On 07/28/2020 01:33 AM, Song Liu wrote:
> > On Tue, Jun 30, 2020 at 12:55 AM Xiao Ni <xni@redhat.com> wrote:
> >> One super1.0 raid array wants to grow size, it needs to check the device max usable
> >> size. If the requested size is bigger than max usable size, it will return an error.
> >>
> >> Now it uses rdev->sectors for max usable size. If one disk is 500G and the raid device
> >> only uses the 100GB of this disk. rdev->sectors can't tell the real max usable size.
> >> The max usable size should be dev_size-(superblock_size+bitmap_size+badblock_size).
> >>
> >> Signed-off-by: Xiao Ni <xni@redhat.com>
> > Thanks for the fix!
> >
> >> ---
> >>   drivers/md/md.c | 26 +++++++++++++++++++++++---
> >>   1 file changed, 23 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index f567f53..d2c5984 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -2183,10 +2183,30 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
> >>                  return 0;
> >>          } else {
> >>                  /* minor version 0; superblock after data */
> >> -               sector_t sb_start;
> >> -               sb_start = (i_size_read(rdev->bdev->bd_inode) >> 9) - 8*2;
> >> +               sector_t sb_start, bm_space;
> >> +               sector_t dev_size = i_size_read(rdev->bdev->bd_inode) >> 9;
> >> +
> >> +               /* 8K is for superblock */
> >> +               sb_start = dev_size - 8*2;
> >>                  sb_start &= ~(sector_t)(4*2 - 1);
> >> -               max_sectors = rdev->sectors + sb_start - rdev->sb_start;
> >> +
> >> +               /* if the device is bigger than 8Gig, save 64k for bitmap usage,
> >> +                * if bigger than 200Gig, save 128k
> >> +                */
> >> +               if (dev_size < 64*2)
> >> +                       bm_space = 0;
> >> +               else if (dev_size - 64*2 >= 200*1024*1024*2)
> >> +                       bm_space = 128*2;
> >> +               else if (dev_size - 4*2 > 8*1024*1024*2)
> >> +                       bm_space = 64*2;
> >> +               else
> >> +                       bm_space = 4*2;
> > Could you explain the handling of bitmap space?
> Hi Song
>
> This calculation of bitmap is decided by mdadm. In mdadm super1.c
> choose_bm_space function,
> it uses this way to calculate bitmap space. Do I need to add comments
> here to describe this?
> Something like "mdadm function choose_bm_space decides the bitmap space"?

Thanks for the explanation.

I merged the two patches, made some changes, and applied it to md-next. Please
let me know whether it looks good.

Song
