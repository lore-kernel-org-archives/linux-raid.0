Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E771F237A
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 07:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754636532; cv=none; b=ttN2iQ/hCLjfiLsQoHozbSEpuTRyg01qV7tE9eA9mRHSUCN+DVRtuzj2iP8Y5PgcES71VTruEeaIFrXMx1i4KaztadFB4TouOfxovtxK1C3OP4LkrqgY4ky+vNmWma7qbsTNssV21QZIEYsZ+hotp8Nx4XLXO+s2QXTAne1p870=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754636532; c=relaxed/simple;
	bh=PMJj4Vxm3twqTkZX+RgGyKkyqZuxgsvAtY+Dd+4vWOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LJGNk62h7sVI6GTAj9qShqkUKVx92gPPQxas8nTjQh7vkn2igQcb8dJb4/L3kMI8TqoJC8+96UXpiXHSYqi3ZgO4T4MYDr92GeLJO3F4p1u6j2sZZmHhB5UzDgboQcrQCnzZUU3BiorERb50qvJ4XBZ1oVNSM13wcaSO7bJFzBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PXjqHz38; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PXjqHz38"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754636527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PMJj4Vxm3twqTkZX+RgGyKkyqZuxgsvAtY+Dd+4vWOQ=;
	b=PXjqHz38TwlB5FBAF+gb5kn+tErY/rZsgqZxTj3MBIc5+RolCy6cex9PSDMXsYnbwTAos3
	4mrEPLCyxp1S7VEYbu5uaNUnUjF0Nnrc/I3B99VLlveFEMiJAGaRuEfnHxqrNmH1mTkJIh
	N1GatCqZM2dSmHtgQk7Sb6rwu2xKyRM=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-Ek60PgzMNIyiSThzjmQNhw-1; Fri, 08 Aug 2025 03:02:06 -0400
X-MC-Unique: Ek60PgzMNIyiSThzjmQNhw-1
X-Mimecast-MFC-AGG-ID: Ek60PgzMNIyiSThzjmQNhw_1754636525
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-33228f0cdc6so10514131fa.2
        for <linux-raid@vger.kernel.org>; Fri, 08 Aug 2025 00:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754636524; x=1755241324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMJj4Vxm3twqTkZX+RgGyKkyqZuxgsvAtY+Dd+4vWOQ=;
        b=XN8MF91Te7LfGoyPLsE6rTaU5ntO2D2lFezKpITcM77PKteFmqO7SU0SOrgciEwaeL
         H8xbze8ZeZp/+GxvQs/oLR34n6yEhHh7FWYzF4QLmTK80giEk2P4p13DJO0E6C0RUJw4
         FodagBVf1AiM8KwXvU5TPS7oS55U03eDjJThE6pIAB+z8OCgaSKmWsa/ykKSarlUNEDf
         YnfHwOJkMP0Oxlk+IqtUN6lkj6V5hIqrUudXzb81SBbEGZBRGbKPK+gZfvE8R8PIauzL
         N1FNp/57FPxe3Y0i7TNwK8Fubxy+re5yrZb1x0VKHHCjKjGwpesBVJSJmwOls6WlzEnX
         Kx7w==
X-Forwarded-Encrypted: i=1; AJvYcCXMa+R7g/LwxxsaAeYoNyaDJZC6LMBXCPM8IlYSf9UdLf/6KGhisjBxlkfiJKRQx84zdMZkf6XK0j9i@vger.kernel.org
X-Gm-Message-State: AOJu0YybaN9KpCXDoK/dFZ7Y+F0tVFNJLVXeZHTWuF0hvK8TA+ogMyOE
	NZvHmuy3QAroN3Xg9Z661OypdSsUpGn9vVR+476xOU/LUfQb2jQZeHVdarYSyfZmEoBHiv6U8XI
	c/3ycvF1pFd7JMMXX8wOzxXZY2NaaiePNcYL6Hh2gTcX3R8g2KboKCeCnS9zfMi+PbTAr1WsiI+
	MLli2rBaehBx4Gv/kLz/48sMPqRNbmkFPJ7r5HksriTwzaug==
X-Gm-Gg: ASbGncvXYbC5MW/XPbzEKSruLaWg35EQyiQ6nlkin8jJd5DukGj3Wi3T8RXVXcAoPLl
	Zyhte5akuw7CdlxfqRqPZ8qKLsUMtf/yUCGe35hqllH9SYsOo9m4c4i041rl5pdeTjI1J8+nPep
	xKyCHGdUQwr4I8v9+1n8zdzQ==
X-Received: by 2002:a2e:ae10:0:b0:32a:7826:4d42 with SMTP id 38308e7fff4ca-333a2251fa9mr4438761fa.31.1754636523935;
        Fri, 08 Aug 2025 00:02:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGe9Z8PLwXU6mXFmQqTczmZgcYwV1EpFCDxuI3djM0AEeST2TOl4KWcSIF5uppIiGH8uB7njAV3sFeHanGpklo=
