Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F91434041E
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 20:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750575; cv=pass; b=Z8m89pYZgyqLryAnNn12aDo7gZq7vwTo+SgjeZcAfckeLF9IE+pmYIqMHkJ1vNnLrUk0Bw3svsRs2/2g9/kTCCE7svaJOZG/Vg5PGoeWZIDZeq8ou7VZ0fXwCYpMqWR01/fM+H8UFxgBEBx5MNQpOKFqnCBtZcjR0cnUBm0DvUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750575; c=relaxed/simple;
	bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=koKnGsqR+S2uf0d4UwGXZfUsbGkTYR/7j8t+2LFaPo9FgxucSj6+GKaiDJJv3BuxPIAftT2ehLAVQjCAQfJQ/y1xcs4Eh+oCuP16qJFIrUH6p/BAFDC9xXvPIW/AYBGY2tckt+uV8LSAGHHUir7jTiP7FpSDSu8jDykfXG4CpSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=fVqSFWa8; arc=pass smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="fVqSFWa8"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-383cb94f742so12194779a91.3
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 13:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784750574; cv=none;
        d=google.com; s=arc-20260327;
        b=fZplB6iCTT8akvZMUmyiEXSozSHlGoP5mCE0ixf6jDZg9mKvkZZpe2am5yA8e2PAqd
         ZOX4mtAW3P9jclYoeIz78I0NbXNViubkt1wSGCHMgKe2pcXdUcE6399SuwV4DpXY8BR6
         Bx7r3lyugILoLlB7KfOJPpdGYhhuTfwMmyz/id6Q5JFFgx2QDqQvQ93KUxpwW/zUQjtS
         /uJeeamg3WEczbv3Dl/pnOyI0K2dZO7qgKX6/c42StiGpjam28hnypqo+h5+yPqi8htB
         EECMgvZ1j/r8QDf6NR9fz2546cqCKs+Zv1TEboRObDepjo9sX1AC9d0tevbk8c4akwyF
         Kstg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
        fh=XKFvuUjyR6TpJimB7Egsu9M1AnONDj+JPw5GHabwSxo=;
        b=FLvDtX1J9ZjX5q+bQbq74+vNkJvrwdJdIujgmvPUzwjPrxNaXhX5lQIgwc6C3OIqxr
         7t+c40GhfFhNZ5ju9M21iRfIZBOges6vpUhT0zPieXSm5rNP2WJsUWVREwkzLVFh4klK
         VD+LHrGLlfZY4C7FRjSRKVTrFcXLIpKT186r86MzljS9qwfJqXbt9wbYmW3ASaHDnZw/
         SnsdtEtjU/+Z2UzOOGwMLplTD1PBHOI9CNiLmzAATtVXsx4BAWyNsXus/7mz+h40Vc9Y
         xoyQ75POQQzVFu7uyzBZqjB04SNC+1zMCE/swmAoUnZnpMUaInmgQVuMtL+WVjeyjJkf
         TiIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784750574; x=1785355374; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
        b=fVqSFWa8CR4WGP03THynVHBaqIQzRh1S9Vl7PP6rUAN/da1I02prdrIB2JF1bbV1L1
         jHKk3cp7aLmOGxcp8y0PLLD7sZMFWl7a3pBjaCJUK3J71I5PCfocLuZiopCUpIXu+sxc
         BqX6U5InP7Xn9YJ65cTQQJTHDnd3tuWpL3HpGZCceJkKdASxEA+FTIYKo03SN1HBJfms
         CP8NrqIzfmwRbKqLu0AvRKYacacnwzJh1HiFGTm2kgQbtz7nNj1TKnS4wmGAaHF+t0tR
         7Y4IFgR2kWg/Ef3Ej0Tcvd5EeTM+FiGokqFpY+964NguHyTc9n5FCXVcfXaAzqJ1xbnf
         pRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784750574; x=1785355374;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vu4r/k+6CRzm0HvAmjC2f8PLSYRb0q27NObpyU+llPc=;
        b=C/YGIhQN539yHuQ2HljlCYi4FgYactnLBWDBraIQEMrP5f5gh9/e+Q0UhGeg6lkYvQ
         ei4jxwLf9MpeEjAhqLuFxPWFClf+Nk35UJgmLJbUfceuHCeM/LYkiym2Hj+svcsVarhr
         H/8IirAoPOTyWREHMmN6yy1OGUx4+g0caOpS9uO8jaNnzwfTHvjq76+5eVrmJ4hoK3Ij
         0YP5n6peoiA4kzB3/jf2YgxCZrueIcsjXHG8n8veYv4dZYALFoe7phP0buuaavvjhIMp
         59cQx9RvXzLamq7Q3OYANZ8morznVZxUwyZDQYNYIG+i5Jm8JHuuxiB10xQfOXRUD4mn
         dtHw==
