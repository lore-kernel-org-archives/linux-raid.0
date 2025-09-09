Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EE724EF76
	for <linux-raid@vger.kernel.org>; Tue,  9 Sep 2025 08:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757407227; cv=none; b=n6ab2XC1WgJpBrXKB+5tLLmNmefX+T7vvi5zaTSNEQiorDeMG3jD4AZNFI6kJdsnzQBfHkK5woMw+g2CxnEEkNWS1vgoROEnK4h9gHSgptjsIw7BXH7PQbIjdhadrTt5jzVKRlc7FNsTXAksY4yM/4QGKO05iL4EeS3ybXBGggU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757407227; c=relaxed/simple;
	bh=D9DetWEYz4Y/Qc9IG52XXFbqTfk39CVfFnrWgEog6pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VoerQ/37fOJrDtz395S+WFTDSqkLP3eAWT2fSb7yJ3GncdpptcXwAVQy6mDieYqYUyrY82tJ4yMbRWN85+p11P8dfdz4qQSISWccckDvsBR+P6/KQIwB1tJs6rQQ1vxubXSZjGXXq/L5woDXx3fwykJ/nZpr8Iawjfnr8+lK9EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HjqggeIw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HjqggeIw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757407224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/kIN6FU/MHBcGeWU+LcBOmaIbQLOBoPhHQF7xDCFhE=;
	b=HjqggeIwHLT4qEUimZaL9+FITAs3BaLPJOD/mWZGGExx/+WeVBDl9ONDvNAirl1cazwHJ1
	OTVAlCac2FXGj1oUyeu/HFuO0K+LNSj8c2yZdlMkQwh7HkX4VzF4gZAXgEzfldHaxROpyd
	jwBPa7CZ1tL0/mGkLbjcV5VDRL0ASmc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-HfL5_bRHMFeFAvdMguxZJA-1; Tue, 09 Sep 2025 04:40:23 -0400
X-MC-Unique: HfL5_bRHMFeFAvdMguxZJA-1
X-Mimecast-MFC-AGG-ID: HfL5_bRHMFeFAvdMguxZJA_1757407222
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5686d37f16aso315847e87.3
        for <linux-raid@vger.kernel.org>; Tue, 09 Sep 2025 01:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757407221; x=1758012021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/kIN6FU/MHBcGeWU+LcBOmaIbQLOBoPhHQF7xDCFhE=;
        b=Pt4udNlEyeCSBEzBG657LvZzKP5ubKqVVaG842wYQeV1ztgtBqpkp/LylqK5Fe9tq+
         s2txbwKJ0Sxu/jxBWsU6XtLLNo8B3yRM+n8tJicKe/UgbXNFbpbhI2CcQMPgat6MtBcG
         Ofwz5Gk6p1WA1QlaMZdT4SkwZczOzSWsDXmTckE7rwS2QscNjsiAGYyoJMrT9oCAB2mV
         uvD1+PzH7cn5RuOAjLh3C4dLKdS83/xMImQ/cj5kWt7CCJop11m6ET1ROlRGKMdWCCae
         rDtcXAmZLSSHbEZJg+eNxD1ZRWYyBiEk/T2eSXa3P0QWWfKMqVE5IpIztml1MFm03Pb+
         /OSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyiBsETxfkunvBILOQxM8gMfvvwIsMdnxnB753qY6t/QlDtVOg4sMQa3++VLppxexqDnVH91Naq23j@vger.kernel.org
X-Gm-Message-State: AOJu0YzalSkw+fPnyXuoTf+epEwWg7j/RpnPCSP3X7tazL1RMjk/+CGc
	rjJ2pniejo1ptQLxQRlg02strCpfvwcp7nbiYjuLFohtQB3yQ2wLk5i9GRspPxhjX9LFOBsBMR6
	vxaNarOz0HGXIddah+IlipGIAO2OFW7iwoxUFBhGDpQkW6Vn+eQjcecyVtK59i0Jn974wjKRNo9
	MXjJ5NrfiwbH8ypTOR7xhpl2J23AsCaPtox/inqA==
