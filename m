Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED492BCF4C
	for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 12:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759150699; cv=none; b=l2SCzwZe9C2MiA+EYfzNnxb4jN8PGZLrNrTRLNd+uY2bCoRmjBsTTr4dIllkt5S7+VAxis2eAozVW6rCIDOCjEO8DDQig68FZT4s19PaILYwuCD2BtXDEN7ayJBq/Wx+c5IGtsOlHiDXKgXYSCqrPt4rDjES3EJJiwadfj1J0LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759150699; c=relaxed/simple;
	bh=Mrr59le1ckTN7jfXKu4ELheQN828qNR+BNfleKrpHoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KpMOBFTZEYpBpvXgUS9bceKincnD43QGTsd9X8EvgzKdhd5RATSRaLimh6mwDOrzZY/7H/uoYKRkWu2NXTkRuLvbNjGJFpTzGWRyyPYb37E/IQWJJxdV6Na+sfMDSob7WceoDbPHe4dIpf7sHlZrA1bwxsRKzqv7RELqzLMZlGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNf/iphY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNf/iphY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759150696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uDvG0B+4plh/qkbb176kBd+sSNMEQFi+MtnzVVAYCPc=;
	b=JNf/iphY/wEZbvdzEzhhR+wFIbLvC2sLS7Kf/N3m5IKAimwhllFn4Es9QEz/D29piSTv4t
	SoQZWmZeVBHQc8uDOwAMGXQyETPiJt9j7ujG2b92AXImEbsuV+9NKnP5+nbA/vt6dskIhn
	ZjWrqdEdyaRgEBHKNaiT8OkuzXYaklU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-ft6SIkVnOEiR4Vcm0YZplA-1; Mon, 29 Sep 2025 08:58:14 -0400
X-MC-Unique: ft6SIkVnOEiR4Vcm0YZplA-1
X-Mimecast-MFC-AGG-ID: ft6SIkVnOEiR4Vcm0YZplA_1759150693
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-35f62a3c170so20416271fa.0
        for <linux-raid@vger.kernel.org>; Mon, 29 Sep 2025 05:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759150693; x=1759755493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDvG0B+4plh/qkbb176kBd+sSNMEQFi+MtnzVVAYCPc=;
        b=aJQyXCqdGoK2Z77DtAy0hMNCaJv40VLLngzkID/TA2cbM4lGSQ0oYcPH/qjlVb/IqL
         zDySanJJnUGIz6O5Dc4QBalyNdo58xanQ8z49TYWxj5hw1jvyHON/3r0oHjn0x96Gag1
         DRtouD3ZKcpgQDIBAwXlYznD6fXdp+6DzKomnV5YBUESxVApX8P+NdjaX8PuP7e+TpOQ
         E96d4LQI4YTCDnxJ/JYnIxI5hguFc/0g98w40HgEEHjDQcmDHxiEBlrBSOpFYWCFoBp/
         OYe+evNkL2jiGAM5k37caoAFZJ0Ki0FVlWfBVG+LtTyPhD/9LZCdLO5jv94sbivwI2F1
         q3ng==
X-Forwarded-Encrypted: i=1; AJvYcCWGbi8q3+gpQoKMPCeLuBmGswJyuTCSrejsVL8k5yEX2Z7RuLTagrDIgRg4XpZ3JY1W1U6wW1uwgqaQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwG03p5AHvb09z5cQtCj3RMLuQVyuuD/QdpbhBgvgNkWII/kHga
	ZwesLuMAh7mJvTq62MuCt+H5ksY6T9nkamQZhwcO0OQaDDDJ03jyREmguMlCmrNT7k6z6lrKRJZ
	15hlmto92BRRFNjPyn4Rl6rkltxksVjB5RtVaw8oUvAQmWAg0N7JKhro3hjy6wzqSZSVLQmaeh4
	dX7w6aKLLktazZ2piKMtAzOgMMBbXiYPrnzehDpg==
