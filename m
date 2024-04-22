Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C994A482C1
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 06:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713769053; cv=none; b=mJ8TFmkF7arA3rhn7/KJNWpYofT4aqdRl4/9nI6Qch3p0IjEhSZWlsLxxxzRSQrXEFKpy5P43DYs1Ekkd/BioZIINoPeiZV7R8SbAUBe7Zlmp8uYOZ+LE7ZjJvLRN4riY8nM2po2YPVyIYwPdpjWFc/A485kjaOkxTWcjcTYMVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713769053; c=relaxed/simple;
	bh=1UWDcZ30l2PQAzqqccI4wbavV8nnd1gMZTxBRahoaCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bArWzkjzAb+gCI3Dzb5eWvP7aXx7WD7WNjRcTGr5PuJpl2hUwdae5+flIGIPm276R6uuFrfmW2puMqaFsrM86LIICJbpP56j6LV4flsKgIOQ15YMYVHRwF2oN916TqXx9csxEF/v8hYro1o1JSVXyKIhZ8FW6sTpKQh8/kvNr2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KCVFG/9C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCVFG/9C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713769050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iVcqm7c7QI/j4hIN6bzmeCUGbUhJkTrQUe8csXa18K4=;
	b=KCVFG/9Cac5jjf7SpvtPGQ6jDiWK5XM1byU/EzDJI7IByLV2MtrDtJRcFl7kuJBrSDwH7Q
	vjCQ27iMWReAlUmi/cUdvLhEDuEMNqrGbka+GPIFHnPdh7rBn+QukCC2uiUq2midsWzisX
	6ehQqLfdPDCOqBEUML6Je1kaxTPog8Y=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-BkYxrs0zNs2EdhADeRDNvw-1; Mon, 22 Apr 2024 02:57:29 -0400
X-MC-Unique: BkYxrs0zNs2EdhADeRDNvw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5fff61c9444so618491a12.2
        for <linux-raid@vger.kernel.org>; Sun, 21 Apr 2024 23:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713769047; x=1714373847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iVcqm7c7QI/j4hIN6bzmeCUGbUhJkTrQUe8csXa18K4=;
        b=jr88CL/iy7BEUQoGQmLFL99BHgdhQFEtuDqbcCDSFu+aUp1kSSJtYZ4XFCP8aLw47h
         ufQ00NwO0kM8aMJtXkmWCuybHjTfHtfvT8JPybvOFACuQ4tovd6hcrctn+DDbd/m8rVq
         l60wUnoUO34fwJ+tlrCx2NnfMDZ1XykiTS0rYjucraWO5VyxDKB0KvQnlolLPwEj/2l+
         FPUg8gv6gfGNnR0ZbbuafAlIrAsp9bK1KQEi2TfKpqjODhg/URqHrSfH6ApViwAZ7JH5
         qfDdHz8VU/6QqH6IvgBrVECYNoLiH4386iluIjeSqhXjrXGCDTdTzMANxtOHVytkxh42
         b9lA==
X-Gm-Message-State: AOJu0Yy9LmZOCt52wkLB+cSwxp5b9q+otblEBRPc5DspR38Hk22HHona
	7cQFClkoeIkaeZksjIddc7U9tY7uF4B+EtAaVEjuFWsVaoGGDMD+QICyROmNn4K1AWdNiX/wncu
	dUSZLHSFez0JuikVEkYknkhaqOpLGgA+qSxrpLiGKZK7iirEMt+ABnMWdFvnAWvFCNVTgjmRo+w
	UQJvJhmRjXjoJTA7gAI/MxeN7nJdcdLLX5QLUmMUrFejOs
X-Received: by 2002:a05:6a21:1505:b0:1ad:1612:7656 with SMTP id nq5-20020a056a21150500b001ad16127656mr2748409pzb.59.1713769047755;
        Sun, 21 Apr 2024 23:57:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGESF2lJC6dnTubDMSDV4He4b3SNb3crcQsI9s+H77p4Zdffr/rB1MxarBaOyIEfUEk3HiMdC7HXsjoc05cRPo=
X-Received: by 2002:a05:6a21:1505:b0:1ad:1612:7656 with SMTP id
 nq5-20020a056a21150500b001ad16127656mr2748400pzb.59.1713769047513; Sun, 21
 Apr 2024 23:57:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418102321.95384-1-xni@redhat.com> <20240418102321.95384-3-xni@redhat.com>
 <20240419114702.0000694c@linux.intel.com>
In-Reply-To: <20240419114702.0000694c@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 22 Apr 2024 14:57:16 +0800
Message-ID: <CALTww28CNBYHrfScPgh9XCr932VeNw=WJFeXiqQM26XwE=DaKQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] tests/00createnames enhance
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org, 
	yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 5:47=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Thu, 18 Apr 2024 18:23:18 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > +     local is_super1=3D"$(mdadm -D --export $DEVNODE_NAME | grep
> > MD_METADATA=3D1.2)"
>
> You can also limit this test to super-1.2 it may depend on config, so we =
can
> specify metadata directly in create command (if it is not specified).

Could you explain more? I don't catch you here.

Regards
Xiao
>
> Mariusz
>

