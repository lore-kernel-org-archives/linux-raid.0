Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CAE3AB466
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 18:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746798; cv=pass; b=nlxQ8QhELUiqIetICc2hjOdBYsPnIDgoVjkMLzFpLVpFWFyzBBb6WN6/c+4nkS6EaF0o8Dcr9rRhvLR/WwR9c7pp6TBTWKnFvhM2KKUUbI9T+HE9Vu01wRDNdKxdeoZNRgx1HxmLJ2E6KyosnJ4VV1/h5uk3l+RQt/9ql60Z9g0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746798; c=relaxed/simple;
	bh=OR8lGDmhaAeDCR6cUrkUghEFDERBizZRwyMQlhX/9RA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pf4/NOMdTjB+SXVzP0/ijrUHJyRVn78CM6mTQzelQG2ei8nMMnNoj3vSvgr3jORzvFe/DcSffO8vdUbLp/XvazaT1yn9qR2w19tIiOll2McLG01OBmpCt6KO0KrvFlLZlrvCOBSf51wtjZcoI9HUYpdVcpnR6T4bPlIytO8q4Ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=GZRDblSJ; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="GZRDblSJ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cacf197759so155000085ad.2
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 11:59:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784746796; cv=none;
        d=google.com; s=arc-20260327;
        b=YeO4/dvfElaEQigfjHbqL4XyJ5G8/ClROM9wy2XGZA6tkE48S7Hyco5h7B1cJwCm62
         EP3asCIlazZmj0aHFHJPnk1jPqZqiQq5/ragOjNz0ibc4wQvHx7u6h7A5qIsvQDIfT4b
         IJ33uZfiW4KASY4zhMdcQsmNddJ5YszxV4WxFlGsNOPBGRoCDrgOagqMaZivZcp5DR99
         MYhQnJgcaClBJV6Q1pEK87JxgQK0zgnPY+nOjyoQ4eKKw74PKLtlbhihCDWu7AGx+ed0
         jgJms+e1LrzNkiBe4ZspqMPWgSs/CpisAbA6RfbwayjyQEUSm+KJQde6t4VOFaZ8hrzS
         kUKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bLuoWCiEv6axx8ZJ0eWPaRp1LKlXkm29GSKK+KBsJ/w=;
        fh=ZrRNGOAHXp73rURWJoil67YRtO8yVJizlV5ayjRf/74=;
        b=UxsrAhnHk1C6leUWmIV0ezNZNMqZwdAHZiZmyt2QMxRddjf7ubtru1Hr5pgMLidj6U
         u0ElzAkzbYnn6GI6Ym68reDvUdGpUMsqh3wapwox1jVek1aTxytdz7KyfQohbzT/g+FE
         Zbhr5rZ/7XefF9MvCjRwzRdU76pZpi0R1SDWSb1sHD3zgiKry7wCw3E8fGNZaeBMdSCA
         v1+iHXsXlNDDsTAMyK5e2jC6pEuzVjCdb0F/MaXmGW62weJ9Q7wsQtOXfms2CnIeSao+
         K/t24EE5TMVOpX5ZvUO+NO+RvmrIi2HucNwzy7PJX1cJyi4/zZn3n2jvTliyrbbr1zek
         FpuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746796; x=1785351596; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLuoWCiEv6axx8ZJ0eWPaRp1LKlXkm29GSKK+KBsJ/w=;
        b=GZRDblSJxpfkVu9OGLvPcpIF+Kx0S/dsdjtNVu12StBiM7IsmYk0fqos/LFja1aYKI
         tKYDIun9sCkcalPO1n1bkURwucUBbDwX883OP9/S5tABONs5MQanLk+jOr0Q9paXm2iS
         nQi2t2d5DbK3i3t9+McpUf5NlC4diEkR7GQYVe6318h3OWfb8X4rHgEAr/Dt67rw6xQB
         3d8YXlUNTab6GEEdyHMkfxiL03YARUCqOgU+QOuHHyMEeBSdGvwEPF0NeW0l9f8tVjCd
         S2SkWby3p7TMdwgOgvbrjH0sxNwW/CKTnDRF+0yrt5ukgNkMTW+AX9/qX8ZybTy3srwx
         zk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746796; x=1785351596;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bLuoWCiEv6axx8ZJ0eWPaRp1LKlXkm29GSKK+KBsJ/w=;
        b=XauEOo7D/sHTHfQGOJk3rmfM+2wu0v73kc+vU9R1OqiEIyB1c4ivzRjfOC4xXA90yR
         OCQvVbNpPpKaTCWBx2G3S4m2oLJe0IsVYg58GJfnr1o8HjX40u/WaZIPtarx1+U/vvXj
         vxN45pwaO8803DiyqkJNgwM9LnVX1f2UCOq9fYNxJqlZ5xDwAPkGA5EYFa1Tu30U8dkN
         kpikX0WOBhT1vrYInLnxUS39A2IUItQIounv3JkXnpFR2ivvRYTVrw28pKdD4QMVUDhe
         sovL0GMEkDMZHr14ofwGwsovcMCCQNp+u476WnwaD769QzGBXA5zCNetEILLC3Zvxs/F
         o8VQ==