X-Forwarded-Encrypted: i=1; AHgh+RrdaLYXeUfGrbmaItGchi8t0yPr5krwiPYl2sQIpHD8nkulBtuB4NjZFkflJjHVewa6Hm+ZvGyrvvRz@vger.kernel.org
X-Gm-Message-State: AOJu0YzYfeC9SrgopLYhorx5ttX8cTyW9tm5RHXVgrfYcmt0yYtWFI4B
	Hy/+vZI9xVJfRVJLTqll0WeyyVI9M+mycqnk7aidvHK9MNP5lL80nJ4qwMcKzsF3Be4XJbweWjw
	I2fQUo7JJ1jryKp3bo0ZnMTMjNYr6CKPmJzYBbPjZ
X-Gm-Gg: AR+sD110a5o8lrh98E6KfUm0xGhQkSIckzABEK0a+06D/0iKMsYbS65VZBjqEHGRDVX
	IT9ngux4z31jRFuzo/6DyJaLiEbxI4FqE+rQkIQEr6fomYzBBYdEMYSAZrwwyMw2STQrFC5uHgB
	E33hmRbpEtDDiROJrWplXfgQCEzBdkkmqSJs9ODQWj5Hfg+iifHWr44TKoAdtb1nOE9kiqtQnd+
	sGhJj01d68tP+rDFgNawOdS6KS1WXBBw/T1UWyjzWKSfKLg0Zuqpgf9ex5NpX0FpUNXDEdmZdun
	lUig9EdfaaibJs9pOVz4oEZ5GE8DQac3mbTmQqBdrjF/uLSlZVEVNQdxM8JBzW2HNxYmObgEiIS
	lyni6Sc5IYCvsqH+SlUCqAlvGsvadv6ADaXIGb7Y=
X-Received: by 2002:a17:90b:2d10:b0:38c:a59b:5189 with SMTP id
 98e67ed59e1d1-38ec698af76mr113249a91.15.1784750573899; Wed, 22 Jul 2026
 13:02:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722185841.449934-1-mykola@meshstor.io> <20260722185841.449934-9-mykola@meshstor.io>
 <536428fd-9c23-45c3-be0a-5eaaf8f3939a@deltatee.com>
In-Reply-To: <536428fd-9c23-45c3-be0a-5eaaf8f3939a@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 22:02:41 +0200
X-Gm-Features: AUfX_my0hGYZfb89FIks6uN6jtY1SapXkJQfTk3Dh1NK0AxygDAcUpRTP3iNF6Y
Message-ID: <CAPzsNDscnb+fH0XZF3qBDgxkREmgh6F=rp0GO18Wy7gLc=4Ldw@mail.gmail.com>
Subject: Re: [PATCH v4 8/9] md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
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

> I think it would be better to
> move the code more towards similarity with raid1 instead of diverging it
> further.

I'll move bio = r10_bio->devs[slot].bio; up into the declaration so
raid10 matches raid1 in v5.

Thank you!
