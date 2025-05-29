Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D96EC4
	for <linux-raid@vger.kernel.org>; Thu, 29 May 2025 07:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748502251; cv=none; b=AtIMyaeJ5nskdKMPi8dYzSCmyXcMcNgqnwHxBzCJCE/27ZkXAp/H5VOYlPSpcxFl2s7XwlU3lvjjLaePD5jBpOTpe63IrjMlJrIjI3QCrcURffmRRHu0++wgohOjA7ife5uhHg047A6ltIsj1gr/oiRXGy0xVuQM5cWv5nwYu9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748502251; c=relaxed/simple;
	bh=gGAIBfPLJ5mzuI2J9XqVGwHUjLcIMVokl51TD/0nSPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b94keKm+8KnD77GcT92EgY3k4tUqYqUqVauIEtA2/yWwnRm6TAPHnn5/2eC05DiXzUMGgf0/xLKdRoJKUmpo5JD4jSG9gt5byqnYI3ELV7Ja1UQm+bes3rR9Z+ytMQfKZ0y1n/yoRUMBjyQ/LGNW5PVd2zsJfAJeNxSDy/OxYOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XQZZ0C5s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XQZZ0C5s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748502247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FLyhUeKcdVZ0yoXoNzS788RI+RJY/OUuQZYjxQszTis=;
	b=XQZZ0C5seHNgfPyXejCeZ6OAA2iZmemQzKAJpvIHYhWjeDHYqH8a+ff9XgoBOpVvC8/HiG
	vRAXgLcV6Psk94GZSOKZ954qgjLi6dlUd51fxXvfTGBecxez73kUNQgEMPuq0jtKwQW+R1
	bReDOU9Pq8ddXRthW3GgyuWFxYnGGR4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-WmRNayPWPfGZoZmx6SBX5Q-1; Thu, 29 May 2025 03:04:06 -0400
X-MC-Unique: WmRNayPWPfGZoZmx6SBX5Q-1
X-Mimecast-MFC-AGG-ID: WmRNayPWPfGZoZmx6SBX5Q_1748502245
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55324d01d3cso246762e87.1
        for <linux-raid@vger.kernel.org>; Thu, 29 May 2025 00:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748502243; x=1749107043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FLyhUeKcdVZ0yoXoNzS788RI+RJY/OUuQZYjxQszTis=;
        b=AvPgakCg4SxSxyre+bTcHJ8GD2335iheLkAEsRoW2AQl4ZUxtADOxZzcEw1+qtafKX
         RhLgskHeZNVFYQNqhnMXpNHToMLs819hYuvbdNLJYNSAog5fxdTxB4Shm/9MR1Br6Fef
         z9th19G/tlvQOLCyKrz9q1zdIHjD9Patj8q5D6s3zs4IzVRhGGOSntR8XqMtqK8HLu+o
         0YsoCun9Fru3/1sENZLLVnsJeIxvFe4rRhFyafJzu6r+H3dOz1peCrh3fiRKXs1y0CWL
         FHYodPrMfEuu93RH8Kl1mpyBn16e90EwpKuMfd85ZWOI8oF0U/1fhqvSDgJhW9tNlvIn
         /2zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFFXG0JUauadIOUL7oESPRWMvcPgP8Ucw4c6QvVYnjPSwOINnlznFGw4Tb54vYcOzaeFkC4tCFgBzv@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7+40m7PaDY/rcCrrok6MdS7XaYMjCKHWIZYJoTT+cKDWiD3/V
	LgyQccICbkOWo86SCzVDkxXLwJg1xI8jjL97JxVm8DtoapZT7MB6fQXVfqR1Wqx+XfEBB72nNtl
	i1r94MUU79GsbCOPDVFhZgdivOq9uWxmckGM3H+oWgp6dMLNc9J00bJAwos9tQoytD+2gqPBdu+
	hZ+ezQvQCmoMqVHwsFrQNqBqcHpD1XZJWCxlh65utdh72N2g==
X-Gm-Gg: ASbGncskoXtnbvHMiTNttMt6UUzlpo0UMvyxAJZPHro4vZvOkldeynNPlS41uFJulG6
	QTXHy7LFQfYeGLhaRKVbrA7g7PBVAWESJVG5jBq5JrK4RIfb54a4sDW4mIyqqHdqGyc6V3g==
