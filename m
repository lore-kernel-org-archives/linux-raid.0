Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3564AEC7
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 06:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713768995; cv=none; b=cTZDvuVJkPuZySuBr3NpC8Z2brpp6LirOznFQ9/QGKcS0FfKb60x8d/QAJVLOKfKimQr3I3NbyUak6rg5l01vx/Z7Dp6FLvlEoEl1iXr8eHY9MUYiglSrz24CBfhWbSIA8nhCCXSmjkA89kvGRy4ilMhB8x4Y5oyNKt/MPxcBvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713768995; c=relaxed/simple;
	bh=sJlcfJR8J/08hIMqsWYJFZ7iJNuFuBvoV2AIPAkM+Ac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=StJQdvLuy6STn5jjRA3FqfHc97a1iA0me5dMLSXGiJ0SHAPBr0JNxJJNF2o4dtK0x8IqyDDz7DZXGpGjUo7gh9QdHGqhEd7pNThKvGo75r35RjvcyMsLlpiU6I5vaB+MOzai2ZPrZwba/EozPf5lpzvVkFzKzI+p6QstjcmBIcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hdlD0mfC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hdlD0mfC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713768992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJlcfJR8J/08hIMqsWYJFZ7iJNuFuBvoV2AIPAkM+Ac=;
	b=hdlD0mfCLnbNYEEw6IWFDBAPKiIOjszoSWik5jRPSDJITTMifQ3fKet8g7bt/ABaNsdebF
	vKs34YdpW1aIlUaplJKiIJB4cVYd6yJUdpZU/YDMA8pK+0iJD2rmijWgNBrdWvCrhtvwvk
	CWfb4XZDbiDEVU7egN5ZL8V5ajK+XiI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-ilGgsz1cMLuW5ARIRWxsRA-1; Mon, 22 Apr 2024 02:56:30 -0400
X-MC-Unique: ilGgsz1cMLuW5ARIRWxsRA-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2a49440f7b5so4509885a91.1
        for <linux-raid@vger.kernel.org>; Sun, 21 Apr 2024 23:56:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713768989; x=1714373789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJlcfJR8J/08hIMqsWYJFZ7iJNuFuBvoV2AIPAkM+Ac=;
        b=JMvHlVclj4wyyORKPU+6aTw+r4FiSy5YaBlFbtUMHau/npm8FNcFnttrC+37+6raCm
         70iws3okic3YSSkvFTGykNmMuaxLZ7uo5w0ACDInkMCXjHavR/X+DcjzDWcAiW6RKTFO
         vcLajQBHRBIRa65hqh7X5aAbrarPoHKjLT2MVCS7MgMBGTvZoYHMnQhks6wQBbHqD7SU
         aCQeuvH5rzwBstnKbqkjlzFfq/0IEfvUnsFQWPpGXT4O3oaB74NBUXGp0C+awbf6svAy
         Xf1is3o0aAE1zotb6TOkI2o5jaPYGFUWGrm9qFZv/nWbvDGT/wS+a1GHZkU+/iGY/r+i
         rTfA==
X-Gm-Message-State: AOJu0YzQlhiYxU24lqrLdvQNYtb2HSMX8jUt+xcOvU6UPNbSvPV7RCBa
	GYlmhUe+WQO1KFCqvegwa0A3ZofOblpuGWVrfdMCZESDQSngMOMek7j/qCH256CmvTuJxmfd5wM
	EDLw+YLdky1xkRWgh5fPKeYzLmD/swUITD79iCZUgJmBWheWW2nJoU21FdMP/tNLohkIgD9WUk1
	Ol3qTJFSHiVQxTcCPeSpJw0nSWuWWZ5STp/A==
X-Received: by 2002:a17:90a:588b:b0:2ad:e004:76e6 with SMTP id j11-20020a17090a588b00b002ade00476e6mr1442112pji.7.1713768988822;
        Sun, 21 Apr 2024 23:56:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfDwoMBU9inYa0DE1QipLDBNXsResY5iCV7/A7/pBhCz9hybXz7GpZCMHhZOvC7VbOLMfUBmShISDV1vBLG6Y=
X-Received: by 2002:a17:90a:588b:b0:2ad:e004:76e6 with SMTP id
 j11-20020a17090a588b00b002ade00476e6mr1442106pji.7.1713768988526; Sun, 21 Apr
 2024 23:56:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418102321.95384-1-xni@redhat.com> <20240418102321.95384-3-xni@redhat.com>
 <20240419092021.00003bc1@linux.intel.com>
In-Reply-To: <20240419092021.00003bc1@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 22 Apr 2024 14:56:17 +0800
Message-ID: <CALTww28cKpHkvAHqeKiW0iLubC0vT8473OY63TH6-JU=3jz1nw@mail.gmail.com>
Subject: Re: [PATCH 2/5] tests/00createnames enhance
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org, 
	yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 3:20=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Thu, 18 Apr 2024 18:23:18 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > Now 00createnames doesn't check Create names=3Dyes config. Without this
> > config, mdadm creates /dev/md127 device node when mdadm --create
> > /dev/md/test. With this config, it creates /dev/md_test. This patch
> > only adds the check. If it has this config, it returns directly
> > without error.
>
> Hi Xiao,
> Thanks for patches I will review them all later (probably next week).
>
> About this one:
>
> The proposed change is not complete as config may be read from both
> /etc/mdadm.conf and /etc/mdadm/mdadm.conf. Ideally, you should check them
> both in the approach you proposed.
>
> There is also possible to have /etc/mdadm.d/ directory - it is always che=
cked
> and read if exists and it cannot be disabled. See load_conffile() and
> CONFFILEFLAGS in makefile for details.

Hi Mariusz

Yes, you're right. Thanks for this.

>
> Test relies on the global configuration and user may forgot that it is se=
t.
> That will give us positive test result because test was not run due to
> configuration issue. This is risky, I would prefer fail to indicate
> that something is wrong. User can skip this test.

Ok, we can keep it the way it is.

>
> What about adding empty mdadm config to the command `-c ./mdadm_empty.con=
f`? I
> see it as the best option for now. That save use from checking 2 config
> locations and any user defined behaviors. Do you see any disadvantages?

You mean specifying config file in test case when creating raid?

>
> As config directory is not configurable we have to accept the risk that
> something could be there.
> Ideally, you can propose patch with confdir customization to apply same
> solution as for conffile (just set it to empty directory) but as it is pr=
obably
> rarely used we can accept risk here for now (unless somebody reported). I=
 give
> it up to you as it not having confdir customization is more like new
> feature.

I'll remove the adding check in the case. I think few people use the config=
 too.


>
> Another possible solution would be to learn mdadm print it's configuratio=
n and
> print it before running test and fail if not compatible setting detected.
>
> I did not realize that it would be a problem, that for catching!

Regards
Xiao
>
> Thanks,
> Mariusz
>

