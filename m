Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE56C156CA
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 12:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755001307; cv=none; b=JumIYFoMhbDUrx6fOks95ORbMykzyfAt07whfZ2foVfvtbfZckw/IDwdZio3nfSFIIDXV5RDjUkSKt99RO4tsKK1gTK6ngCwAB66XgSQQwgYXZdFoy//xw3ul5aYQfjW8K5TIWWq4bMoRv0QT6zYXxdCBEl9RoUHnAQUASM3EIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755001307; c=relaxed/simple;
	bh=nTb3gyexUU1d3iBElb5ZCglAAa0xZKNkLLs0NPmDWgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wg5Sl8/9fDAl35u5Qroj2ut27+1FX7ehDbdSvyd/3U+w9NufeKkULHJONZOz9W2dvii0S5nIRin3KASZzzNwAIUrAEEcSWgDjB1ncVcvXVW+Sp3xP9H+7/UpPv2dptrbwSzJBpulS0kav7/Hz+whWbeRrFtoz8M1mxOGpdLX8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Md3dhjoG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Md3dhjoG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755001304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTb3gyexUU1d3iBElb5ZCglAAa0xZKNkLLs0NPmDWgg=;
	b=Md3dhjoGfleQSyrHk90NzcRQ0fglPxy07ZJ1hEuX3oT/VLiE6QqHJ/IuoqJs7jXw+2QHjx
	y0CWe9149DTU5iV+/bSGwdW+sBGygnnW+Y6UyQ96yglItgfG88buaUxmAo3GW+TkjO20Ya
	jA+ERrCWCFGhPM6AgvMyjHg++p7qwhw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-Hpvc3bDRNgOGIY_8HcikaA-1; Tue, 12 Aug 2025 08:21:41 -0400
X-MC-Unique: Hpvc3bDRNgOGIY_8HcikaA-1
X-Mimecast-MFC-AGG-ID: Hpvc3bDRNgOGIY_8HcikaA_1755001300
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55ba07af930so3291049e87.1
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 05:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755001299; x=1755606099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nTb3gyexUU1d3iBElb5ZCglAAa0xZKNkLLs0NPmDWgg=;
        b=IoyXXqnlXMq/scz8ZfKOLfpas+eHaA0VWOPjg38L0uazWY8eI9sRa2M82cvIz5vx/S
         AuEZzysE8+CtYou2Wu4Cyv7ZFtGhlufQcxsyk+qPJA7d3XyvnZBJKnECecvYA5r4Gv4a
         THjhvaAMzNpXqQz3fsFMZ7IjSa8WuExgpKxfv9YX671QHDWCrekKA3oOxidJeJZ8khZ5
         fux3k4SVdZ5slaeZZMdngE9a4BOYOwzfYuYIz8202akJ/NuWcehARPIx6Jknhos6NXTW
         xq1Jg4FTa/JNmv1yJyk4wLX+C7P5/eXtN7Shpgm02guKRKAFNF8QikZsgARMeGqKBUWH
         o/Yg==
X-Forwarded-Encrypted: i=1; AJvYcCXBpyEvlGopwsB+rBUraXB7jA8AXMrDGtTP+EMKMhBY920iDUIenRuf5a02UYFwD4oenH2V+3e9WxkO@vger.kernel.org
X-Gm-Message-State: AOJu0YyXannanhWaymF30e0U1Mt8YIvytbVgb+4FEyG0wfkEFGKjfZb5
	qLybwDbW5mZntvgqzjEqhYbIYaxF50xSWVStYoy6pN2KNC3V5I7Nd8QSzEd1elepUMjocvJIRu/
	olPb2YJxjj8FeQwaEs+wJOMEBc+dZX0BmSogZP9sDF/rVJ3hHkeNffLN3qsRleXn9Ieq0rbUxR+
	aChb/B2yMpGX/iCt6X6b1niB9ri+ltrNFlzu+dYA==
X-Gm-Gg: ASbGncs0CRiqQJDkac7rvtXmJoqxbA9TmpBHRoR70yLBohnHcPJkiFDV3fyZGsmls/6
	zL54ZTX80ZqHowEw7KOTA0h1IUgKr99bJsBUHOBK8f/g6dot+5w08YXn0TxJzRsXMx9ybE4Fmar
	6ZUwQQNxaFjH+qnRIpnjxbxQ==
X-Received: by 2002:a05:6512:3501:b0:553:d6fe:b9e7 with SMTP id 2adb3069b0e04-55cc015d53cmr5030031e87.51.1755001299408;
        Tue, 12 Aug 2025 05:21:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFE3lHtqXvfXC5DvAKmPIFW8+IrnLjeMSAahkfED5Gx7XYJtJL8GjbTtAPKIkQH8ShcWsZ5eK/oPrRnMX4BSMs=
X-Received: by 2002:a05:6512:3501:b0:553:d6fe:b9e7 with SMTP id
 2adb3069b0e04-55cc015d53cmr5030024e87.51.1755001298989; Tue, 12 Aug 2025
 05:21:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812074947.61740-1-xni@redhat.com> <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
 <CAMw=ZnSdKwvKwsfe_ajyxjobLvZZgUtApj5Lo9jXV5Bq_k76JA@mail.gmail.com>
In-Reply-To: <CAMw=ZnSdKwvKwsfe_ajyxjobLvZZgUtApj5Lo9jXV5Bq_k76JA@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 12 Aug 2025 20:21:26 +0800
X-Gm-Features: Ac12FXwmzGL4_4xUTEw6prsaEg4vGRETjktUl2VdGUv4JL9abjUpXwbVONpbBGU
Message-ID: <CALTww2-ji2wjF2_SHc=Pqt1S=ZsuFKSsnkic03DAuCc5AGQspg@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md: add legacy_async_del_gendisk mode
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, yukuai1@huaweicloud.com, 
	linux-raid@vger.kernel.org, yukuai3@huawei.com, mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Luca

On Tue, Aug 12, 2025 at 6:08=E2=80=AFPM Luca Boccassi <luca.boccassi@gmail.=
com> wrote:
>
> On Tue, 12 Aug 2025 at 10:57, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> > Maybe add a timeframe?
> >
> > md: async del_gendisk mode will be removed in Linux 6.18. Please upgrad=
e
> > to mdadm 4.5+
>
> It would be great to avoid breaking compatibility for a couple of
> years at least, please, to allow for multiple cycles of distro
> releases, and to diminish disruptions. Thanks.
>

Ok, maybe we can use Linux 7.0, is it good for you?

Best Regards
Xiao

