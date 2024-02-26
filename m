Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96CF131E23
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958694; cv=none; b=c62e2S5wxKsFbnFs3w9rJTGrMxQOMXN/4g4OHvEIa7rePn7cA0oAuH/NnXHuERFqaHmcHTiy6Lx9BT3DTi3l24KyeH8P/gAbNMhzJTHh8t3Mo3p8Iany7q8zNvjb3yMmMQ6L0CetZ3UqFkNYqH5I2FU0ZGflBpXKLZe4pmpaOVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958694; c=relaxed/simple;
	bh=oRQ9v7kB5bqRxTK8PhLxJf5eEHNOuOC6up/KxjKjbJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bUhFBnTVATjx0MaBoNM1E5SYY4oAVSKVZRin+AauEKb50q/re0eu5RRHQwOWTPEF13ruZ3yKw0K/qtP+mhZXmDYJ5vO+Qp4/R7FzqUeyBqCLVCYMA3TgEngJS9V+bwEGjh3ELEyfh7qDAkct/1vuB1rub7K2I/5prMFUhBq6IJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U8ZO+28I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U8ZO+28I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708958691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WVAz6OqM9YBIHNwy968Ocu5br0K4GggiejttotLLqFo=;
	b=U8ZO+28I1LCzA51hNqJ5T4kK9uFmuiv94DmWWa+duVUJQ0r/V39cnNNnSXLhQtY51UFKLb
	zgTXNIDEkmaNy13jpZe6Tl48CzSC35gtfY9WIZ35skLUYfPH5naURfWEiw2x1T2lO1PzFn
	Qg6pmTjJbbKF/2jvAwV/qIjS6Pv1lvA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-Hn6PtzffMkGazE9OHJQuXg-1; Mon, 26 Feb 2024 09:44:48 -0500
X-MC-Unique: Hn6PtzffMkGazE9OHJQuXg-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5d8dc8f906aso2132772a12.2
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 06:44:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958687; x=1709563487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WVAz6OqM9YBIHNwy968Ocu5br0K4GggiejttotLLqFo=;
        b=eSwmGyNluDUP7zziCaxTP39pKZK7Ls7ldSm9KCXp/LPXbQN+mGjb9DtzcoDCBx0+dn
         568LHlcw4QVQMGUzR9GRl9DArE5FfMQQ2UH8L422nxfqQv+BumWj1pBpTgkpFXmEP6Pc
         BMAt4uJ8/lGucfnpF6v3pX34FtS3w9vhxLgNxw5tdAKvAG/VBXiQKYEmUk/VSCmxn4Wb
         IE+wmoIPFYWP+0mYUGZdOU6ujgUzNITUkma8iwEnL8iPwNF5GcQI0f5UI68wM7R0CWNy
         ZMV1yO72lN0Bf6z+PCsZF4BO7nzYOMIMfBSql7axxZtpSJlF+2Cy2brIqaoisdlZa0n8
         gy7w==
X-Forwarded-Encrypted: i=1; AJvYcCUw/iUgAbbN2i419IMeUZrEBN/uQd42IiD0arrVold3oUDr5032VBdvajNFY4X99qIFVcZATa8f8zk7eUnki56jou55ymk9b5pUFg==
X-Gm-Message-State: AOJu0YzpjiyK9dANuNPNnyTr3fThvbyGJEEOqi2Gd30VrM036xJSS+PF
	GGfwpBitxn78QVZ8Pe6uC++9V/u4gV5KBVkuYjIj8nMWbYQqI+9ln8MrD3YHE97QjDDs0UXyJml
	cOvwxE8x8JfGGrqQVpXc73H6radhDjDYHqfiUPejG36uhVlKesfHtnnNR6huPQTcNEr/cz8Q3TG
	fJHXS2ZAzdFnBj7hi0IouUbhuSBwQ3avzM7g==
X-Received: by 2002:a17:902:e841:b0:1dc:1c81:1b19 with SMTP id t1-20020a170902e84100b001dc1c811b19mr9002134plg.3.1708958687295;
        Mon, 26 Feb 2024 06:44:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG7cionqfGU4TMZnBAEDSHJq9kGuFCGsOtY/uktnXaRrzbGASDaU/mnx+5J/yKR+IzenDmrRXpXREZPNo0jbEo=
