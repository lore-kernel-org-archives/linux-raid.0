Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E505028B
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 13:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713794072; cv=none; b=gTKd5WpyVq9dcLdmMJ33tf1m/m0vo5rLxR1S68RA0bIdm0jXQFGa6pJ6GapVFYLD25nU11ByAmUfY8VVhb9idqePY4RRUG6hir7Ws1WBUbmj1ZCQZUeFk7cBeOiyBt97hN1BDRw7LLI6D2hCjLvYapxS8hXUxy038qGv5mGuJdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713794072; c=relaxed/simple;
	bh=2BQtsfphTTuRuURdLpcWWal4u1cVIUFRMLj0xQS2zQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c3VBq7jfOJFjUgI92W3JwgwBG51+ghl+nsRL0R3JPZ8kJiCRUpyFFnqtod+8jB2HolfBrk0CaHLAhLnbn4WKHhlAuchkn76LYAhjHmfROZ9F6Sn+C8veLp/5CLPit3mbT3V737NDI/Wgo7N+ZQm3ZGF2JMXLTN6+SZ7XLt9l7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZmxgH122; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmxgH122"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713794069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2BQtsfphTTuRuURdLpcWWal4u1cVIUFRMLj0xQS2zQU=;
	b=ZmxgH122kPllORDvIHHoeac6nhVwMptHQyiofEcCAQeNwU0w3kvGJ0ELTegBuCdrir4hNc
	947VN2sTV275ZZIGSNl9SSRpHUomHh6yFg9U2XpBJEXQvU2MWRJLj8lAOK+q7F/Yt5O5HI
	Qcj9eGDFHOeXf8eC82KpZFFviJik8WQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-O8S5GxzJNN6tROuws0ZbwQ-1; Mon, 22 Apr 2024 09:54:27 -0400
X-MC-Unique: O8S5GxzJNN6tROuws0ZbwQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2a2fdf6eb3bso5186428a91.1
        for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 06:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713794067; x=1714398867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2BQtsfphTTuRuURdLpcWWal4u1cVIUFRMLj0xQS2zQU=;
        b=RvJteQ6Vs/vFun8GV8AD5W/XnzMqMDaH5MQyvw3CPuB99z+C2zecUPg99zlbjbBRd2
         MqlV1z75xMf1BoLSeDzqKaS7v47X1ry2vtM1fj6NHSbLrF1KTQtMRZpDpetoj7ZSyoLq
         ma4uvLZkwQEH4tkdB6Kl9++bauvaDddmh0avonZK7XaNBo7m6deNuiN2gZDXzo2d4r7E
         ajhnR936Q/BDQxk7/MZATkTaK2pntDDe13jarx08coVs0DV5QVQsiN3BfUrMrdBKqX0E
         yzc0T4qDonlWbGBneokI+obT12zw9pRJwZF73eLjR5fNEnS/DABX2WC9Kindu9LtZECR
         Aycw==
X-Forwarded-Encrypted: i=1; AJvYcCWwvhBQd3Boak3hMnJSxUvDdiBAo2P7QGxPIAMd2e8e1MplWTbxInSe/feNsYvA1yw2EzMgEC7OU3AfugNHNsxLI0RVZp9jLx5N8A==
X-Gm-Message-State: AOJu0YzkUBcDljDkKtfPpFQHe5tiPEbEA1vPS0WmuYNxIlCg3D310lyh
	s25n1kb30vekDprB4PG5xH1T1j+hAtb2pslvUQ5r5OqBlV9LK983M6gKctfJRqNUv4L1mJqi/Kg
	uI7N+Zv0qufyApuNplaNYnxAE3YnoN8Jm+GalBVMfzpDSdw4qXd/4Zw/OlQBwnUteV7199qNkE1
	QzNMTtNskJSjeVXNEMkkmii+70bVSvraYteg==
X-Received: by 2002:a17:90a:a88b:b0:2a2:55de:93eb with SMTP id h11-20020a17090aa88b00b002a255de93ebmr7718555pjq.33.1713794066772;
        Mon, 22 Apr 2024 06:54:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHayWBIUYQ6jAb/CuHevGetFp9GZ8CVlCmEbnTnC4SVuLThKvPvawiAQ68BUZTNJ0tdSxUOM8QlLT1GCbX2P+M=
X-Received: by 2002:a17:90a:a88b:b0:2a2:55de:93eb with SMTP id
 h11-20020a17090aa88b00b002a255de93ebmr7718542pjq.33.1713794066461; Mon, 22
 Apr 2024 06:54:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418102321.95384-1-xni@redhat.com> <20240418102321.95384-6-xni@redhat.com>
 <20240419120555.00002b95@linux.intel.com> <CAPhsuW5SihA0czyJUdG6XNhx4c+=W_XksoQS7cJ30chkBLgW4Q@mail.gmail.com>
In-Reply-To: <CAPhsuW5SihA0czyJUdG6XNhx4c+=W_XksoQS7cJ30chkBLgW4Q@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 22 Apr 2024 21:54:14 +0800
Message-ID: <CALTww2_T1h5HpdzmTBx8N++V5wM_s4f-o7_mBcw4N0iZ5fOixA@mail.gmail.com>
Subject: Re: [PATCH 5/5] tests/01raid6integ.broken can be removed
To: Song Liu <song@kernel.org>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, linux-raid@vger.kernel.org, 
	jes@trained-monkey.org, yukuai1@huaweicloud.com, ncroxon@redhat.com, 
	colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 11:58=E2=80=AFPM Song Liu <song@kernel.org> wrote:
>
> On Fri, Apr 19, 2024 at 3:06=E2=80=AFAM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Thu, 18 Apr 2024 18:23:21 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >
> > > 01raid6integ can be run successfully with kernel 6.9.0-rc3.
> > > So remove 01raid6integ.broken.
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > I don't follow the *.broken file concept. We could also describe that i=
n comment
> > in the test, so LGTM for the changes.
> >
> > If you want to, you can remove all *.broken files and add some comments
> > in test instead. If we have some tests failing marked as broken long ti=
me ago,
> > you can either remove those scenarios as we are obiously not interested=
 in
> > fixing those scenarios.
>
> test script has options to skip broken tests (--skip-broken,
> --skip-always-broken).
> If we remove all the .broken files, we need to update the script to handl=
e
> comments in the test file.
>
> Thanks,
> Song
>

Hi all

I'll try to fix all the broken test cases this time and remove the *.broken

Thanks
Xiao