X-Gm-Gg: ASbGnctiU9yBjBu6jbiQubmyjpxMkRt4fzpKLjhQJP+CzjjtKnqiY086uPrIHfvxIv+
	rAxrS8+eKnGNgHOR/4ACY4eDJlhCCHCyDfCucw0r0y4eyCpC+xvgF/HFH32IW6xDsQ6/zPg1920
	zYfR3UN+SFloM1rYMxABoXsg==
X-Received: by 2002:a05:6512:39cc:b0:55f:47a9:7d33 with SMTP id 2adb3069b0e04-5626425ccd6mr3930879e87.44.1757407221266;
        Tue, 09 Sep 2025 01:40:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3kIiqCYORxnd7VL8RvhhNCCrXI+0lAevzA+I9boUoFbiGny80QauOzU2RITXZErrlVBSD9Z54fha+GqWs6+4=
X-Received: by 2002:a05:6512:39cc:b0:55f:47a9:7d33 with SMTP id
 2adb3069b0e04-5626425ccd6mr3930852e87.44.1757407220585; Tue, 09 Sep 2025
 01:40:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250909080120.2826216-1-yukuai1@huaweicloud.com>
In-Reply-To: <20250909080120.2826216-1-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 9 Sep 2025 16:40:08 +0800
X-Gm-Features: Ac12FXzH994NoRd_L-x2FVqZMcxlAN9DsB4NHjcXms6OBeC0pFlEqCJRHZt6Huk
Message-ID: <CALTww28368Y_F+cD-PLF67Gr049HMBo+UA7Evq_p=WpPQc=3bQ@mail.gmail.com>
Subject: Re: [PATCH] mdadm: add support for new lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mtkaczyk@kernel.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai

Can you create a PR for this patch in
https://github.com/md-raid-utilities/mdadm/

Regards
Xiao

