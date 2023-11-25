Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GsL/e3to"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DA51BD
	for <linux-raid@vger.kernel.org>; Sat, 25 Nov 2023 02:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700907998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLQCR+hwcyQJXO1rzDrTi8/6fcFm4TdvVYYy57cW/E0=;
	b=GsL/e3top406g4tUx1gVeX944tFnG5DgC1P3qxcD5f0sCPPWT0gmlUXz1C4sLufYrMw8C9
	iZZmqMzIgnZdKd9jkWxzo3uKLGIJklaIvH5x1PTJJQxX3BZau82k6pcKYF8KHLhJuavZ4R
	qRB1zK1caYnoTf/yWV+wGQA/qfKzkSo=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-9pU1XeDTND-06BpfN1W6vA-1; Sat, 25 Nov 2023 05:26:36 -0500
X-MC-Unique: 9pU1XeDTND-06BpfN1W6vA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5be39ccc2e9so3333580a12.3
        for <linux-raid@vger.kernel.org>; Sat, 25 Nov 2023 02:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700907995; x=1701512795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLQCR+hwcyQJXO1rzDrTi8/6fcFm4TdvVYYy57cW/E0=;
        b=r8zPyozmHt7E30JzXKGjjZszp/D2uuHJFMu7uN6gQkentpFXFIO9MsJSiO/c7oObRP
         usxuZak5Zd0teGcOzGq/fY/MjA7iQlHP6qHNEFyMhxB6YRd2TjL/e5KRsTsvi2E6ua9U
         eiua5DJ8MDt8fLSfOKtatwkvNgc+uuivJ8PLuRfPDkohXVkhk0dVvvDCoXqtp43bcj8U
         5VGFi6RWsQeHJkH70Q6rO83gvTpJ8kna0yvw3lvTcln+lMfZ51IlVu4qolYjS0OgqNeB
         iaKtGiUf7SSocLHjYK3Am1gQZA+YytFVt6jhJEizKqXJFUazqPhheF8/cP85600z8UIY
         aynw==
X-Gm-Message-State: AOJu0YwImBVb7b4SHdoupPtjGGkb/JDzo6Phl7th8Pi9GwDzxHderEB9
	mub3yX2RWZsBUGM73/YoR6wC/FHlae8GR9UsL+rVC3S7wg3foTqdAQUQHovgvKP5DjZ1ypAjq18
	fS52ozlzSaZutZ5JqZl3h6D2syMjixnRBCmAdoA==
X-Received: by 2002:a05:6a20:729c:b0:18b:826c:411b with SMTP id o28-20020a056a20729c00b0018b826c411bmr7123660pzk.17.1700907995670;
        Sat, 25 Nov 2023 02:26:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGj+gQkJqIindZjd3rTyUNigqh/fYulbFnVwdUMwwH5xmJ5qdJwem2NEr8aPpml+N3jfIVMwuQGohO5FkUFNTg=
X-Received: by 2002:a05:6a20:729c:b0:18b:826c:411b with SMTP id
 o28-20020a056a20729c00b0018b826c411bmr7123650pzk.17.1700907995306; Sat, 25
 Nov 2023 02:26:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231124075953.1932764-1-yukuai1@huaweicloud.com>
In-Reply-To: <20231124075953.1932764-1-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 25 Nov 2023 18:26:24 +0800
Message-ID: <CALTww28eDmnGC4SPPTezxS_QNvr_o5cz-npyhHMCRt=xcA+nVA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] md: bugfix and cleanup for sync_thread
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 24, 2023 at 4:00=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v2:
>  - add patch 2;
>  - split some patches from v1 that will be sent separately;
>  - rework some commit message;
>  - rework patch 5;
>
> Yu Kuai (6):
>   md: fix missing flush of sync_work
>   md: remove redundant check of 'mddev->sync_thread'
>   md: remove redundant md_wakeup_thread()
>   md: don't leave 'MD_RECOVERY_FROZEN' in error path of
>     md_set_readonly()
>   md: fix stopping sync thread
>   dm-raid: delay flushing event_work() after reconfig_mutex is released
>
>  drivers/md/dm-raid.c |   3 +
>  drivers/md/md.c      | 149 ++++++++++++++++++++-----------------------
>  drivers/md/raid5.c   |   6 +-
>  3 files changed, 75 insertions(+), 83 deletions(-)
>
> --
> 2.39.2
>
For the series
Acked-by: Xiao Ni <xni@redhat.com>

