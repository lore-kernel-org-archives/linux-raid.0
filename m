Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3394CB20
	for <linux-raid@vger.kernel.org>; Fri,  8 Dec 2023 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dno+xlIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F238C433CA;
	Fri,  8 Dec 2023 18:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702060723;
	bh=p6EUr4XdfGiU15iBvj29ZMkrSJe8sng7h5PI+7HQ6yc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Dno+xlIK/De90rnDEItt9BHGdlJGpFMzxWk8QdmisILYxJOBay54wmfO6Hsor9Xlp
	 whb2oR01D0PFJeJ4zXsmytsli1f8Txc6DJjjfnc9/ambZXUy0EbqfmQWZKTlWrnuAt
	 6Z+3sHG6kOcoS1G5M+unFL/OWHGvXrTngG9i6vh8Oh6OP/OLrt5+4IOUS/lHbdNXw9
	 I3YcipJTN7x/ubqwPhwhO8kHVHOtvgIW6wNuT6aMgXqQ+CssFYzVkjugF8ReavRGc0
	 kIx1LrvrZmubl1UBvtbhK+y17EKJ4lGj/sefdCrxHYZ0xIiHGz7eEnsmDZyyV0C5el
	 7BOJR8p7vGINA==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2c9f413d6b2so29345651fa.1;
        Fri, 08 Dec 2023 10:38:43 -0800 (PST)
X-Gm-Message-State: AOJu0Yy+yPJV1YDjDHwAhqaEaRm4huD0l3/UISCbUC3KcYBa5q/YhXgB
	HnFwP7ek2DTPuKxRrNPIKosIsTDqULR9SoYQ0vk=
X-Google-Smtp-Source: AGHT+IFQ3vax+fj7ncIg6Ja7nCGrLF6yi2Sw1MAVjOv5iDvOoT+MwiPHPZ/6h0fa928C2L+JmqZ6Ag5Ixgreb8cMojQ=
X-Received: by 2002:ac2:4e8e:0:b0:50b:ea76:509f with SMTP id
 o14-20020ac24e8e000000b0050bea76509fmr106822lfr.64.1702060721563; Fri, 08 Dec
 2023 10:38:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204070327.3150356-1-linan666@huaweicloud.com> <20231204070327.3150356-2-linan666@huaweicloud.com>
In-Reply-To: <20231204070327.3150356-2-linan666@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Fri, 8 Dec 2023 10:38:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6Zr-ztojUtf9=g8Tj0pyS9cHLY0hnoJ85mFcSEZaAY3Q@mail.gmail.com>
Message-ID: <CAPhsuW6Zr-ztojUtf9=g8Tj0pyS9cHLY0hnoJ85mFcSEZaAY3Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] md: factor out a helper exceed_read_errors() to check read_errors
To: linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com, 
	houtao1@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 3, 2023 at 11:04=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Move check_decay_read_errors() to raid1-10.c and factor out a helper
> exceed_read_errors() to check if read_errors exceeds the limit, so that
> raid1 can also use it. There are no functional changes.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
[...]
> +static inline bool exceed_read_errors(struct mddev *mddev, struct md_rde=
v *rdev)
> +{
> +       int max_read_errors =3D atomic_read(&mddev->max_corr_read_errors)=
;
> +       int read_errors;
> +
> +       check_decay_read_errors(mddev, rdev);
> +       read_errors =3D  atomic_inc_return(&rdev->read_errors);
> +       if (read_errors > max_read_errors) {
> +               pr_notice("md:%s: %pg: Raid device exceeded read_error th=
reshold [cur %d:max %d]\n",
> +                         mdname(mddev), rdev->bdev, read_errors, max_rea=
d_errors);
> +               pr_notice("md:%s: %pg: Failing raid device\n",
> +                         mdname(mddev), rdev->bdev);

This changed the print message from "md/raid10:" to "md:". We should
try to avoid
such changes. How about we do something like the following?

Thanks,
Song

diff --git i/drivers/md/raid1-10.c w/drivers/md/raid1-10.c
index 3f22edec70e7..6c0ef0fe6ba7 100644
--- i/drivers/md/raid1-10.c
+++ w/drivers/md/raid1-10.c
@@ -173,3 +173,10 @@ static inline void
raid1_prepare_flush_writes(struct bitmap *bitmap)
        else
                md_bitmap_unplug(bitmap);
 }
+
+static inline bool exceed_read_errors(struct mddev *mddev, struct
md_rdev *rdev)
+{
+       pr_notice("md/" RAID_1_10_NAME ":%s: %pg: Raid device ...\n",
+                 ...);
+       ...
+}
diff --git i/drivers/md/raid1.c w/drivers/md/raid1.c
index 9348f1709512..412e98d02a05 100644
--- i/drivers/md/raid1.c
+++ w/drivers/md/raid1.c
@@ -49,6 +49,7 @@ static void lower_barrier(struct r1conf *conf,
sector_t sector_nr);
 #define raid1_log(md, fmt, args...)                            \
        do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 "
fmt, ##args); } while (0)

+#define RAID_1_10_NAME "raid1"
 #include "raid1-10.c"

 #define START(node) ((node)->start)
diff --git i/drivers/md/raid10.c w/drivers/md/raid10.c
index 375c11d6159f..a1531b5f15e3 100644
--- i/drivers/md/raid10.c
+++ w/drivers/md/raid10.c
@@ -77,6 +77,8 @@ static void end_reshape(struct r10conf *conf);
 #define raid10_log(md, fmt, args...)                           \
        do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid10 "
fmt, ##args); } while (0)

+#define RAID_1_10_NAME "raid10"
+
 #include "raid1-10.c"

 #define NULL_CMD

[...]