On Tue, Sep 9, 2025 at 4:10=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> A new major number 6 is used for the new bitmap.
>
> Noted that for the kernel that doesn't support lockless bitmap, create
> such array will fail:
>
> md0: invalid bitmap file superblock: unrecognized superblock version.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  Assemble.c    |  5 +++++
>  Create.c      | 10 ++++++++--
>  Grow.c        |  5 +++--
>  Incremental.c | 34 ++++++++++++++++++++++++++++++++++
>  bitmap.h      |  9 +++++++--
>  mdadm.c       |  9 ++++++++-
>  mdadm.h       |  5 ++++-
>  super-intel.c |  2 +-
>  super0.c      |  2 +-
>  super1.c      | 35 +++++++++++++++++++++++++++++++++--
>  10 files changed, 104 insertions(+), 12 deletions(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index 1949bf96..098771e6 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1029,6 +1029,11 @@ static int start_array(int mdfd,
>         int i;
>         unsigned int req_cnt;
>
> +       if (st->ss->get_bitmap_type &&
> +           st->ss->get_bitmap_type(st) =3D=3D BITMAP_MAJOR_LOCKLESS &&
> +           sysfs_set_str(content, NULL, "bitmap_type", "llbitmap"))
> +               return 1;
> +
>         if (content->journal_device_required && (content->journal_clean =
=3D=3D 0)) {
>                 if (!c->force) {
>                         pr_err("Not safe to assemble with missing or stal=
e journal device, consider --force.\n");
> diff --git a/Create.c b/Create.c
> index 420b9136..ed43872f 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -539,6 +539,8 @@ int Create(struct supertype *st, struct mddev_ident *=
ident, int subdevs,
>                         pr_err("At least 2 nodes are needed for cluster-m=
d\n");
>                         return 1;
>                 }
> +       } else if (s->btype =3D=3D BitmapLockless) {
> +               major_num =3D BITMAP_MAJOR_LOCKLESS;
>         }
>
>         memset(&info, 0, sizeof(info));
> @@ -1180,7 +1182,8 @@ int Create(struct supertype *st, struct mddev_ident=
 *ident, int subdevs,
>          * to stop another mdadm from finding and using those devices.
>          */
>
> -       if (s->btype =3D=3D BitmapInternal || s->btype =3D=3D BitmapClust=
er) {
> +       if (s->btype =3D=3D BitmapInternal || s->btype =3D=3D BitmapClust=
er ||
> +           s->btype =3D=3D BitmapLockless) {
>                 if (!st->ss->add_internal_bitmap) {
>                         pr_err("internal bitmaps not supported with %s me=
tadata\n",
>                                 st->ss->name);
> @@ -1188,10 +1191,13 @@ int Create(struct supertype *st, struct mddev_ide=
nt *ident, int subdevs,
>                 }
>                 if (st->ss->add_internal_bitmap(st, &s->bitmap_chunk,
>                                                 c->delay, s->write_behind=
,
> -                                               bitmapsize, 1, major_num)=
) {
> +                                               bitmapsize, 1, major_num,=
 s->assume_clean)) {
>                         pr_err("Given bitmap chunk size not supported.\n"=
);
>                         goto abort_locked;
>                 }
> +               if (s->btype =3D=3D BitmapLockless &&
> +                   sysfs_set_str(&info, NULL, "bitmap_type", "llbitmap")=
 < 0)
> +                       goto abort_locked;
>         }
>
>         if (sysfs_init(&info, mdfd, NULL)) {
> diff --git a/Grow.c b/Grow.c
> index fbf56156..b2cdd893 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -377,7 +377,8 @@ int Grow_addbitmap(char *devname, int fd, struct cont=
ext *c, struct shape *s)
>                 free(mdi);
>         }
>
> -       if (s->btype =3D=3D BitmapInternal || s->btype =3D=3D BitmapClust=
er) {
> +       if (s->btype =3D=3D BitmapInternal || s->btype =3D=3D BitmapClust=
er ||
> +           s->btype =3D=3D BitmapLockless) {
>                 int rv;
>                 int d;
>                 int offset_setable =3D 0;
> @@ -419,7 +420,7 @@ int Grow_addbitmap(char *devname, int fd, struct cont=
ext *c, struct shape *s)
>                                 rv =3D st->ss->add_internal_bitmap(
>                                         st, &s->bitmap_chunk, c->delay,
>                                         s->write_behind, bitmapsize,
> -                                       offset_setable, major);
> +                                       offset_setable, major, 0);
>                                 if (!rv) {
>                                         st->ss->write_bitmap(st, fd2,
>                                                              NodeNumUpdat=
e);
> diff --git a/Incremental.c b/Incremental.c
> index ba3810e6..ce3f97db 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -554,6 +554,40 @@ int Incremental(struct mddev_dev *devlist, struct co=
ntext *c,
>                         if (d->disk.state & (1<<MD_DISK_REMOVED))
>                                 remove_disk(mdfd, st, sra, d);
>
> +               if (st->ss->get_bitmap_type) {
> +                       if (st->sb =3D=3D NULL) {
> +                               dfd =3D dev_open(devname, O_RDONLY);
> +                               if (dfd < 0) {
> +                                       rv =3D 1;
> +                                       goto out;
> +                               }
> +
> +                               rv =3D st->ss->load_super(st, dfd, NULL);
> +                               close(dfd);
> +                               dfd =3D -1;
> +                               if (rv) {
> +                                       pr_err("load super failed %d\n", =
rv);
> +                                       goto out;
> +                               }
> +                       }
> +
> +                       if (st->ss->get_bitmap_type(st) =3D=3D BITMAP_MAJ=
OR_LOCKLESS) {
> +                               if (sra =3D=3D NULL) {
> +                                       sra =3D sysfs_read(mdfd, NULL, (G=
ET_DEVS | GET_STATE |
> +                                                                   GET_O=
FFSET | GET_SIZE));
> +                                       if (!sra) {
> +                                               pr_err("can't read mdinfo=
\n");
> +                                               rv =3D 1;
> +                                               goto out;
> +                                       }
> +                               }
> +
> +                               rv =3D sysfs_set_str(sra, NULL, "bitmap_t=
ype", "llbitmap");
> +                               if (rv)
> +                                       goto out;
> +                       }
> +               }
> +
>                 if ((sra =3D=3D NULL || active_disks >=3D info.array.work=
ing_disks) &&
>                     trustworthy !=3D FOREIGN)
>                         rv =3D ioctl(mdfd, RUN_ARRAY, NULL);
> diff --git a/bitmap.h b/bitmap.h
> index 9f3d4f3e..098e5841 100644
> --- a/bitmap.h
> +++ b/bitmap.h
> @@ -14,12 +14,17 @@
>  #define BITMAP_MAJOR_LO 3
>  #define BITMAP_MAJOR_HI 4
>  #define        BITMAP_MAJOR_CLUSTERED 5
> +#define BITMAP_MAJOR_LOCKLESS 6
>  #define BITMAP_MAGIC 0x6d746962
>
>  /* use these for bitmap->flags and bitmap->sb->state bit-fields */
>  enum bitmap_state {
> -       BITMAP_ACTIVE =3D 0x001, /* the bitmap is in use */
> -       BITMAP_STALE  =3D 0x002  /* the bitmap file is out of date or had=
 -EIO */
> +       BITMAP_STALE            =3D 1,  /* the bitmap file is out of date=
 or had -EIO */
> +       BITMAP_WRITE_ERROR      =3D 2, /* A write error has occurred */
> +       BITMAP_FIRST_USE        =3D 3,
> +       BITMAP_CLEAN            =3D 4,
> +       BITMAP_DAEMON_BUSY      =3D 5,
> +       BITMAP_HOSTENDIAN       =3D 15,
>  };
>
>  /* the superblock at the front of the bitmap file -- little endian */
> diff --git a/mdadm.c b/mdadm.c
> index 14649a40..41811cd8 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -56,6 +56,12 @@ static mdadm_status_t set_bitmap_value(struct shape *s=
, struct context *c, char
>                 return MDADM_STATUS_SUCCESS;
>         }
>
> +       if (strcmp(val, "lockless") =3D=3D 0) {
> +               s->btype =3D BitmapLockless;
> +               pr_info("Experimental lockless bitmap, use at your own di=
sk!\n");
> +               return MDADM_STATUS_SUCCESS;
> +       }
> +
>         if (strcmp(val, "clustered") =3D=3D 0) {
>                 s->btype =3D BitmapCluster;
>                 /* Set the default number of cluster nodes
> @@ -1245,7 +1251,8 @@ int main(int argc, char *argv[])
>                         pr_err("--bitmap is required for consistency poli=
cy: %s\n",
>                                map_num_s(consistency_policies, s.consiste=
ncy_policy));
>                         exit(2);
> -               } else if ((s.btype =3D=3D BitmapInternal || s.btype =3D=
=3D BitmapCluster) &&
> +               } else if ((s.btype =3D=3D BitmapInternal || s.btype =3D=
=3D BitmapCluster ||
> +                           s.btype =3D=3D BitmapLockless) &&
>                            s.consistency_policy !=3D CONSISTENCY_POLICY_B=
ITMAP &&
>                            s.consistency_policy !=3D CONSISTENCY_POLICY_J=
OURNAL) {
>                         pr_err("--bitmap is not compatible with consisten=
cy policy: %s\n",
> diff --git a/mdadm.h b/mdadm.h
> index 84bd2c91..dcddd9a4 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -558,6 +558,7 @@ enum bitmap_type {
>         BitmapNone,
>         BitmapInternal,
>         BitmapCluster,
> +       BitmapLockless,
>         BitmapUnknown,
>  };
>
> @@ -1151,7 +1152,9 @@ extern struct superswitch {
>          */
>         int (*add_internal_bitmap)(struct supertype *st, int *chunkp,
>                                    int delay, int write_behind,
> -                                  unsigned long long size, int may_chang=
e, int major);
> +                                  unsigned long long size, int may_chang=
e,
> +                                  int major, bool assume_clean);
> +       int (*get_bitmap_type)(struct supertype *st);
>         /* Perform additional setup required to activate a bitmap.
>          */
>         int (*set_bitmap)(struct supertype *st, struct mdinfo *info);
> diff --git a/super-intel.c b/super-intel.c
> index 7162327e..b0984235 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -13011,7 +13011,7 @@ static int validate_internal_bitmap_imsm(struct s=
upertype *st)
>  static int add_internal_bitmap_imsm(struct supertype *st, int *chunkp,
>                                     int delay, int write_behind,
>                                     unsigned long long size, int may_chan=
ge,
> -                                   int amajor)
> +                                   int amajor, bool assume_clean)
>  {
>         struct intel_super *super =3D st->sb;
>         int vol_idx =3D super->current_vol;
> diff --git a/super0.c b/super0.c
> index def553c6..bd7ad18e 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -1185,7 +1185,7 @@ static __u64 avail_size0(struct supertype *st, __u6=
4 devsize,
>  static int add_internal_bitmap0(struct supertype *st, int *chunkp,
>                                 int delay, int write_behind,
>                                 unsigned long long size, int may_change,
> -                               int major)
> +                               int major, bool assume_clean)
>  {
>         /*
>          * The bitmap comes immediately after the superblock and must be =
60K in size
> diff --git a/super1.c b/super1.c
> index a8081a44..61378e37 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2374,11 +2374,19 @@ static __u64 avail_size1(struct supertype *st, __=
u64 devsize,
>         return 0;
>  }
>
> +static int get_bitmap_type1(struct supertype *st)
> +{
> +       struct mdp_superblock_1 *sb =3D st->sb;
> +       bitmap_super_t *bms =3D (bitmap_super_t *)(((char *)sb) + MAX_SB_=
SIZE);
> +
> +       return __le32_to_cpu(bms->version);
> +}
> +
>  static int
>  add_internal_bitmap1(struct supertype *st,
>                      int *chunkp, int delay, int write_behind,
>                      unsigned long long size,
> -                    int may_change, int major)
> +                    int may_change, int major, bool assume_clean)
>  {
>         /*
>          * If not may_change, then this is a 'Grow' without sysfs support=
 for
> @@ -2408,6 +2416,14 @@ add_internal_bitmap1(struct supertype *st,
>                  * would be non-zero
>                  */
>                 creating =3D 1;
> +
> +       if (major =3D=3D BITMAP_MAJOR_LOCKLESS) {
> +               if (!creating || st->minor_version !=3D 2) {
> +                       pr_err("lockless bitmap is only supported with cr=
eating the array with 1.2 metadata\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
>         switch(st->minor_version) {
>         case 0:
>                 /*
> @@ -2476,9 +2492,16 @@ add_internal_bitmap1(struct supertype *st,
>         }
>
>         room -=3D bbl_size;
> -       if (chunk =3D=3D UnSet && room > 128*2)
> +       if (major =3D=3D BITMAP_MAJOR_LOCKLESS) {
> +               if (chunk !=3D UnSet) {
> +                       pr_err("lockless bitmap doesn't support chunksize=
\n");
> +                       return -EINVAL;
> +               }
> +               room =3D 128*2;
> +       } else if (chunk =3D=3D UnSet && room > 128*2) {
>                 /* Limit to 128K of bitmap when chunk size not requested =
*/
>                 room =3D 128*2;
> +       }
>
>         if (room <=3D 1)
>                 /* No room for a bitmap */
> @@ -2537,6 +2560,13 @@ add_internal_bitmap1(struct supertype *st,
>                 bms->cluster_name[len - 1] =3D '\0';
>         }
>
> +       /* kernel will initialize bitmap */
> +       if (major =3D=3D BITMAP_MAJOR_LOCKLESS) {
> +               bms->state =3D __cpu_to_le32(1 << BITMAP_FIRST_USE);
> +               if (assume_clean)
> +                       bms->state |=3D __cpu_to_le32(1 << BITMAP_CLEAN);
> +               bms->sectors_reserved =3D __le32_to_cpu(room);
> +       }
>         *chunkp =3D chunk;
>         return 0;
>  }
> @@ -2912,6 +2942,7 @@ struct superswitch super1 =3D {
>         .avail_size =3D avail_size1,
>         .add_internal_bitmap =3D add_internal_bitmap1,
>         .locate_bitmap =3D locate_bitmap1,
> +       .get_bitmap_type =3D get_bitmap_type1,
>         .write_bitmap =3D write_bitmap1,
>         .free_super =3D free_super1,
>  #if __BYTE_ORDER =3D=3D BIG_ENDIAN
> --
> 2.39.2
>

