Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0998D3ACA72
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784749829; cv=pass; b=S9kE99qWLXm/RVNyZNJ6sIV1Ix/ioiZU8JlrO2YEDv7rwc+ivMfc1M3gviV4bzigqt31B1Dj+0ZFAdFQL4gJmWTC86sufICFBuEJrG+DeVpQZLTosQWfn9doBpjHKpmfiVv6W/wYH7zUWVRtDjgMcGBxLfMnAey6Pq1AGcrCM8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784749829; c=relaxed/simple;
	bh=oCdr0VyYuWFniik+cq5m2m8gRYzMe6MoyKAYOFWNB4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C04VhQy94vlZ5/N9a24EjC8Nl4hqr6IrR/DaSME2vFbcrc/o0dP//41Dud9jpYvdsmBNO2m3iNY339K8o9FfAOfQwEkQsNYBhQ9unSBlwPAbK3jGWR3LtX56W31o7lbW3byTrISKcYTrezmhRN6EoYooACC2v1Kl3BOoXjbUFpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=YeIXLrM4; arc=pass smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="YeIXLrM4"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-382ef647e20so12510991a91.1
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 12:50:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784749827; cv=none;
        d=google.com; s=arc-20260327;
        b=Bpzqu8xhaYiro1YQ8v+Fmg1l+26d1jTKrnmWpiljTGj7iarWD5GKma45ZD6dSRaKHc
         2khYvgrRyV49DxwMVwFMBCYqKAVCgpPAPQySlwWKJju/CznHvdp3RnLaLymu63xQhzCg
         SgRTdDbTUuTQg4HmD7WtXOg6t1C0bxJTklHKs3oBVMwdGtJ0U0XsqM9Oh8E4nOjXPmu+
         7LDJ/+4F3Z+3CfogU2a8h9n2FOe1bKpD9syiCqrUnA/c3sS57au7vMHURDbCwY5F6OmG
         MpERu6YxRXfcrsX2mypLtW0vYnrfzSKOXH9CFq6EKRacCpJs+d6lGEASp4G84iTFkt3j
         aThw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=L59f6N/a3yWmzrdAG6ejPSTgLStmVPx9Cs1jpRvp2rY=;
        fh=pMexMdQAcBW3orqQW6fNpmCFppy2mb6lDqV9+YaTKNQ=;
        b=Y+D4Ajn65FWP3XrmpuDLLERgHKdiLj+P9N02+LFUqLHV2FC48qCdnzdP8F6tiBt90R
         Flzh7L7Mno22ehXr+JGE9U+hcTcsHdOvAQyq8PWYhafsgX2aOTdxfmN+YsIL5sg/7nWi
         vuhvxghEuO/I2zBdoQJli8bgJHiAJyodKDs2GRdWmhExfd4msoMRAG6vMqnmpEuNc7nk
         TzHKqESAMYbqkYl70YWlT4GIq1/2lhfWIX3NeaRMabxa93wfdrvrLcoHpvTLxfqifPFo
         lUrEelOJNSNc6P99OXFHRwZk4RjC8GQe33lhebphFqmNvAxsO8I1uKkWE6m2//NjrAyY
         TgMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784749827; x=1785354627; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L59f6N/a3yWmzrdAG6ejPSTgLStmVPx9Cs1jpRvp2rY=;
        b=YeIXLrM4K4HgxBCvURWc8JwUoFLnuTm31u0ZBw1QqoSyqXcCXd1B/ilcUDzWDg5437
         qjmIgvAvp9KTAatdM4wTzp53MVqpI6Iptu2xH2fvHG1DdIej/dRvcM/RCnWLDC/9KOuM
         1jqvVvWr0EcNNv9ol/xRweVpHmQO38bdcXge+wQDEYGrAqDjX6goVP/IyBdSht0NdeTt
         p8wiKX5yH4XTkKkZ96PP/zLgXuGb6N2J2Jrg2rMJxbfZY5RyQOwvpINnQIn9D8DGaDMf
         DK8TgMX1Av8WtyC7nH+87La9CI4wxSGfOh1IkBiAlrrbmA6kCXVtqYIREDD8aUaDidPs
         diqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784749827; x=1785354627;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L59f6N/a3yWmzrdAG6ejPSTgLStmVPx9Cs1jpRvp2rY=;
        b=oZAEwfr/Nr5nUj8EIFe8w7ZC8HAWFLrZw2JoZN+fnDa5wu+IZ/rrDoQec8cFHrnB4/
         0TQ6fHXxTLe/4xFrmnJyOBrpYkXo5PKPd25pc2HVD4oFFATUWATWVJCnUpUwYAPBqwQx
         vRM6s4a6nRvWBDaczK69pqUyAgme3PoSN1twzLNBqkf0gzSjHV0t8PdV+7pVB2IPKsjq
         Qi1IHDJvTQYem609mkoyEHMGf0Nge7Og86lVazL7U8IFPf/TtSmqAt2oMeXcHdfxvW7L
         e0+LCwDBvxRR+N40X1p6MrDh9yzZLmMW8RKJMqNu8NSq+pKWF1FL9zvGZqToCZNC40/3
         4ENg==
