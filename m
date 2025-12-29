Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E775A3A1E8A
	for <linux-raid@vger.kernel.org>; Mon, 29 Dec 2025 09:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767000012; cv=none; b=tBMUjD6due6nObbm5q9yL1PNgcob4AyD3g+aVKjC1pryVWCG3jfzZNXO9mtyrH0tMHecR0yOTJTlBIqeMz84aOcv/N2jQFU3Qt2BZKZku4SHFAzXWhtUwv12nTqFQZ6bCqZO07i5Wt3otvZNnjH3IMHogZ426odBRcD925RX8s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767000012; c=relaxed/simple;
	bh=86eqiLCmc9bBAKAv+7fU/7VMRerkUtVU0/+i3dPfduc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pXA/Yiq+b1QAkyp0qfol9NucgGMLbmCm/zmO/IK+NeSAe+GPmwm1gM4ZOLzrV0TYpiOF9YShHzD4bTvEpUIk1DqwMenWpQH03t7VOPgWbSdaq66WlLpxUO6NyA6p1xUKn7cSSYMWwvebaJq1MmL3+zm+wopD2JEAILqceDWda4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i0Zg6a0+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aOeLNGjh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0Zg6a0+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aOeLNGjh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767000009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBEgd+iakdSma6mXe1beengZiG9vbwR46YwqmBSY21U=;
	b=i0Zg6a0+jtV1jvOIq5bfNMq1SvIeVVZJCF2FTVz9ZJeOYMdvLhJhuqJ0Rj5GNzKDfEfjUQ
	SZYLT9POaY9v+2MraGVYzJFYcGbfD32oWIImVnT/aPgHOHBpRpz6IS5lEHkN8zXNdiO0aY
	h3AUm/clOj9Apg0QGNSBERJwb/zQisM=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-QbFDg_mGMO-jT9ZJTmxwfQ-1; Mon, 29 Dec 2025 04:20:06 -0500
X-MC-Unique: QbFDg_mGMO-jT9ZJTmxwfQ-1
X-Mimecast-MFC-AGG-ID: QbFDg_mGMO-jT9ZJTmxwfQ_1767000005
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-37fc5cabe6aso49218051fa.1
        for <linux-raid@vger.kernel.org>; Mon, 29 Dec 2025 01:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767000005; x=1767604805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBEgd+iakdSma6mXe1beengZiG9vbwR46YwqmBSY21U=;
        b=aOeLNGjhyb7sHlxz+JFPZRtkP/xvPYkOJmd9Tj1PTDNiGN0+Aop/rR2LYKuRx/wNe1
         CrZ2SwOMpMY7/rAFHyYtUAuxLVmz0+q9RpehgcfL27xPFw8s9CgsiUBGdq2bo6whxCuL
         xlnffKYRMw1tOU2JyVtkfkxKQ2sp9iSEt2wIS1lPGujC5nL+ucG3fUsFcW0BjI48A+Iv
         +HscSIVBbuhsat00HWzBicZ/u8VjEEXwjnnLFjqLvqemq4t6xtZSleSvc5iSwM7V5vfe
         xuMlNuhA1rmodyO6DvQWXtV8uMxde4/5itrGx9LUm1caY7u0KuTAL3bl9QBsvkxGcMY8
         C2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767000005; x=1767604805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qBEgd+iakdSma6mXe1beengZiG9vbwR46YwqmBSY21U=;
        b=ltekRxiYbkympqVNFv9YdfRjSl762BV3Z6MJNb0Ho5pyYtM/i89QEtYsIu82OCVfF4
         C8iH9AraSRh89yDUQjaGCBs34Is1bR1WKJAlU+D+Fz83HlTWz62VCLnzIN2+tG41TnzF
         N4k9GI398qBxGH2lJdf+AF3CbOazQPvGSXnJxIMeUqneDQcZkc3S8JXWdOV0Zhl5YdDk
         4PnUc8V/ubFvcMOG94rjQvr3FE7YdD9dUyoKHGVMhfLZPa2NWNFtN/ko/KoW4SBk9Tv+
         iKhXGEunWOmSCiOjHH6Ot+QoS787ov2CkPs0zhK4LL/JLqafjrgsvtGp2e5RuCcgqChm
         hsoA==
X-Forwarded-Encrypted: i=1; AJvYcCWsTuhCE17ZFzxQBKBqAZmtc+GLSOfBMjACIrp/5hvuwOB8K0HKN9OeREbv9y8Bvaa4kwgChg62tGDG@vger.kernel.org
X-Gm-Message-State: AOJu0YyFI4vjG8SHCtj5kGdGJAWMLFoFKdyo0eR11XCBde+b7Z4IYi9V
	Bhsy5hTt/iCOY44LpJHzeJwVA8uY8JjfcOh3cEqp8vnLxk2Zr7QfW7qlqGYj0zAyg/ajGypiB3w
	OVNMhdN4IiSZn+sCMPLSM4jJcjIERqVqkcduyL38SjhMLmMteV6v5OkSw5IxPlelLpa2NlcoTx0
	1bUYyVujjTsXcS7HJtf1RQ7wkFz8YI6pyEvHEFbQ==
