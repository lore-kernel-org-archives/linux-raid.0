From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Mon, 12 Dec 2016 14:10:54 +0100
Message-ID: <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com>
 <87a8c20xpg.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8c20xpg.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

On Mon, Dec 12, 2016 at 1:59 AM, NeilBrown <neilb@suse.com> wrote:
> On Sat, Nov 26 2016, Jinpu Wang wrote:
>> [  810.270860]  [<ffffffff813fc851>] blk_prologue_bio+0x91/0xc0
>
> What is this?  I cannot find that function in the upstream kernel.
>
> NeilBrown

Hi Neil,

blk_prologue_bio is our internal extension to gather some stats, sorry
not informed before.

It does below, code snip only:
+static void bio_endio_complete_diskstat(struct bio *clone)
+{
+       struct bio *bio =3D clone->bi_private;
+       struct block_device *bdev =3D bio->bi_bdev;
+       struct hd_struct *hdp =3D bdev->bd_part;
+       unsigned long start =3D clone->bi_start_time;
+       const int rw =3D !!bio_data_dir(bio);
+       int cpu, err =3D clone->bi_error;
+
+       bio_put(clone);
+       blk_end_io_acct()
+       bio->bi_error =3D err;
+       bio_endio(bio);
+}
+
+blk_qc_t blk_prologue_bio(struct request_queue *q, struct bio *bio)
+{
+       struct block_device *bdev =3D bio->bi_bdev;
+       struct hd_struct *hdp =3D bdev->bd_part;
+       struct bio *clone;
+
+       if (!hdp->additional_diskstat)
+               return q->custom_make_request_fn(q, bio);
+       clone =3D bio_clone_fast(bio, GFP_NOWAIT | __GFP_NOWARN, NULL);
+       if (unlikely(!clone))
+               return q->custom_make_request_fn(q, bio);
+       clone->bi_start_time =3D jiffies;
+       if (hdp->bio_mode_diskstat) {
+               int rw =3D !!bio_data_dir(bio);
+
+               generic_start_io_acct(rw, bio_sectors(clone), hdp);
+       }
+       clone->bi_end_io =3D bio_endio_complete_diskstat;
+       clone->bi_private =3D bio;
+       return q->custom_make_request_fn(q, clone);
+}

=EF=BC=A9=EF=BC=AD=EF=BC=A8=EF=BC=AF=EF=BC=8C it seems unrelated, but I wil=
l rerun my test without this change.

--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss
