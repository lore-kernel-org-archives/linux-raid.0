Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDA119F40B
	for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 05:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751261952; cv=none; b=GqI1osRjMe3+werQOXRgrftG3rT3rb7X9hUKXFIvbPhJCl8xMktiSZWT0Vp7AsPF2LIfD98DHW/hIirgj3Lu23yUnpRv3UmO5PviaZfmdE2Obm61ovOnpowW2QG+jiagYHsFLp+FlBHP4tv55cS/pidb0dp/VgtgwmEOh49lo1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751261952; c=relaxed/simple;
	bh=STvLSvI3bXV5MRDebB+H0lDZCapJSrHCO0gwLup4t18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TlcSwxRM5nGyk1Lw0gzYrFH1JU2ZRAq5H7wIH4eIEaxJmDk2KVA5uZQl3+PxDJdvqgzqfg1fW+AYFtFdnRsC+hjD0ghhSWw4UJ3EsRbXhcKvS6WYUc5v4pujv8eXmPRRGJXcMAyYiJCMRu9G4NnVErQTNwVAs5FW/CtkeFYsSRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A+0HCYWZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+0HCYWZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751261950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H+yPkfa/82jXJdfl5P0ob1UvKY/Ai/24qnNzmbrCiio=;
	b=A+0HCYWZxxc2yKvDXlVCjbT35qK/ac/Rl8rGOrC/CoEBvLBp/Psawg6K7nOlOoS7qYUxbK
	yvkOlbHJ6cgF3b+zniG1qDnmkuR75EW0U9Y9eIq1oLJMg5Z8BTsjBHxEkEtaPrEltGIJGp
	WYh21/7XK1BAaheRwLlz6V1SZk03Brk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-fx08slNPOzyqA1qp9e-AuQ-1; Mon, 30 Jun 2025 01:39:07 -0400
X-MC-Unique: fx08slNPOzyqA1qp9e-AuQ-1
X-Mimecast-MFC-AGG-ID: fx08slNPOzyqA1qp9e-AuQ_1751261946
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-553cd66fbd8so2133819e87.2
        for <linux-raid@vger.kernel.org>; Sun, 29 Jun 2025 22:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751261945; x=1751866745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+yPkfa/82jXJdfl5P0ob1UvKY/Ai/24qnNzmbrCiio=;
        b=BhMknNtTcI5u7za7FU0n3D0t9etj0U6Cu11fX2uSTnstGj9VEsI/ceqZfWvX9VRbD2
         rWtxHmKAKkqX13tr+A/u5EEX6MfgmXOa/Ik9ZPw8kBhHzVRdTawICk7Tl2iDmSfrs2Vp
         CYZS69HrvVKJ3OweJ58WRzmwezZ9WlCukAOVNOocZyAoez3/8XY8V7eVSbQ8TGlKhFRN
         FdK9bBufr6sxUa7LLyfPMw8FI3d/7UEFShaYDbhw7N43rnJR32/D65ur6A9ibEpxkGhU
         x5mz90ItIt7FHOUnNPqiOguF02kZAGmz15EvKVkkiSn11kZOG4QNVwGQlxtwbuAxv1EA
         /IjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQEP0niH+efGb2xM34dkbVg3HjZw8eXyXR6UO2cmO8gpL98N2UufjOV+hz7mOT41pcrOiF0QqwKzh0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7kUEdRb5SpGhOBcHFgY1wcrCRTToy/AOQ/a9fypnWDGROXVj8
	Azb5hKG8fXKL4CzaUl5qvO9k+gfaU6uQH2qmeHMi6Usj9NieWftP8VP+PKmcntPgmRaE0Wb5+fR
	YhHpbCW5EWULhx5nMtbDdfEmHcW+eDnpPIkfn7ZvUv7s2JILZgkXYT25M8xpqlsMtoFsNQggvSH
	cX0BRfbqvghPn57jDueznT77HocllDIPs9cRTmXdaDhAOifeG+
X-Gm-Gg: ASbGncudgCh/MSXtvpGlcJ7hzT/H582w9GuS77MorkmUR08lfNI9jXNxUpBJjL3pMQg
	H0D01j8NQdWX3m0Iq0pcEop4Wz9CWOGab4UuKeD9o0sBdM9z/8V+b2ie7NoLDs66OLFjss9aDQd
	7bgb2n
X-Received: by 2002:a05:6512:3d1b:b0:553:a877:2bb6 with SMTP id 2adb3069b0e04-5550ba0730fmr3782279e87.34.1751261944818;
        Sun, 29 Jun 2025 22:39:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYW6eITB9oXzHFoteUCtkOjrlLnbEcb6nt1ujxuVcl5i09AgbUjF69rOeDsssQS/1+92qsKYUvxAcyfCprQzA=
X-Received: by 2002:a05:6512:3d1b:b0:553:a877:2bb6 with SMTP id
 2adb3069b0e04-5550ba0730fmr3782272e87.34.1751261944350; Sun, 29 Jun 2025
 22:39:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <808d3fb3-92a9-4a25-a70c-7408f20fb554@redhat.com> <288be678-990b-86f9-1ffd-858cee18eef3@huaweicloud.com>
 <CALTww28grnb=2tpJOG1o+rKG4rD7chjtV3Nmx9D1GJjQtVqWhA@mail.gmail.com> <3836a568-20c0-c034-7d7f-42a22fe77b4e@huaweicloud.com>