X-Forwarded-Encrypted: i=1; AHgh+RrUokvNH0ngMvS0du970Yti9BrMEx/fCP4+QqEDYdUPt7yGAXxrGjTSfb7ubXz78nrd+30djInGJx7Z@vger.kernel.org
X-Gm-Message-State: AOJu0YyqKoIvmajYEIEC0k9H5M/tLXveLb9aw58fnNcmolhliyOILG1Y
	jBHWDfbk85JdXgFFUObO6zOmP9QIFK9wGPIZPGM9k7eEv12m4ZjjbCbiAoCIWYdKoAfkE86jDAN
	krTrGQEP936fVBn9/TbTNl24CW2I2VedLJVrVq8Y6
X-Gm-Gg: AR+sD121KZ5JJ+fwfF30zH9xZwersyyaG35oZ0rBjzbTXhb5j+CO4+t0xF7HqX+QOQn
	TLXqLgPcNUe/fJ3ulmb942QfZXkTcwKWtuZAITerNtMXgMoGIyXnq8ktO4D8AmTeRGdjaOaozdi
	oX4x7BQvYTfhzrSG8tEBvsEVSk5X5ZYhUgGvKkklBSLhbvMvtjMyKWIllIEMLPcEBtQusN8CRfC
	MUvlHOwbDAG0FOHgKOdf7ZJq4pbeYlAtNzwSRMs5rR0zzz6+cL5zaWuuKchtsbJvYtO7bNtGhJC
	eCTxyP7ukIIBsIb7F5lNCnXtjHP/V9f7CHXpbFfB5xP4P++I0JwKi7fXEbyOH1bL2WMr2293VyC
	1IT0j8k6nlNqD6HZOBVsFHAmxTNs4
X-Received: by 2002:a05:6a20:c70b:b0:3c3:7427:5ed8 with SMTP id
 adf61e73a8af0-3c3ad5fc1cdmr27667795637.8.1784746796289; Wed, 22 Jul 2026
 11:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com> <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
 <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com>
In-Reply-To: <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 20:59:44 +0200
X-Gm-Features: AUfX_mwIJDNeayLFRjPiK4AAbt3mZyBzoLHgFDE5c__6SI0eByKP37ZQz-8Pukc
Message-ID: <CAPzsNDvv9eavB73xZt+LxjqLkah4CfiCJsAq-4vxDrhW13z6uw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
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

> Instead, I think it makes more sense to introduce a new BLK_STS_P2PDMA
> error and use that. ... simplifies patch 6 and 7 significantly.
> https://github.com/lsgunth/linux blk-sts-p2p-err
> Feel free to run with that.

Thank you, it is much cleaner now! v4 is built on your branch,
your patches kept under your authorship.

Two things I changed in them:
1) read patch reads bio->bi_status after bio_put(); v4 moves it
   above the put.
2) for the narrow_write_error(): a P2PDMA failure is whole-range
   and deterministic, so v4 records the whole range as a bad block
   in the completion handler instead of retrying block by block.

Mykola
