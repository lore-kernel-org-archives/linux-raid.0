Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D247C53362
	for <linux-raid@vger.kernel.org>; Mon, 20 May 2024 10:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716201556; cv=none; b=jn7XBVPJ74WwoaUmYg8RrpsVt6X0Q/bSVfpoSb1mZa/oJRzVni8xrBKpx72FdtTtU4IZU/P/8UEFP0EvMaP4/C2XlnimqDm+Dm96sGBL+Kyw8eTFNgs6HvbB4wmimXm4tFoBRsWzfB2xa4Wx9F2cCckjDVC5GQdw4hhMVsbWbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716201556; c=relaxed/simple;
	bh=HFgWWZL2wifN2cwpEjonm57Q/k5K+tvVYKfhgGUwrSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nkXyhqjZYnNkp64gMP3Q7pGn6xQbbpX6z30DYVFLSWG7U/XUvCxcISyTWaS46TkXpRFdRdmhch5nxHRyhfo9CvnOTnncSEdGhULujQzdQyqAIyLNWdfIrunLXJ5cEQNes9oQVgVRc2N5ioE0gxSPB5bzx9pQnzGx4Muc0BtOC2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gVxIr+/h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gVxIr+/h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716201553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RlAqBOlKtvveeTtrv4Z304b9Esia2ku08LBiVu9x3+g=;
	b=gVxIr+/hbME8jpQOyZ0vXVnooZsNUsRSgFZ1km4cdy0zDwovgMCltSzn4+4++ZSjGJXjaT
	kQO12Jcioz8xo+xhp/SCNJo+5NjpPVMUMlfTZzNgtw/mJZ34HSfqmMuWHz8ym6MHaVBl0R
	wMScRPgNFhiC1F2dz4VTVduVuLdohS0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-YjOKpcWYNbGwvViHBFWeWg-1; Mon, 20 May 2024 06:39:12 -0400
X-MC-Unique: YjOKpcWYNbGwvViHBFWeWg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1f2fbeba118so10785555ad.1
        for <linux-raid@vger.kernel.org>; Mon, 20 May 2024 03:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716201551; x=1716806351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RlAqBOlKtvveeTtrv4Z304b9Esia2ku08LBiVu9x3+g=;
        b=nblZ9a1fAKdOcFETnhUCqHz9Uc4CyLkhvK0W17Bhaj53bvAdUBcDymipRgIWx8c2zl
         jDPaJJ8kLgIvqfL007HjnyjfM0XIDNnEcVgnGYS0qY0M76Yr6rN8Uh1w22z47FQzONyt
         igMntN2gEIKvXlyHaWDPbkLtpeuWo8VxAsKJsLcXXKLGWvIFV8Jq8Kyq9Kh1ZkDP+YGX
         ibt9VaVWuKv8mP+V6969nuAFo5iQARyOw1pwP2bgHCTS1/An5rPPSjb1TO378Q+sWWZi
         ekj43j5DyT2NGPcns32vgjXqPio5i4t/h6C0oG70lT+AwZX4xb8oVVZLHrbDIQulVcMU
         ZZoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmVO2WbJZHxOiOiVeyW7c9FEZO/b7ENKh0O72CUex1lE91X1bQMtwQfiHBHgpzWbMmJCJvSM6PlBR7GgNlpZy23KIQnNTzTYjTWw==
X-Gm-Message-State: AOJu0YxS8iHJYk0qQ3vCKNFTpUjJBmJSCs7BBwdo3trsNuA7V7F3GQyK
	L/La51X/O6IGQixMplGz9SS1hOlOxYtkLVtU5pFd7LinTv3gaLLJtqMnB+AFOI7q+MqTsBQBONy
	v9SF+JoJgshsvmw0YfPzVYpHud+12fwSne1JB4UFkj9jUjxRJx0UEHtu30aoOofHiz91YcYLaUq
	iGUu0NNP8S2x7F+q6w+a32hPw5D7pfisg8ng==
X-Received: by 2002:a05:6a20:dc95:b0:1aa:6613:2387 with SMTP id adf61e73a8af0-1afde1b01femr25864177637.47.1716201551306;
        Mon, 20 May 2024 03:39:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGweEbarBn6gVZIYtzMprWTNE7rrULCXr2Qkpb5hkVGaFeKkeBNZgclYJeiXDISg78hKS6RDFcIMHNXzq2EwxY=