X-Received: by 2002:a17:902:e841:b0:1dc:1c81:1b19 with SMTP id
 t1-20020a170902e84100b001dc1c811b19mr9002102plg.3.1708958686977; Mon, 26 Feb
 2024 06:44:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-8-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-8-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Feb 2024 22:44:35 +0800
Message-ID: <CALTww2-jdEos2HHgBHYHc0VOh1tWYuWTztmvW4iaBi6bS8B-YQ@mail.gmail.com>
Subject: Re: [PATCH md-6.9 07/10] md/raid1: factor out choose_slow_rdev() from read_balance()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:04=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> read_balance() is hard to understand because there are too many status
> and branches, and it's overlong.
>
> This patch factor out the case to read the slow rdev from
> read_balance(), there are no functional changes.
>
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1.c | 69 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 52 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 08c45ca55a7e..bc2f8fcbe5b3 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -620,6 +620,53 @@ static int choose_first_rdev(struct r1conf *conf, st=
ruct r1bio *r1_bio,
>         return -1;
>  }
>
> +static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
> +                           int *max_sectors)
> +{
> +       sector_t this_sector =3D r1_bio->sector;
> +       int bb_disk =3D -1;
> +       int bb_read_len =3D 0;
> +       int disk;
> +
> +       for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
> +               struct md_rdev *rdev;
> +               int len;
> +               int read_len;
> +
> +               if (r1_bio->bios[disk] =3D=3D IO_BLOCKED)
> +                       continue;
> +
> +               rdev =3D conf->mirrors[disk].rdev;
> +               if (!rdev || test_bit(Faulty, &rdev->flags) ||
> +                   !test_bit(WriteMostly, &rdev->flags))
> +                       continue;
> +
> +               /* there are no bad blocks, we can use this disk */
> +               len =3D r1_bio->sectors;
> +               read_len =3D raid1_check_read_range(rdev, this_sector, &l=
en);
> +               if (read_len =3D=3D r1_bio->sectors) {
> +                       update_read_sectors(conf, disk, this_sector, read=
_len);
> +                       return disk;
> +               }
> +
> +               /*
> +                * there are partial bad blocks, choose the rdev with lar=
gest
> +                * read length.
> +                */
> +               if (read_len > bb_read_len) {
> +                       bb_disk =3D disk;
> +                       bb_read_len =3D read_len;
> +               }
> +       }
> +
> +       if (bb_disk !=3D -1) {
> +               *max_sectors =3D bb_read_len;
> +               update_read_sectors(conf, bb_disk, this_sector, bb_read_l=
en);
> +       }
> +
> +       return bb_disk;
> +}
> +
>  /*
>   * This routine returns the disk from which the requested read should
>   * be done. There is a per-array 'next expected sequential IO' sector
> @@ -672,23 +719,8 @@ static int read_balance(struct r1conf *conf, struct =
r1bio *r1_bio, int *max_sect
>                 if (!test_bit(In_sync, &rdev->flags) &&
>                     rdev->recovery_offset < this_sector + sectors)
>                         continue;
> -               if (test_bit(WriteMostly, &rdev->flags)) {
> -                       /* Don't balance among write-mostly, just
> -                        * use the first as a last resort */
> -                       if (best_dist_disk < 0) {
> -                               if (is_badblock(rdev, this_sector, sector=
s,
> -                                               &first_bad, &bad_sectors)=
) {
> -                                       if (first_bad <=3D this_sector)
> -                                               /* Cannot use this */
> -                                               continue;
> -                                       best_good_sectors =3D first_bad -=
 this_sector;
> -                               } else
> -                                       best_good_sectors =3D sectors;
> -                               best_dist_disk =3D disk;
> -                               best_pending_disk =3D disk;
> -                       }
> +               if (test_bit(WriteMostly, &rdev->flags))
>                         continue;
> -               }
>                 /* This is a reasonable device to use.  It might
>                  * even be best.
>                  */
> @@ -799,7 +831,10 @@ static int read_balance(struct r1conf *conf, struct =
r1bio *r1_bio, int *max_sect
>         }
>         *max_sectors =3D sectors;
>
> -       return best_disk;
> +       if (best_disk >=3D 0)
> +               return best_disk;
> +
> +       return choose_slow_rdev(conf, r1_bio, max_sectors);
>  }
>
>  static void wake_up_barrier(struct r1conf *conf)
> --
> 2.39.2
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

