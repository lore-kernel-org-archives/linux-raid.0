From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: [md PATCH 00/24] Allow bitmaps to be resized.
Date: Wed, 18 Apr 2012 10:07:37 +0800
Message-ID: <CA+res+S-pvi11i_JH=O2dDGMc3n2wErwpMaWoW3KKFsAHVMN3Q@mail.gmail.com>
References: <20120417084324.6433.68345.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417084324.6433.68345.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

Thanks for your good works.
One query about current grow supporting  status:

as the raid wiki show : the RAID level 1/4/5/6 array can be grown . In
my test I can grow raid 1 add disk or remove disk through mdadm grow,
but change level from 1 to 4 or 5 will fail. the simaliar command work
for change level between 4/5/6, change 1 to 10 fail too.

My kernel version is 3.2.15. mdadm version 3.2.3.


Jack

2012/4/17 NeilBrown <neilb@suse.de>:
>
> The following series has just been added to my for-next queue
> and so should be in 3.5.
> =C2=A0git://neil.brown.name/md for-next
> =C2=A0git://github.com/neilbrown/linux.git md/for-next
>
> It allows md to resize a bitmap on an active array. =C2=A0This
> means that arrays can now be reshaped without first removing the
> bitmap. =C2=A0The bitmap is resized in-place.
>
> As always: review and testing would be greatly appreciated.
>
> NeilBrown
>
> ---
>
> NeilBrown (24):
> =C2=A0 =C2=A0 =C2=A0md/raid5: Allow reshape while a bitmap is present=
=2E
> =C2=A0 =C2=A0 =C2=A0md/raid10: resize bitmap when required during res=
hape.
> =C2=A0 =C2=A0 =C2=A0md: allow array to be resized while bitmap is pre=
sent.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: make sure reshape request are reflecte=
d in superblock.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: add bitmap_resize function to allow bi=
tmap resizing.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: use DIV_ROUND_UP instead of open-code
> =C2=A0 =C2=A0 =C2=A0md/bitmap: create a 'struct bitmap_counts' substr=
ucture of 'struct bitmap'
> =C2=A0 =C2=A0 =C2=A0md/bitmap: make bitmap bitops atomic.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: make _page_attr bitops atomic.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: merge bitmap_file_unmap and bitmap_fil=
e_put.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: remove async freeing of bitmap file.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: convert some spin_lock_irqsave to spin=
_lock_irq
> =C2=A0 =C2=A0 =C2=A0md/bitmap: use set_bit, test_bit, etc for operati=
on on bitmap->flags.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: remove single-bit manipulation on sb->=
state
> =C2=A0 =C2=A0 =C2=A0md/bitmap: remove bitmap_mask_state
> =C2=A0 =C2=A0 =C2=A0md/bitmap: move storage allocation from bitmap_lo=
ad to bitmap_create.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: separate bitmap file allocation to its=
 own function.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: store bytes in file rather than just i=
n last page.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: move some fields of 'struct bitmap' in=
to a 'storage' substruct.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: change *_page_attr() to take a page nu=
mber, not a page.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: centralise allocation of bitmap file p=
ages.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: allow a bitmap with no backing storage=
=2E
> =C2=A0 =C2=A0 =C2=A0md/bitmap: add new 'space' attribute for bitmaps.
> =C2=A0 =C2=A0 =C2=A0md/bitmap: disentangle two different 'pending' fl=
ags.
>
>
> =C2=A0drivers/md/bitmap.c | 1089 +++++++++++++++++++++++++++++-------=
---------------
> =C2=A0drivers/md/bitmap.h | =C2=A0 58 ++-
> =C2=A0drivers/md/md.c =C2=A0 =C2=A0 | =C2=A0 53 ++
> =C2=A0drivers/md/md.h =C2=A0 =C2=A0 | =C2=A0 =C2=A03
> =C2=A0drivers/md/raid1.c =C2=A0| =C2=A0 11 -
> =C2=A0drivers/md/raid10.c | =C2=A0 47 +-
> =C2=A0drivers/md/raid5.c =C2=A0| =C2=A0 20 +
> =C2=A07 files changed, 754 insertions(+), 527 deletions(-)
>
> --
> Signature
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