X-Received: by 2002:a05:6a20:dc95:b0:1aa:6613:2387 with SMTP id
 adf61e73a8af0-1afde1b01femr25864167637.47.1716201550946; Mon, 20 May 2024
 03:39:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora> <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
 <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com> <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
 <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com> <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
In-Reply-To: <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Mon, 20 May 2024 18:38:59 +0800
Message-ID: <CAGVVp+UdBekv2udwxtXBrtn0CMTrBa94oE4taUfynWncYF5ETQ@mail.gmail.com>
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>, Linux Block Devices <linux-block@vger.kernel.org>, 
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 10:55=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi, Changhui
>
> =E5=9C=A8 2024/05/20 8:39, Changhui Zhong =E5=86=99=E9=81=93:
> > [czhong@vm linux-block]$ git bisect bad
> > 060406c61c7cb4bbd82a02d179decca9c9bb3443 is the first bad commit
> > commit 060406c61c7cb4bbd82a02d179decca9c9bb3443
> > Author: Yu Kuai<yukuai3@huawei.com>
> > Date:   Thu May 9 20:38:25 2024 +0800
> >
> >      block: add plug while submitting IO
> >
> >      So that if caller didn't use plug, for example, __blkdev_direct_IO=
_simple()
> >      and __blkdev_direct_IO_async(), block layer can still benefit from=
 caching
> >      nsec time in the plug.
> >
> >      Signed-off-by: Yu Kuai<yukuai3@huawei.com>
> >      Link:https://lore.kernel.org/r/20240509123825.3225207-1-yukuai1@hu=
aweicloud.com
> >      Signed-off-by: Jens Axboe<axboe@kernel.dk>
> >
> >   block/blk-core.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
>
> Thanks for the test!
>
> I was surprised to see this blamed commit, and after taking a look at
> raid1 barrier code, I found that there are some known problems, fixed in
> raid10, while raid1 still unfixed. So I wonder this patch maybe just
> making the exist problem easier to reporduce.
>
> I'll start cooking patches to sync raid10 fixes to raid1, meanwhile,
> can you change your script to test raid10 as well, if raid10 is fine,
> I'll give you these patches later to test raid1.
>
> Thanks,
> Kuai
>

Hi=EF=BC=8C Kuai

I tested raid10 and trigger this issue too=EF=BC=8C

[  332.435340] Create raid10
[  332.573160] device-mapper: raid: Superblocks created for new raid set
[  332.595273] md/raid10:mdX: not clean -- starting background reconstructi=
on
[  332.595277] md/raid10:mdX: active with 4 out of 4 devices
[  332.597017] mdX: bitmap file is out of date, doing full recovery
[  332.603712] md: resync of RAID array mdX
[  492.173892] INFO: task mdX_resync:3092 blocked for more than 122 seconds=
.
[  492.180694]       Not tainted 6.9.0+ #1
[  492.184536] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  492.192365] task:mdX_resync      state:D stack:0     pid:3092
tgid:3092  ppid:2      flags:0x00004000
[  492.192368] Call Trace:
[  492.192370]  <TASK>
[  492.192371]  __schedule+0x222/0x670
[  492.192377]  schedule+0x2c/0xb0
[  492.192381]  raise_barrier+0xc3/0x190 [raid10]
[  492.192387]  ? __pfx_autoremove_wake_function+0x10/0x10
[  492.192392]  raid10_sync_request+0x2c3/0x1ae0 [raid10]
[  492.192397]  ? __schedule+0x22a/0x670
[  492.192398]  ? prepare_to_wait_event+0x5f/0x190
[  492.192401]  md_do_sync+0x660/0x1040
[  492.192405]  ? __pfx_autoremove_wake_function+0x10/0x10
[  492.192408]  md_thread+0xad/0x160
[  492.192410]  ? __pfx_md_thread+0x10/0x10
[  492.192411]  kthread+0xdc/0x110
[  492.192414]  ? __pfx_kthread+0x10/0x10
[  492.192416]  ret_from_fork+0x2d/0x50
[  492.192420]  ? __pfx_kthread+0x10/0x10
[  492.192421]  ret_from_fork_asm+0x1a/0x30
[  492.192424]  </TASK>

Thanks=EF=BC=8C
Changhui

