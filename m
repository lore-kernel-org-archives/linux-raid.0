Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB581F30CC
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745313877; cv=none; b=UdrqcFhcIjgPHtMhcDHARkBn6q3Th564rrZrr+wub/fzcyHKmo4P8oLgEfx8fZyISBFCqW2uHJuOunmMMFVbWAsOWPy/QahlqaC9t8hrLj5TR1vFCHrkif626V+LKO3QLFxDQpLOMKMXm61ZLVuvCOoOTsqXRDJI/oIutDLZLqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745313877; c=relaxed/simple;
	bh=0STK1kB6cpT3txYnj3CZTAkH12iQN2gWNznIHzo0vH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q3bS+EV3U60K36zfQzy9g2OEEeOkjPE93/WeXxHChFrR813DHqClrPqsQIpnUIojE6oMNnV63hmAyi92tsRFMqiVNxfjG9f1VpVOb9J4BQnKAtOqxV5RETVdO03Xqut/10Sg1IwgpgFZYMYG4StBr0PrgHUkVH6JBZAusJ7bxX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kgj7AAcB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kgj7AAcB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745313874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KicvUXUDBMl3CYNrh3sOP2zjealtNNDlYNkAwXeVYz0=;
	b=Kgj7AAcBRzWY3MYtc8nWdMTwZpizJbr4U9MlB0++1tH3Eir7ykfeW4Q/PTq1zq3YJYbjLR
	TuSj1Z7FN/SjTpX07sEos3DM5f4M1I7FlvhOvp7AEKthWAcy9+k/NmcQR/+PTX9PRJ0gPt
	N64SgNexk7JEo2WaH1rGJ4pB/xtqjHU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-qJu5-dQIN62TDlL_GyOSNA-1; Tue, 22 Apr 2025 05:24:32 -0400
X-MC-Unique: qJu5-dQIN62TDlL_GyOSNA-1
X-Mimecast-MFC-AGG-ID: qJu5-dQIN62TDlL_GyOSNA_1745313871
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5499de68535so1667083e87.3
        for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 02:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745313871; x=1745918671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KicvUXUDBMl3CYNrh3sOP2zjealtNNDlYNkAwXeVYz0=;
        b=dNbsj/5k001bzOgmbnq6E5UwoZFIxbQxYt7HZ1VUg+chKEBaF3Lg5oG4jZPbHvAr0+
         0h1Bg7l6m1e2SMAZIwIrFsb8gTgCWesIslNrqnkvqDWkkKQu+9rd/TSh92NIeBAA5CGP
         Przqqomg+J9u72H5fauwnehLTc84KTww7r8fK+aoIqx8CH97EM7DFeSBNi7azHxGnJyN
         +82ShnNqU2snlCH4+BVYEwCAjfRgounKR27KurcUY7xyYFkpuwhwUhwMg5aP1oYJaWNg
         eSV8Hp3USKnJJiVYvnZ9s+K+4k70xrLIAVnvHNkUHsdGUxeLzfLxM6u6K6iokwiddIhO
         AxgA==
X-Gm-Message-State: AOJu0YyIjdbiZ9NsClbnh/p5uyxNYMogQt6uTBnyP/VgVp0RUrnyo7Ds
	dBQzPWxovcMfBvcHOtToE71P4XFgRI4La2ewl559x5ZTNRW1BXsOr+MSJ5f1sNjWhdN2LnTffJX
	wmoCXxQPJ0PSfTtJGQSBiVY2JxZkVIJO1j/WNbn4BVGIKfDiybJ/jmKjiJbYJIyXkKaeHLGzF/R
	GfqWEhiTDYVZtVOdR+3Z8pJhiseyhVK8oItg==
X-Gm-Gg: ASbGncszuaiONsCIEEoTM+x5JCg6Wk2WC+3fLVboeQn4HsgS+OupQhTIDjSS2xZNj6+
	tQuP9S0cNOKzmVG+FSh61FToJu34ycG3YbIeNQxDnRDJ0TgiROTRq3xmgRUMPPO6xBP/LMA==
