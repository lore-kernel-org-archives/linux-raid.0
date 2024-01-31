Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A49EA4
	for <linux-raid@vger.kernel.org>; Wed, 31 Jan 2024 01:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706664556; cv=none; b=gEwIIFFhfuipDcRKjcKNQbq8kyKH0MFDwXx+FlQffhph5ni6Ui2WNmZ2OXcTbFG+IHAMrsz1/qh+4pSZTlVY14DAhPYMSHE5eihyc01DlYTLy7CA0+grnx5G9MW1MKx3R/fvOGYogOCF3SZ3YMFPKAoBMEkeS8D2Op48+d24+RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706664556; c=relaxed/simple;
	bh=aJlhUnCAcl/yigpRuUE3FKFXJmobkfI0YtXFMKt6Ne4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kvvRqTVLqqNNKyXo9r5FSLu32mShNJ4K+IzzVNADv9yQvkWCGqu1Ey3kxDhsYnaKVreNK9TnBMqewtJTpstyltyPZG0069Xdwy5vb24FH32NcHPTC2eUmzMsbCL2JHeKjt3qYsOR6zaEir8vEaoJ8CCLAkqPuxrWz9b0Or/VXmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+ShOc2V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+ShOc2V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706664553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JNqnrWYNhsbLxXIHidmeYKuJLzR8cqpFCLs5iG5NUIg=;
	b=b+ShOc2VM6S90hwqJVTQUVDw+akx0n3xxYQV/x4aCvn0t/aHRTD02HeoF+wZ8KDsZJVz28
	lcuR0J1xlXxEBe0+2xC6ggYfuGhr0gOZxwfV86YXe8jGUKeaCFZxQ2n4pOZ92SqidrsUsm
	BQr7PeqqmjxRcYJK6/NWJc6xFICMjYo=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-7-7VUADxNyOmZz5NYpnGbQ-1; Tue, 30 Jan 2024 20:29:11 -0500
X-MC-Unique: 7-7VUADxNyOmZz5NYpnGbQ-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6de0fc90a93so2087571b3a.3
        for <linux-raid@vger.kernel.org>; Tue, 30 Jan 2024 17:29:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706664551; x=1707269351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNqnrWYNhsbLxXIHidmeYKuJLzR8cqpFCLs5iG5NUIg=;
        b=rugdLZW67Djh+bRz2qgONhSpucVI49IW76dg9PNQztmYJOwuNT3hi31xFlcVcorMsS
         cO3zYxLHjdCi5Y58zLHpN2eozejW09vCq8LoChYdJzghNYmQ8wGMXEKlMn+lFHAoYILH
         AlisGJcFuPhw2xtegTyH7gS+gcMUWFdL3TzM5Q5lyFw5eNE1asRFD5A/8RFTV1D2z6Q2
         syenOoHZd1FZ7HFbZManY0VFcS/QjH4ZzFWGpnKlWvc4cOcPU/uM9D1rtx2NIY7fzL4U
         zbKu7a4Z+CO0YExX8DLShFZqBx2ENf9ChUuEbulS4/QyHSkWn48RSxjso606xu2hTpF2
         KtAQ==
X-Gm-Message-State: AOJu0Yzn5E1CFsSzSFVTcQb/i89SW7K7cdu0bE9IpWVjxhqrL/Ylk+hz
	b9ZMgXuBRvCqp85w+eSswfWP1X+jme/Cc5FzFl963pk0uvt6/eEQOz0KYv9Vmjq9DoDo5Dho6MY
	0rVWZtThHyL908KUiMRjRhjofhdTfMgOhnwKnyhpFF3NXs7/UHq7lwR42fBpsIlUuiIrOJGildJ
	ZkB2aQJ+WjEaE4FmDM81xRGZu6soMi/6hoJA==
X-Received: by 2002:a05:6a00:c8b:b0:6db:d4f8:bb1d with SMTP id a11-20020a056a000c8b00b006dbd4f8bb1dmr431528pfv.2.1706664550907;
        Tue, 30 Jan 2024 17:29:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFr+2mKU7NfBaA1rJF29186UvNGqzXqI+b2lGNzCcEvEyxDyhvBbMJiH6oHf82morLlvpAekP+aQ15hJyqjlbo=
X-Received: by 2002:a05:6a00:c8b:b0:6db:d4f8:bb1d with SMTP id
 a11-20020a056a000c8b00b006dbd4f8bb1dmr431511pfv.2.1706664550628; Tue, 30 Jan
 2024 17:29:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240130021843.3608859-1-yukuai1@huaweicloud.com>
 <CALTww29QO5kzmN6Vd+jT=-8W5F52tJjHKSgrfUc1Z1ZAeRKHHA@mail.gmail.com> <78016a94-737a-af4d-446b-c9fbef967895@huaweicloud.com>
In-Reply-To: <78016a94-737a-af4d-446b-c9fbef967895@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 31 Jan 2024 09:28:59 +0800
Message-ID: <CALTww29UKCJcvJB2BvGTbCcpvD4Y-J+Bg1WgE0nOijLNMv=RGg@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] dm-raid: fix v6.7 regressions
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, agk@redhat.com, snitzer@kernel.org, 
	dm-devel@lists.linux.dev, song@kernel.org, jbrassow@f14.redhat.com, 
	neilb@suse.de, shli@fb.com, akpm@osdl.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 9:25=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi, Xiao Ni!
>
> =E5=9C=A8 2024/01/31 8:29, Xiao Ni =E5=86=99=E9=81=93:
> > In my environment, the lvm2 regression test has passed. There are only
> > three failed cases which also fail in kernel 6.6.
> >
> > ###       failed: [ndev-vanilla] shell/lvresize-fs-crypt.sh
> > ###       failed: [ndev-vanilla] shell/pvck-dump.sh
> > ###       failed: [ndev-vanilla] shell/select-report.sh
> > ### 426 tests: 346 passed, 70 skipped, 0 timed out, 7 warned, 3 failed
> >    in 89:26.073
>
> Thanks for the test, this is greate news.
>
> Kuai
>

Hi Kuai

Have you run mdadm regression tests based on this patch set?

Regards
Xiao