X-Forwarded-Encrypted: i=1; AHgh+RqcPXbjvLj96whxp+5X1Tw5ZUmbNYJ3SCVdhP7hXgb4w7Wa7yr5ud0AYQCgKs21P2zbvOF44gzK2fVH@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5o0KsPFT3qwd6TTWLUvkJY/d0OOhlaZzRC5GGTcOPSSlwlbC2
	iERuJYB299stRtDfaqtwF3izbuFCqxGbLSjAbii3oRuUAYh2W6mxLArN6KgXAtDLuajq80nWYGq
	y65G5aTzF8beYGcJJgqkk/8LYeScOyxGhfFTA9SZE
X-Gm-Gg: AR+sD13ZOLMVYAewXtdkr7Ogljnz6t3ehLiIEhHsP+vsNaBFJ1b1Zd2M7NXAZx/PaEp
	sYuMM8LaoTOMF1V2yEfdHof5QnJVeK4TYSnXLJQ6l1ONPJJZZBtn+jIzI3/rZfM8q000DLMXft4
	yM6DDZHqQdu9n3WKErcM5D9y4/BzWzv0bo/7BnE3R/g4JY2syzSmWPYcCjLCAFJh4hT4lPHE2ps
	8BdGpdfCkwiMihkQv7cquLiYW2soYJB8Es13IMSzddKJvnLLfmqXd0lD23+/gb+DG40sUHr/Zrf
	dI877f7ieLFd6Mq6l6NEqB5QX34Sqlz9JdlEeRzmvyE3JWR1ns0GWY/rymB8Am/hxOOcDYVCiUg
	kP+teC0lWaS5rbeyTC7aea0E6EShj
X-Received: by 2002:a17:90b:518c:b0:38e:b3fd:d582 with SMTP id
 98e67ed59e1d1-38ec6657a87mr93881a91.39.1784749827092; Wed, 22 Jul 2026
 12:50:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722185841.449934-1-mykola@meshstor.io> <20260722185841.449934-8-mykola@meshstor.io>
 <38c44536-51c0-43a1-b83c-b94915890aa2@deltatee.com>
In-Reply-To: <38c44536-51c0-43a1-b83c-b94915890aa2@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 21:50:14 +0200
X-Gm-Features: AUfX_mxD5xjrC5SGVG19NWXUUrwiVViRlgsz7kddupZQwNnofwkXgV0KRRHwCnM
Message-ID: <CAPzsNDtmEFf2uyJr+gSs4iw_E+LYiH5+3uojxhGMYKYku+fw+Q@mail.gmail.com>
Subject: Re: [PATCH v4 7/9] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Maybe drop my authorship from this patch.

I will do in v5. Any other changes needed?

> I'm not sure I follow the point of this new comment here.

I will drop the comment; it means the failure covers the whole bio and
won't change on retry, so we record  whole range rather than per block.