X-Gm-Gg: ASbGncs2XN/SnEl+GUORsnpuTybuczC3DLqLaBdOJwXCC86KwS8sqUVzEEbzHmdnF29
	U9u13YnYkfAXq2obbmbdCXuYmSr+kmATpaPFgcYQnzgjVCVd5kf2D1WSyzxQrd3DKbUD32DaoDs
	VSMz2lSqiT4lqUG6tBt/zC0A==
X-Received: by 2002:a2e:be27:0:b0:336:a0bc:1fa5 with SMTP id 38308e7fff4ca-36f7f247a54mr57805151fa.27.1759150693266;
        Mon, 29 Sep 2025 05:58:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFX/UWonRRVjzSYFmRm2cPzZy85SxKB73R1ZQYUTnL0uERk19GuLNNgia0kogrHu9dxIADQJBcpmLg8Pn5CAyw=
X-Received: by 2002:a2e:be27:0:b0:336:a0bc:1fa5 with SMTP id
 38308e7fff4ca-36f7f247a54mr57805091fa.27.1759150692761; Mon, 29 Sep 2025
 05:58:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250928012424.61370-1-xni@redhat.com> <1613bd46-b757-6b4b-c891-bfb5184afbed@huaweicloud.com>
In-Reply-To: <1613bd46-b757-6b4b-c891-bfb5184afbed@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 29 Sep 2025 20:58:00 +0800
X-Gm-Features: AS18NWDtK_74OlCjhUN7Mi90v4bQMy1eLikmKhHDGEpIBcwRE_T8E2p388rh304
Message-ID: <CALTww2-qORoU6WrgpwdyS=83CAToGhvQburux5R2GCyNNKeK2w@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: delete mddev kobj before deleting gendisk kobj
To: Li Nan <linan666@huaweicloud.com>
Cc: yukuai1@huaweicloud.com, song@kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2025 at 8:45=E2=80=AFPM Li Nan <linan666@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/9/28 9:24, Xiao Ni =E5=86=99=E9=81=93:
> > In sync del gendisk path, it deletes gendisk first and the directory
> > /sys/block/md is removed. Then it releases mddev kobj in a delayed work=
.
> > If we enable debug log in sysfs_remove_group, we can see the debug log
> > 'sysfs group bitmap not found for kobject md'. It's the reason that the
> > parent kobj has been deleted, so it can't find parent directory.
> >
> > In creating path, it allocs gendisk first, then adds mddev kobj. So it
> > should delete mddev kobj before deleting gendisk.
> >
> > Before commit 9e59d609763f ("md: call del_gendisk in control path"), it
> > releases mddev kobj first. If the kobj hasn't been deleted, it does cle=
an
> > job and deletes the kobj. Then it calls del_gendisk and releases gendis=
k
>
> Looking at this part of the code, is this referring to:
>
> kobject_cleanup
>   if (kobj->state_in_sysfs)
>    __kobject_del(kobj)

Yes. it's the place.

Regards
Xiao
>
> > kobj. So it doesn't need to call kobject_del to delete mddev kobj. Afte=
r
> > this patch, in sync del gendisk path, the sequence changes. So it needs
> > to call kobject_del to delete mddev kobj.
> >
> > After this patch, the sequence is:
> > 1. kobject del mddev kobj
> > 2. del_gendisk deletes gendisk kobj
> > 3. mddev_delayed_delete releases mddev kobj
> > 4. md_kobj_release releases gendisk kobj
> >
> > Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 4e033c26fdd4..07e48faa87e0 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -887,8 +887,10 @@ void mddev_unlock(struct mddev *mddev)
> >                * do_md_stop. dm raid only uses md_stop to stop. So dm r=
aid
> >                * doesn't need to check MD_DELETED when getting reconfig=
 lock
> >                */
> > -             if (test_bit(MD_DELETED, &mddev->flags))
> > +             if (test_bit(MD_DELETED, &mddev->flags)) {
> > +                     kobject_del(&mddev->kobj);
> >                       del_gendisk(mddev->gendisk);
> > +             }
> >       }
> >   }
> >   EXPORT_SYMBOL_GPL(mddev_unlock);
>
> --
> Thanks,
> Nan
>

