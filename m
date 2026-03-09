Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA4938F65F
	for <linux-raid@vger.kernel.org>; Mon,  9 Mar 2026 13:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773061538; cv=pass; b=Lffo513qCm+WJsWiDUMoM4b59G/I6pO5XpSULy+4JlS8fiW63GDnjvJrI+SMvU5zGehTt5GrHVYemEJmlO4Qn+xNn3rpk9goBUC6pY4+6q8VyaF/LI/x1xegjX45AxmEVCPEsdocGA5X6OBpVQGuqix2PgxaYN489hFtwtpmRBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773061538; c=relaxed/simple;
	bh=wMuW5gDlmIm6PR6YboVwzx+MAjy8kQOIpiWSdXImLDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iQaUk0CsFkLpcgcTfJv8bChBo1uKB7qgXEHCTI6LEhxVG11S5mowSORk/PlJBJUNI3uI2TYzEXBlDK5QVKDVT2bxyQGxT9yqeO5+a2UgfMWpFwa7H4gMXC2ICd1ydQgVFzhEkI+Ln267op0HHcHWhA9yh0cw0501D9+JoQG1wC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c3ulM5k5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ilRW0c0y; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c3ulM5k5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilRW0c0y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773061535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fdjwP95WxEjT9f0A8g5HgUYZsLWznbk0hS0JJm51oN8=;
	b=c3ulM5k51XHsCva/3t4nLT+g5DZVKl+rLRH+KInycuKj2dDfzQ7Rzp1KKRGm/Gg1thb4OZ
	en4LIKnzD7rV1RYcpYZJ5Acx428P949SOf17lezXU8shdxmHWpGcFrBaEDWCa2pd6Q594H
	N3+tXWbmJ134JwJ2j1YfoIlDplus23g=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-urncnNzgOpeq3hxkXQ0OfQ-1; Mon, 09 Mar 2026 09:05:32 -0400
X-MC-Unique: urncnNzgOpeq3hxkXQ0OfQ-1
X-Mimecast-MFC-AGG-ID: urncnNzgOpeq3hxkXQ0OfQ_1773061531
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a14d9e07d7so65799e87.0
        for <linux-raid@vger.kernel.org>; Mon, 09 Mar 2026 06:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773061531; cv=none;
        d=google.com; s=arc-20240605;
        b=NQ3YfKPDnEvqRT2nkUwMgAWntraoInDKFw9yRv0/HKOtKjCh5mlpnU2jKQC7XUOH4N
         hvRDnYhkffUyXSVf2zg1+/9nIXAyPMSGSYOZp5eapdCKvafomECppM4+J2OY9nf+VBdg
         7tyuQJ9y+CdnBvPZyXYEl325ROplogHvwgAPdbbq6cUUyK7vda+jg5D8Waotb9n7yn1e
         gMQXTcnjHzqGxqdDmsl6Mm0SK/aklXpyvtTxFZds/xU1uwAAwXZznJU4qYYVlAQRY4Yo
         MPCnEVjUKBc1nbn15xKMZNtYCabWDkr986zrFBYHPaEnfkSB3kmfbuUkhRRAB293eD4F
         QhUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fdjwP95WxEjT9f0A8g5HgUYZsLWznbk0hS0JJm51oN8=;
        fh=FjGraiLbzfa3MfbOV4NtgPi7Gpng18v7IGbutPWhqOk=;
        b=JbDUm0lOiNo75PTJ7vg5LcSSXCdUbxolVclQujEXYrzaXr3d/6JO3owsncbyzaZBgk
         tBnIS7TOS1Lrr0OlXrUSgpR1uiDZ0kyrevUHVG/YvTCw8b2ccyPSEJ7gR4je0bkjjp//
         26VgsoxsFUnw/nfVbkHJvqWCuwBoxyNWdrZ/qrECpfOMDhXeQTRG0jyq5qD4gAzhoPry
         1b9FDosae4BYxaf/oV0PgZ09NhdYZaAUdwVCV5B1ZlNm/oR4guiHdWUce74K1UFsy6hY
         PBxeoOEoVcIeoiOAGx+csZ9G94Dv6QoDayUSkGv/ZMt2vGFc1tX0g28wMgOZb0/MfS9R
         g/pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773061531; x=1773666331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdjwP95WxEjT9f0A8g5HgUYZsLWznbk0hS0JJm51oN8=;
        b=ilRW0c0yiL8lJ97YeaR2YqVRc+u63HOkCcYws8z2Nf5OyfBsu5c/ansV6LXdlXunka
         /2LikNYb7BrKyV9zYdDwOGsr4nI7aqePnE+VQVAXqz5Kc7vKlHSE+ZhZ/BhZmsthJm7y
         xkbOYQpSEiiInfK1sU7lDkO47W6IkVkmaae17JoyRFlsFN5qbY5dhXPYgOtdO678KCCg
         htbPaWeZdHcn95q6z/5NhHZ1KM+24fRF2N7W/j14jqqJOS2mShWRBhEZtVHTDmDREMOK
         24+YyQSPUcGv/fhLFoIsioAS2+qqux3nc27W1EPg+Tpvlsu5oy0qMAFEMkUs5HAfLRMw
         J7HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773061531; x=1773666331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fdjwP95WxEjT9f0A8g5HgUYZsLWznbk0hS0JJm51oN8=;
        b=bn97FhdiRzHDw1TzAwKkCnyCrxEIUrE7l3Nh0b9Fv4czCciUwR0VADT1rdhyBCFjIv
         v6zJI6MoFeJkmv/peQzjGMr8vZffvtf7KCFLb7IsL+ddXKAy8y6Obeh3ztnekf7PLDXK
         +6FhTLxuG6VALlWi1PuvInP50/K22ThE53VfucGkvyMEuxY80Pu02ahehUKulnA5N9e2
         d7oFi1rVV2+aDoQpCceFqkhiCbGMNsAXSA2xdaC3SOdeogFsTGaNfTbBhPegjCfy1XHh
         KGg7SV4oJo3uaQUpNOIOWM5HvumPob63fhLUbO1CvU48OBW38LiW7hhZKkOPfKTlt6IN
         gBmw==