In-Reply-To: <3836a568-20c0-c034-7d7f-42a22fe77b4e@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 30 Jun 2025 13:38:52 +0800
X-Gm-Features: Ac12FXx4Gpc9GxOpUqYtSqRJhDoTCfVpAQB0w4c_fuoIjU9CWk6eJVZCjynkLGI
Message-ID: <CALTww281F6VhwfR+WRwSs0BYDdJai8aA0i9wg-gdu4emvhjFng@mail.gmail.com>
Subject: Re: [PATCH 00/23] md/llbitmap: md/md-llbitmap: introduce a new
 lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 11:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2025/06/30 11:25, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, Jun 30, 2025 at 10:34=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2025/06/30 9:59, Xiao Ni =E5=86=99=E9=81=93:
> >>>
> >>> After reading other patches, I want to check if I understand right.
> >>>
> >>> The first write sets the bitmap bit. The second write which hits the
> >>> same block (one sector, 512 bits) will call llbitmap_infect_dirty_bit=
s
> >>> to set all other bits. Then the third write doesn't need to set bitma=
p
> >>> bits. If I'm right, the comments above should say only the first two
> >>> writes have additional overhead?
> >>
> >> Yes, for the same bit, it's twice; For different bit in the same block=
,
> >> it's third, by infect all bits in the block in the second.
> >
> > For different bits in the same block, test_and_set_bit(bit,
> > pctl->dirty) should be true too, right? So it infects other bits when
> > second write hits the same block too.
>
> The dirty will be cleared after bitmap_unplug.

I understand you now. The for loop in llbitmap_set_page_dirty is used
for new writes after unplug.
> >
> > [946761.035079] llbitmap_set_page_dirty:390 page[0] offset 2024, block =
3
> > [946761.035430] llbitmap_state_machine:646 delay raid456 initial recove=
ry
> > [946761.035802] llbitmap_state_machine:652 bit 1001 state from 0 to 3
> > [946761.036498] llbitmap_set_page_dirty:390 page[0] offset 2025, block =
3
> > [946761.036856] llbitmap_set_page_dirty:403 call llbitmap_infect_dirty_=
bits
> >
> > As the debug logs show, different bits in the same block, the second
> > write (offset 2025) infects other bits.
> >
> >>
> >>    For Reload action, if the bitmap bit is
> >>> NeedSync, the changed status will be x. It can't trigger resync/recov=
ery.
> >>
> >> This is not expected, see llbitmap_state_machine(), if old or new stat=
e
> >> is need_sync, it will trigger a resync.
> >>
> >> c =3D llbitmap_read(llbitmap, start);
> >> if (c =3D=3D BitNeedSync)
> >>    need_resync =3D true;
> >> -> for RELOAD case, need_resync is still set.
> >>
> >> state =3D state_machine[c][action];
> >> if (state =3D=3D BitNone)
> >>    continue
> >
> > If bitmap bit is BitNeedSync,
> > state_machine[BitNeedSync][BitmapActionReload] returns BitNone, so if
> > (state =3D=3D BitNone) is true, it can't set MD_RECOVERY_NEEDED and it
> > can't start sync after assembling the array.
>
> You missed what I said above that llbitmap_read() will trigger resync as
> well.
> >
> >> if (state =3D=3D BitNeedSync)
> >>    need_resync =3D true;
> >>
> >>>
> >>> For example:
> >>>
> >>> cat /sys/block/md127/md/llbitmap/bits
> >>> unwritten 3480
> >>> clean 2
> >>> dirty 0
> >>> need sync 510
> >>>
> >>> It doesn't do resync after aseembling the array. Does it need to modi=
fy
> >>> the changed status from x to NeedSync?
> >>
> >> Can you explain in detail how to reporduce this? Aseembling in my VM i=
s
> >> fine.
> >
> > I added many debug logs, so the sync request runs slowly. The test I do=
:
> > mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --bitmap=3Dlockless -x 1 /dev=
/loop3
> > dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M count=3D1 seek=3D500 oflag=3Ddi=
rect
> > mdadm --stop /dev/md0 (the sync thread finishes the region that two
> > bitmap bits represent, so you can see llbitmap/bits has 510 bits (need
> > sync))
> > mdadm -As
>
> I don't quite understand, in my case, mdadm -As works fine.

Sorry for this, I forgot I removed the codes in function llbitmap_state_mac=
hine
        //if (c =3D=3D BitNeedSync)
        //  need_resync =3D true;
The reason I do this: I find if the status table changes like this, it
doesn't need to check the original status anymore
-               [BitmapActionReload]            =3D BitNone,
+               [BitmapActionReload]            =3D BitNeedSync,//?


Regards
Xiao

Xiao
> >
> > Regards
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>
> >>
> >
> >
> > .
> >
>