X-Received: by 2002:a2e:ae10:0:b0:32a:7826:4d42 with SMTP id
 38308e7fff4ca-333a2251fa9mr4438391fa.31.1754636523396; Fri, 08 Aug 2025
 00:02:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
 <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
 <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com>
 <8c1bf191-a741-cd7a-29dc-babf24a13777@redhat.com> <CALTww28y-cuJMAGfWjgVdjhkFB8w-z7SR48nNvdRHM01L0TGow@mail.gmail.com>
 <81648e41-fe3e-1be8-2e0e-f1f5c39564cf@huaweicloud.com>
In-Reply-To: <81648e41-fe3e-1be8-2e0e-f1f5c39564cf@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 8 Aug 2025 15:01:51 +0800
X-Gm-Features: Ac12FXyG_xF75ZTKPanTmDYeWVNkIGchC9mrx2I83ims6f3-0I7B3BhdruRddTI
Message-ID: <CALTww2_0Omt7N-U6qtPg_P9Ty1db+LbYPPdP9wTdmoc3c-yw5w@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Luca Boccassi <luca.boccassi@gmail.com>, 
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, vkuznets@redhat.com, 
	yuwatana@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 8, 2025 at 2:41=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
>
>
> =E5=9C=A8 2025/08/08 13:28, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Aug 7, 2025 at 10:18=E2=80=AFPM Mikulas Patocka <mpatocka@redha=
t.com> wrote:
> >>
> >>
> >>
> >> On Thu, 7 Aug 2025, Luca Boccassi wrote:
> >>
> >>> On Thu, 7 Aug 2025 at 01:04, Xiao Ni <xni@redhat.com> wrote:
> >>>>
> >>>> Hi all
> >>>>
> >>>> It needs to use the latest upstream mdadm
> >>>> https://github.com/md-raid-utilities/mdadm/ which has fixed this
> >>>> problem. And for fedora, it hasn't updated to the latest upstream. S=
o
> >>>> it has this problem. I'll update fedora mdadm to latest upstream.
> >>>>
> >>>> Best Regards
> >>>> Xiao
> >>>
> >>> Thank you for looking into it and providing a solution - however,
> >>> isn't it against the rules to break existing released userspace
> >>> components and requiring new versions to be released in order to use =
a
> >>> new kernel version? Is there any way this kernel patch could be
> >>> amended to avoid breaking the existing userspace as it is?
> >>>
> >>> Thanks
> >>
> >> I also think that the misbehavior should be fixed in the kernel.
> >>
> >> We shouldn't use arbitrary timeouts to clean up the sysfs entries, bec=
ause
> >> it would introduce race conditions.
> >>
> >> What about destroying the sysfs entries when the file descriptor is
> >> closed? (instead of on the STOP_ARRAY ioctl) That wouldn't interfere w=
ith
> >> other code trying to stop the array and it would make it work with the
> >> buggy mdadm that calls STOP_ARRAY and then tries to find the sysfs ent=
ries
> >> and then calls SET_ARRAY_INFO.
> >>
> >> Mikulas
> >>
> >
> > Hi all
> >
> > The assemble process is:
> > 1. create array
> > 2. stop it (STOP_ARRAY). Before the kernel change, del_gendisk is
> > called at the last release of mddev rather than in STOP_ARRAY ioctl
> > 3. access /sys/block/md0/md
> >
> > The kernel change tries to call del_gendisk in STOP_ARRAY. So /dev/md0
> > can be removed and no one can access it. If not, the array can be
> > created again because md supports create on open.
> >
> > After the kernel change, the assemble process is:
> > 1. create array
> > 2. stop it (del_gendisk runs and /sys/block/md0 is removed)
> > 3. acces /sys/block/md0/xx (it fails)
> >
> > So del_gendisk destroys sysfs entries. If we destroy sysfs entries at
> > the last release of mddev, it will return to the old state that
> > /dev/md0 can be opened after stop. I don't want to return back.
> > Because some customers encounter bugs that shutdown is stuck because
> > /dev/md0 can't be stopped and the regression test usually fails
> > because of this too.
>
> Yes, from kernel side, we think after succeed stop_array ioct, the
> kernel disk should be removed in the end. We used to call del_gendisk
> asynchronously, leaves a race window that sysfs entries still visible
> to user.
>
> We decide to fix this in the last merge window, however, it's true mdadm
> has to be fixed together.
>
> >
> > I know it's not good to break mdadm by a kernel change. But sometimes
> > it needs userspace tool and kernel work together to fix a problem,
> > right?
> > Sorry for bringing the problem, and thanks for the suggestions. Any
> > more good suggestions?
> >
>
> Idealy, we should fix mdadm first, then after a release, fix kernel.
> Sadly the transition stage is missing now. :(
>
> If we want to just avoid this problem in kernel, what I can think of is
> adding a switch and mark it deprecated for now. And in new mdadm
> releases enable that switch, and after sometime, remove mdadm legacy
> code to stop array, and finally remove the deprecated switch in kernel
> then everyone will be happy :)
>
> Thanks,
> Kuai

Hi Kuai

Thanks for the suggestion. I'll use this way.

Regards
Xiao
>
> > Best Regards
> > Xiao
> >
> >
> > .
> >
>