X-Forwarded-Encrypted: i=1; AJvYcCV0A2g/Gw3E8e0yM7wUzxlPWv57Pt411tq9AM1ZHM0SxBxHryA5t8AF2gz1jg5TkmY1tVF08Nlq1yc2@vger.kernel.org
X-Gm-Message-State: AOJu0YzLFxjdjk3+wKJv9TURoy/UkwctYPnWBWAFckEP4x9GyWfmvIYZ
	FmuUr/gey/2utgBn8Wx3Akd6iEvgP2rwod/2UCNKlQv1FLGaQA3syLq0kvuPFh6YmnguP8E4x1F
	Q4/M2j2xOdfrs/njjaQ9JV7s41sBzEPIwGG5PkUdX3BV8ldLhZEHA/kRde1457O5HilYq+20GLn
	GjNHOuKXzgWkboBiDT7tZ5Z6QiaKZrLcyDg5Llpg==
X-Gm-Gg: ATEYQzz08RNcGDmACXy9Tpn0hQCpGEK6Nv1vd47Az8+p6kNui25I0szMXqxIrgnCSn+
	szmU0rx+AuVjb7Ka0TwwA8MgDyq0UNGSJMlowiJVTr2nI9m5yEUvRFsHILXB88bUc8xSss+/c9H
	7Lu3Yu4vVSfpHBsL5peYHDRy0lE7n9tcp133pU8gPZ3+ofehp7yay4pV/qFxOrSjI/koNlBLoMX
	ZX31ngC2XzV9t7dVcDcBcjC9x+LDOW6HAvsw3bVAKc+/c2AO5pyOmAMPTwd+D0j+NKbaSTh0QKK
	0Ltb4w==
X-Received: by 2002:a05:6512:1151:b0:5a1:4440:2c48 with SMTP id 2adb3069b0e04-5a144402d64mr3097894e87.12.1773061530863;
        Mon, 09 Mar 2026 06:05:30 -0700 (PDT)
X-Received: by 2002:a05:6512:1151:b0:5a1:4440:2c48 with SMTP id
 2adb3069b0e04-5a144402d64mr3097879e87.12.1773061530343; Mon, 09 Mar 2026
 06:05:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-3-yukuai@fnnas.com>
In-Reply-To: <20260223024038.3084853-3-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 9 Mar 2026 21:05:18 +0800
X-Gm-Features: AaiRm51tJ7VN8yYHgmriBHEwaMtmN8Gb4yFI748t8Gu18mufKqAsEokMFtohqvk
Message-ID: <CALTww2-oZrNS8hj+ZnBYmfxOrE6gjwqpvkWex_XCupHPCpyLBw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] md/md-llbitmap: raise barrier before state machine transition
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, colyli@fnnas.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 10:42=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Move the barrier raise operation before calling llbitmap_state_machine()
> in both llbitmap_start_write() and llbitmap_start_discard(). This
> ensures the barrier is in place before any state transitions occur,
> preventing potential race conditions where the state machine could
> complete before the barrier is properly raised.

Hi Kuai

In the above commit message, race conditions are mentioned. I want to
give an example here to check if I understand correctly.

raid1 with 2 disks is used in this case.
T0: Thread A calls llbitmap_state_machine() and state of bit is set to BitD=
irty
T1: Thread daemon calls llbitmap_daemon_work() and the state of the
bit is set to BitClean from BitDirty.
(Now the state is already wrong)
T2: Thread A calls llbitmap_raise_barrier to wait Thread daemon
finishes and go on working
T3: data is written to disk1 and disk2. A power failure occurs.
(The data on disk1 and disk2 maybe different, so a data curruption happens)

Does this case belong the race conditions you mentioned in the commit
message? Can you add one race condtion in your message?

Best Regards
Xiao

>
> Cc: stable@vger.kernel.org
> Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md-llbitmap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 30d7e36b22c4..5f9e7004e3e3 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1070,12 +1070,12 @@ static void llbitmap_start_write(struct mddev *md=
dev, sector_t offset,
>         int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>         int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>
> -       llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwri=
te);
> -
>         while (page_start <=3D page_end) {
>                 llbitmap_raise_barrier(llbitmap, page_start);
>                 page_start++;
>         }
> +
> +       llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwri=
te);
>  }
>
>  static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
> @@ -1102,12 +1102,12 @@ static void llbitmap_start_discard(struct mddev *=
mddev, sector_t offset,
>         int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>         int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>
> -       llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard)=
;
> -
>         while (page_start <=3D page_end) {
>                 llbitmap_raise_barrier(llbitmap, page_start);
>                 page_start++;
>         }
> +
> +       llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard)=
;
>  }
>
>  static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
> --
> 2.51.0
>
>