X-Gm-Gg: AY/fxX66jdHpOWHkG0rjOYc5aHlmwTugc1O4pcm3MSw5vWOiDiBsoG5bZRwzvAKQPhf
	PG8vnAIxb9Pnv8Z3yuQgr+DX561NwE+8VCGA7U+IqyzxuRlajgHyZrmQi+Ol1Qcs0d3UKVOG8CH
	qxudK96VhONStV259EGU7Yz7BI1U5Cr4/aw5BWAH9w8j5LBmPr1PqZK23q0NzD34DrYs13xQSfe
	vpZX5WMoVQzRZfX00k4/Y9v7BQGQwLFQoqtIcI4qaw2CGmEvUbtov/3720NjA/Y8yvenw==
X-Received: by 2002:a05:6512:b8b:b0:598:fac0:69b4 with SMTP id 2adb3069b0e04-59a17d48d30mr9851193e87.40.1767000004769;
        Mon, 29 Dec 2025 01:20:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZINrJrm8cev99T4uvhhJqO9ZOSbQ+VyETxqityaYIF5p+rB7Feo6n3MXjWA4MQk6g4zNpyB9ddzRbsDaZwY8=
X-Received: by 2002:a05:6512:b8b:b0:598:fac0:69b4 with SMTP id
 2adb3069b0e04-59a17d48d30mr9851172e87.40.1767000004278; Mon, 29 Dec 2025
 01:20:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251226101816.4506-1-dannyshih@synology.com>
In-Reply-To: <20251226101816.4506-1-dannyshih@synology.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 29 Dec 2025 17:19:52 +0800
X-Gm-Features: AQt7F2qLlM8LneZ5hqRA82nO3nH2D7U0iZcK20qO9MinUrYiMXqeRLj2e24ebCY
Message-ID: <CALTww29RPghH2+x9HwtDjCAXZfgK8gBkisXNKy0k8g9d5hiV_Q@mail.gmail.com>
Subject: Re: [PATCH v2] md: suspend array while updating raid_disks via sysfs
To: dannyshih <dannyshih@synology.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi FengWei and Kuai

On Fri, Dec 26, 2025 at 6:27=E2=80=AFPM dannyshih <dannyshih@synology.com> =
wrote:
>
> From: FengWei Shih <dannyshih@synology.com>
>
> In raid1_reshape(), freeze_array() is called before modifying the r1bio
> memory pool (conf->r1bio_pool) and conf->raid_disks, and
> unfreeze_array() is called after the update is completed.
>
> However, freeze_array() only waits until nr_sync_pending and
> (nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
> occurs, nr_queued is increased and the corresponding r1bio is queued to
> either retry_list or bio_end_io_list. As a result, freeze_array() may
> unblock before these r1bios are released.

Could you explain more about this? Why can't freeze_array block when
io error occurs? If io error occurs, the nr_pending number should be
equal with nr_queued, right?

Best Regards
Xiao
>
> This can lead to a situation where conf->raid_disks and the mempool have
> already been updated while queued r1bios, allocated with the old
> raid_disks value, are later released. Consequently, free_r1bio() may
> access memory out of bounds in put_all_bios() and release r1bios of the
> wrong size to the new mempool, potentially causing issues with the
> mempool as well.
>
> Since only normal I/O might increase nr_queued while an I/O error occurs,
> suspending the array avoids this issue.
>
> Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
> the array. Therefore, we suspend the array when updating raid_disks
> via sysfs to avoid this issue too.
>
> Signed-off-by: FengWei Shih <dannyshih@synology.com>
> ---
> v2:
>   * Suspend array unconditionally when updating raid_disks
>   * Refine commit message to describe the issue more concretely
> ---
>  drivers/md/md.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e5922a682953..6bcbe1c7483c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4407,7 +4407,7 @@ raid_disks_store(struct mddev *mddev, const char *b=
uf, size_t len)
>         if (err < 0)
>                 return err;
>
> -       err =3D mddev_lock(mddev);
> +       err =3D mddev_suspend_and_lock(mddev);
>         if (err)
>                 return err;
>         if (mddev->pers)
> @@ -4432,7 +4432,7 @@ raid_disks_store(struct mddev *mddev, const char *b=
uf, size_t len)
>         } else
>                 mddev->raid_disks =3D n;
>  out_unlock:
> -       mddev_unlock(mddev);
> +       mddev_unlock_and_resume(mddev);
>         return err ? err : len;
>  }
>  static struct md_sysfs_entry md_raid_disks =3D
> --
> 2.17.1
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>