X-Received: by 2002:a05:6512:a88:b0:550:e527:886f with SMTP id 2adb3069b0e04-5521c9b48a5mr6226576e87.51.1748502243497;
        Thu, 29 May 2025 00:04:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhBwtEWV7FTygdRfcy4kngKHINa8KsHRMkeClwkAOFQYJyufuKIr4JvD4VEJD5vzTS24wJDQc0jIE+CufADn0=
X-Received: by 2002:a05:6512:a88:b0:550:e527:886f with SMTP id
 2adb3069b0e04-5521c9b48a5mr6226569e87.51.1748502242998; Thu, 29 May 2025
 00:04:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-19-yukuai1@huaweicloud.com>
In-Reply-To: <20250524061320.370630-19-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 29 May 2025 15:03:50 +0800
X-Gm-Features: AX0GCFt6aelieDdKVpFEW95DgBTQaabsDTo6V1Wck7H_eO8X27kgvzCG7zQ3eY8
Message-ID: <CALTww2-+0h2Pxq0PJLZQxcoYpMJuiKuv6CZQ3kgX5PeqBkxKsQ@mail.gmail.com>
Subject: Re: [PATCH 18/23] md/md-llbitmap: implement APIs to mange bitmap lifetime
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, yukuai3@huawei.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai

Is it better to put this patch before patch15. I'm reading patch15.
But I need to read this patch first to understand how llbitmap is
created and loaded. Then I can go to read the io related part.

Regards
Xiao