X-Received: by 2002:a05:6512:2386:b0:54b:117c:8ef4 with SMTP id 2adb3069b0e04-54d6e675bf5mr4427151e87.55.1745313871190;
        Tue, 22 Apr 2025 02:24:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1lvD9/9utI4Dd5hK+hZnsVIMtrU1vsF7ojigf8KbwF4FC3NiODXGr7PA3Cq9JIAiHaBuJTAAfMzqCrZ1M53o=
X-Received: by 2002:a05:6512:2386:b0:54b:117c:8ef4 with SMTP id
 2adb3069b0e04-54d6e675bf5mr4427138e87.55.1745313870817; Tue, 22 Apr 2025
 02:24:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422032403.63057-1-xni@redhat.com> <20250422055108.GA29356@lst.de>
In-Reply-To: <20250422055108.GA29356@lst.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 17:24:18 +0800
X-Gm-Features: ATxdqUFWx8TMg5sCMK6RRaFQpMxVe0QGiQb9adlQKHkSqzWPwKSHPhr8SqcWre0
Message-ID: <CALTww2_r_6qO-cN50jcRt0WWZWdx2C=VDF2J7G0YHojj7HK7ig@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] md: delete gendisk in ioctl path
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai1@huaweicloud.com, 
	ming.lei@redhat.com, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 1:51=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Tue, Apr 22, 2025 at 11:24:03AM +0800, Xiao Ni wrote:
> > Now del_gendisk and put_disk are called asynchronously in workqueue wor=
k.
> > del_gendisk deletes device node by devtmpfs. devtmpfs tries to open thi=
s
> > array again and it flush the workqueue at the bigging of open process. =
So
> > a deadlock happens.
> >
> > The asynchronous way also has a problem that the device node can still
> > exist after mdadm --stop command returns in a short window. So udev rul=
e
> > can open this device node and create the struct mddev in kernel again.
> >
> > So put del_gendisk in ioctl path and still leave put_disk in
> > md_kobj_release to avoid uaf.
>
> The md lifetime rules are complicated enough as-is.  So while I won't
> object to this change per-see I'd rather have it reviewed by the md
> maintainers independently.
>
> In the meantime this should ensure devtmpfs doesn't call into
> blkdev_get_no_open and thus put_disk:
>
> diff --git a/block/bdev.c b/block/bdev.c
> index 6a34179192c9..97d4c0ab1670 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -1274,18 +1274,23 @@ void sync_bdevs(bool wait)
>   */
>  void bdev_statx(const struct path *path, struct kstat *stat, u32 request=
_mask)
>  {
> -       struct inode *backing_inode;
>         struct block_device *bdev;
>
> -       backing_inode =3D d_backing_inode(path->dentry);
> -
>         /*
> -        * Note that backing_inode is the inode of a block device node fi=
le,
> -        * not the block device's internal inode.  Therefore it is *not* =
valid
> -        * to use I_BDEV() here; the block device has to be looked up by =
i_rdev
> -        * instead.
> +        * Note that d_backing_inode() returnsthe inode of a block device=
 node
> +        * file, not the block device's internal inode.
> +        *
> +        * Therefore it is *not* valid to use I_BDEV() here; the block de=
vice
> +        * has to be looked up by i_rdev instead.
> +        *
> +        * Only do this lookup if actually needed to avoid the performanc=
e
> +        * overhead of the lookup, and to avoid injecting bdev lifetime i=
ssues
> +        * into devtmpfs.
>          */
> -       bdev =3D blkdev_get_no_open(backing_inode->i_rdev);
> +       if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
> +               return;
> +
> +       bdev =3D blkdev_get_no_open(d_backing_inode(path->dentry)->i_rdev=
);
>         if (!bdev)
>                 return;
>
>

This patch resolves this deadlock problem.
Tested-by: Xiao Ni <xni@redhat.com>

Regards
Xiao

