Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33C87A13A
	for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 03:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757647148; cv=none; b=q6najn+KC2GIRKJuUrw/JxSoAfeEwlEdcUgK1mQ79M8F2zeumy7UpcvkvBnOFa3GrYxhymrWNMCaASjIAwUeZ9lAsGZWn6XbHVXqT/PbDmavvQTXW3D0dh/PyShvDG3WxpI0dkllRrCw2eCp7/yBT1ZNdJaxfb8ftdy1rkEQWWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757647148; c=relaxed/simple;
	bh=PjHoT/d6hpougxDUieTzavYFgDNfvQOoy5mw2Kkbi+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VLSntLWFuRqyy+tYA+xVVtD0iYBNxr62Yn5UXlauwD+UjhACoh1qkYut0vET2vnOy5JDKWGj961X1dQAygdJXkP8jCvg0vs7eOtygFXQQq2xxGVmekco1tnvH8gSYWHmfCD45z+Nsf2EhVI56qCsNcFPaFmUkShG5XlkTBDclQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VrudoT0N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VrudoT0N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ec4LT5rosSmS5p18qT9MoldgNlL6llQc6DnAN4H36dc=;
	b=VrudoT0NDtpveaDhqJlm7em5SdKRRz/wVufWYONqtqzLrcrYO8oBGUE5L7l09+8pyUuQ7K
	3bIg2ZH8+DcOvtSau0zUNJ3aUjHzGqaD/qy+YDCsVARyeSfjKKVgLWQP+1PzGCJoNZzv7R
	kq0YP/xoJep1YYNEU67/kUPhBtovhVk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-R5315gpINjK08KJeFA8OAQ-1; Thu, 11 Sep 2025 23:19:03 -0400
X-MC-Unique: R5315gpINjK08KJeFA8OAQ-1
X-Mimecast-MFC-AGG-ID: R5315gpINjK08KJeFA8OAQ_1757647142
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-350dc421109so2409461fa.0
        for <linux-raid@vger.kernel.org>; Thu, 11 Sep 2025 20:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757647142; x=1758251942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ec4LT5rosSmS5p18qT9MoldgNlL6llQc6DnAN4H36dc=;
        b=AAcMkYII8vGc0i+AuN0D+f5TH9s4lQBr+cSz2XlJ/EqCBhRP3v5IQfqf7Tyaa0ZnIe
         xsmZFQzid/FtvFQ5Gq280WL4++cYTMMZ8htX8lMZ2zRQ5L+YNj3InabsIx6ZZkf2HjQE
         bNETUk7e3RxH+imWyJOvtzO2JZeGgtusEQReEFtY86BqQgmR9/OubqF9U7ne46VegT3+
         boIC0tjNgwqz+IDTXA3ieDtIQeU/w7zex59USwl0Z+RYzVdy8HWly9kIwjsvOEEWICbh
         IQRU/40fmDeUQQUhYLcpFmE8+ua2nlFp9tFz2fDdGeDBs5Ep/95dWPEmtuFUb8OCNjxc
         Fiuw==
X-Forwarded-Encrypted: i=1; AJvYcCXduhqG/HkjShrgynFMPLeURuzJCpA5WWwtR55AAjfgsqvKR9Ihx5eGstw8Pyg4CTzkMc8YszcofogL@vger.kernel.org
X-Gm-Message-State: AOJu0YwcV1QrMXMrKZI1fHEqg0Rqhe7VC8DvtV3bJoqxn7ucgNCMd6G6
	h3Ha+mC9e9EBQSIw8bESVJK52bmmuQBbSeVjk/s6AKDg+1+y6qkpVjKmz8gqBMsqRZtHqZ+T6PV
	y69ttZu6N6/9GA0Mrac8vbhDBjTeEDUkxP7Ul+HSxjSslXuFYbGY2so8kKeeqqws33eYec76oUO
	MJye2KXYtFQZZyi8rjhcmVqamqyqb+6pd3xaLb2g==
X-Gm-Gg: ASbGncvkO1kzNOmeKbkZ5A3Nfo+HG4YBwKG+icxsC97Ff/6f4aFUqzK4RlqirfmF0fk
	60DuKEMxOSwkxU51M7Z01G/+7v65nz/XZ2UENQNepP3RUBJZCHFas6oLZhO/U2qgDKrfKbhBmgn
	eW5ksJKMWXifbZv3AxYaQO
X-Received: by 2002:a2e:be9b:0:b0:336:89b5:c70a with SMTP id 38308e7fff4ca-3513a8ee687mr4215241fa.12.1757647141868;
        Thu, 11 Sep 2025 20:19:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLR6dW4LJcHhS0+kblBMouz4MnGzTLv42S4hlrpmzCND9qYd5eY9mleXav7CncLnrWS8GkeEb5PppVWguERIU=
X-Received: by 2002:a2e:be9b:0:b0:336:89b5:c70a with SMTP id
 38308e7fff4ca-3513a8ee687mr4215081fa.12.1757647141439; Thu, 11 Sep 2025
 20:19:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911073144.42160-1-linan666@huaweicloud.com> <20250911073144.42160-2-linan666@huaweicloud.com>
In-Reply-To: <20250911073144.42160-2-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 12 Sep 2025 11:18:49 +0800
X-Gm-Features: Ac12FXwC64X2iTtI6ND0sn_OfF3t4ygR1KBz6aQfQNHJU7vgbM5-fEvoSGl_XJo
Message-ID: <CALTww2-rbwtJTm+yyX6mar_eybLCbpFoWQWdOM9j4_hgW0=4Hg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] md: prevent adding disks with larger
 logical_block_size to active arrays
To: linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, linan122@huawei.com, 
	hare@suse.de, martin.petersen@oracle.com, bvanassche@acm.org, 
	filipe.c.maia@gmail.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 3:41=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> When adding a disk to a md array, avoid updating the array's
> logical_block_size to match the new disk. This prevents accidental
> partition table loss that renders the array unusable.
>
> The later patch will introduce a way to configure the array's
> logical_block_size.
>
> The issue was introduced before Linux 2.6.12-rc2.
>
> Fixes: d2e45eace8 ("[PATCH] Fix raid "bio too big" failures")

Hi Li Nan

I can't find the commit in
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

git show d2e45eace8
fatal: ambiguous argument 'd2e45eace8': unknown revision or path not
in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'

Regards
Xiao
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/md/md.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a77c59527d4c..40f56183c744 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6064,6 +6064,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, stru=
ct md_rdev *rdev)
>         if (mddev_is_dm(mddev))
>                 return 0;
>
> +       if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
> +           queue_logical_block_size(mddev->gendisk->queue)) {
> +               pr_err("%s: incompatible logical_block_size, can not add\=
n",
> +                      mdname(mddev));
> +               return -EINVAL;
> +       }
> +
>         lim =3D queue_limits_start_update(mddev->gendisk->queue);
>         queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>                                 mddev->gendisk->disk_name);
> --
> 2.39.2
>