On Sat, May 24, 2025 at 2:18=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Include following APIs:
>  - llbitmap_create
>  - llbitmap_resize
>  - llbitmap_load
>  - llbitmap_destroy
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-llbitmap.c | 322 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 322 insertions(+)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 4d5f9a139a25..23283c4f7263 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -689,4 +689,326 @@ static void llbitmap_resume(struct llbitmap *llbitm=
ap, int page_idx)
>         wake_up(&pctl->wait);
>  }
>
> +static int llbitmap_check_support(struct mddev *mddev)
> +{
> +       if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
> +               pr_notice("md/llbitmap: %s: array with journal cannot hav=
e bitmap\n",
> +                         mdname(mddev));
> +               return -EBUSY;
> +       }
> +
> +       if (mddev->bitmap_info.space =3D=3D 0) {
> +               if (mddev->bitmap_info.default_space =3D=3D 0) {
> +                       pr_notice("md/llbitmap: %s: no space for bitmap\n=
",
> +                                 mdname(mddev));
> +                       return -ENOSPC;
> +               }
> +       }
> +
> +       if (!mddev->persistent) {
> +               pr_notice("md/llbitmap: %s: array must be persistent\n",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (mddev->bitmap_info.file) {
> +               pr_notice("md/llbitmap: %s: doesn't support bitmap file\n=
",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (mddev->bitmap_info.external) {
> +               pr_notice("md/llbitmap: %s: doesn't support external meta=
data\n",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (mddev_is_dm(mddev)) {
> +               pr_notice("md/llbitmap: %s: doesn't support dm-raid\n",
> +                         mdname(mddev));
> +               return -EOPNOTSUPP;
> +       }
> +
> +       return 0;
> +}
> +
> +static int llbitmap_init(struct llbitmap *llbitmap)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       sector_t blocks =3D mddev->resync_max_sectors;
> +       unsigned long chunksize =3D MIN_CHUNK_SIZE;
> +       unsigned long chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       unsigned long space =3D mddev->bitmap_info.space << SECTOR_SHIFT;
> +       int ret;
> +
> +       while (chunks > space) {
> +               chunksize =3D chunksize << 1;
> +               chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       }
> +
> +       llbitmap->chunkshift =3D ffz(~chunksize);
> +       llbitmap->chunksize =3D chunksize;
> +       llbitmap->chunks =3D chunks;
> +       mddev->bitmap_info.daemon_sleep =3D DEFAULT_DAEMON_SLEEP;
> +
> +       ret =3D llbitmap_cache_pages(llbitmap);
> +       if (ret)
> +               return ret;
> +
> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, BitmapA=
ctionInit);
> +       return 0;
> +}
> +
> +static int llbitmap_read_sb(struct llbitmap *llbitmap)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       unsigned long daemon_sleep;
> +       unsigned long chunksize;
> +       unsigned long events;
> +       struct page *sb_page;
> +       bitmap_super_t *sb;
> +       int ret =3D -EINVAL;
> +
> +       if (!mddev->bitmap_info.offset) {
> +               pr_err("md/llbitmap: %s: no super block found", mdname(md=
dev));
> +               return -EINVAL;
> +       }
> +
> +       sb_page =3D llbitmap_read_page(llbitmap, 0);
> +       if (IS_ERR(sb_page)) {
> +               pr_err("md/llbitmap: %s: read super block failed",
> +                      mdname(mddev));
> +               ret =3D -EIO;
> +               goto out;
> +       }
> +
> +       sb =3D kmap_local_page(sb_page);
> +       if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC)) {
> +               pr_err("md/llbitmap: %s: invalid super block magic number=
",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (sb->version !=3D cpu_to_le32(BITMAP_MAJOR_LOCKLESS)) {
> +               pr_err("md/llbitmap: %s: invalid super block version",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (memcmp(sb->uuid, mddev->uuid, 16)) {
> +               pr_err("md/llbitmap: %s: bitmap superblock UUID mismatch\=
n",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (mddev->bitmap_info.space =3D=3D 0) {
> +               int room =3D le32_to_cpu(sb->sectors_reserved);
> +
> +               if (room)
> +                       mddev->bitmap_info.space =3D room;
> +               else
> +                       mddev->bitmap_info.space =3D mddev->bitmap_info.d=
efault_space;
> +       }
> +       llbitmap->flags =3D le32_to_cpu(sb->state);
> +       if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
> +               ret =3D llbitmap_init(llbitmap);
> +               goto out_put_page;
> +       }
> +
> +       chunksize =3D le32_to_cpu(sb->chunksize);
> +       if (!is_power_of_2(chunksize)) {
> +               pr_err("md/llbitmap: %s: chunksize not a power of 2",
> +                      mdname(mddev));
> +               goto out_put_page;
> +       }
> +
> +       if (chunksize < DIV_ROUND_UP(mddev->resync_max_sectors,
> +                                    mddev->bitmap_info.space << SECTOR_S=
HIFT)) {
> +               pr_err("md/llbitmap: %s: chunksize too small %lu < %llu /=
 %lu",
> +                      mdname(mddev), chunksize, mddev->resync_max_sector=
s,
> +                      mddev->bitmap_info.space);
> +               goto out_put_page;
> +       }
> +
> +       daemon_sleep =3D le32_to_cpu(sb->daemon_sleep);
> +       if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT / HZ)=
 {
> +               pr_err("md/llbitmap: %s: daemon sleep %lu period out of r=
ange",
> +                      mdname(mddev), daemon_sleep);
> +               goto out_put_page;
> +       }
> +
> +       events =3D le64_to_cpu(sb->events);
> +       if (events < mddev->events) {
> +               pr_warn("md/llbitmap :%s: bitmap file is out of date (%lu=
 < %llu) -- forcing full recovery",
> +                       mdname(mddev), events, mddev->events);
> +               set_bit(BITMAP_STALE, &llbitmap->flags);
> +       }
> +
> +       sb->sync_size =3D cpu_to_le64(mddev->resync_max_sectors);
> +       mddev->bitmap_info.chunksize =3D chunksize;
> +       mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
> +
> +       llbitmap->chunksize =3D chunksize;
> +       llbitmap->chunks =3D DIV_ROUND_UP(mddev->resync_max_sectors, chun=
ksize);
> +       llbitmap->chunkshift =3D ffz(~chunksize);
> +       ret =3D llbitmap_cache_pages(llbitmap);
> +
> +out_put_page:
> +       __free_page(sb_page);
> +out:
> +       kunmap_local(sb);
> +       return ret;
> +}
> +
> +static void llbitmap_pending_timer_fn(struct timer_list *t)
> +{
> +       struct llbitmap *llbitmap =3D from_timer(llbitmap, t, pending_tim=
er);
> +
> +       if (work_busy(&llbitmap->daemon_work)) {
> +               pr_warn("daemon_work not finished\n");
> +               set_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags);
> +               return;
> +       }
> +
> +       queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
> +}
> +
> +static void md_llbitmap_daemon_fn(struct work_struct *work)
> +{
> +       struct llbitmap *llbitmap =3D
> +               container_of(work, struct llbitmap, daemon_work);
> +       unsigned long start;
> +       unsigned long end;
> +       bool restart;
> +       int idx;
> +
> +       if (llbitmap->mddev->degraded)
> +               return;
> +
> +retry:
> +       start =3D 0;
> +       end =3D min(llbitmap->chunks, PAGE_SIZE - BITMAP_SB_SIZE) - 1;
> +       restart =3D false;
> +
> +       for (idx =3D 0; idx < llbitmap->nr_pages; idx++) {
> +               struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[idx];
> +
> +               if (idx > 0) {
> +                       start =3D end + 1;
> +                       end =3D min(end + PAGE_SIZE, llbitmap->chunks - 1=
);
> +               }
> +
> +               if (!test_bit(LLPageFlush, &pctl->flags) &&
> +                   time_before(jiffies, pctl->expire)) {
> +                       restart =3D true;
> +                       continue;
> +               }
> +
> +               llbitmap_suspend(llbitmap, idx);
> +               llbitmap_state_machine(llbitmap, start, end, BitmapAction=
Daemon);
> +               llbitmap_resume(llbitmap, idx);
> +       }
> +
> +       /*
> +        * If the daemon took a long time to finish, retry to prevent mis=
sing
> +        * clearing dirty bits.
> +        */
> +       if (test_and_clear_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags))
> +               goto retry;
> +
> +       /* If some page is dirty but not expired, setup timer again */
> +       if (restart)
> +               mod_timer(&llbitmap->pending_timer,
> +                         jiffies + llbitmap->mddev->bitmap_info.daemon_s=
leep * HZ);
> +}
> +
> +static int llbitmap_create(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap;
> +       int ret;
> +
> +       ret =3D llbitmap_check_support(mddev);
> +       if (ret)
> +               return ret;
> +
> +       llbitmap =3D kzalloc(sizeof(*llbitmap), GFP_KERNEL);
> +       if (!llbitmap)
> +               return -ENOMEM;
> +
> +       llbitmap->mddev =3D mddev;
> +       llbitmap->io_size =3D bdev_logical_block_size(mddev->gendisk->par=
t0);
> +       llbitmap->bits_per_page =3D PAGE_SIZE / llbitmap->io_size;
> +
> +       timer_setup(&llbitmap->pending_timer, llbitmap_pending_timer_fn, =
0);
> +       INIT_WORK(&llbitmap->daemon_work, md_llbitmap_daemon_fn);
> +       atomic_set(&llbitmap->behind_writes, 0);
> +       init_waitqueue_head(&llbitmap->behind_wait);
> +
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +       mddev->bitmap =3D llbitmap;
> +       ret =3D llbitmap_read_sb(llbitmap);
> +       mutex_unlock(&mddev->bitmap_info.mutex);
> +       if (ret)
> +               goto err_out;
> +
> +       return 0;
> +
> +err_out:
> +       kfree(llbitmap);
> +       return ret;
> +}
> +
> +static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chu=
nksize)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +       unsigned long chunks;
> +
> +       if (chunksize =3D=3D 0)
> +               chunksize =3D llbitmap->chunksize;
> +
> +       /* If there is enough space, leave the chunksize unchanged. */
> +       chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
> +               chunksize =3D chunksize << 1;
> +               chunks =3D DIV_ROUND_UP(blocks, chunksize);
> +       }
> +
> +       llbitmap->chunkshift =3D ffz(~chunksize);
> +       llbitmap->chunksize =3D chunksize;
> +       llbitmap->chunks =3D chunks;
> +
> +       return 0;
> +}
> +
> +static int llbitmap_load(struct mddev *mddev)
> +{
> +       enum llbitmap_action action =3D BitmapActionReload;
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       if (test_and_clear_bit(BITMAP_STALE, &llbitmap->flags))
> +               action =3D BitmapActionStale;
> +
> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, action)=
;
> +       return 0;
> +}
> +
> +static void llbitmap_destroy(struct mddev *mddev)
> +{
> +       struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +       if (!llbitmap)
> +               return;
> +
> +       mutex_lock(&mddev->bitmap_info.mutex);
> +
> +       timer_delete_sync(&llbitmap->pending_timer);
> +       flush_workqueue(md_llbitmap_io_wq);
> +       flush_workqueue(md_llbitmap_unplug_wq);
> +
> +       mddev->bitmap =3D NULL;
> +       llbitmap_free_pages(llbitmap);
> +       kfree(llbitmap);
> +       mutex_unlock(&mddev->bitmap_info.mutex);
> +}
> +
>  #endif /* CONFIG_MD_LLBITMAP */
> --
> 2.39.2
>

