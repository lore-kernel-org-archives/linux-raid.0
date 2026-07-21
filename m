Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E264B46E015
	for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656194; cv=pass; b=UAuTaZDjDM8wEfcLiURi8t9lBsF3PPyHRKSTQUv3KXRFJEmpqpEouStIkkSxTgM/8nkv4piJSa3lckTvbDSfvT866ria2KsMjrlsy1AiWIdVfilIrAX9z2bDHqpABmFXTa1+eEK+0ClnK6tKbVDaOUzyGXItOj1ERgzTpvi96aU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656194; c=relaxed/simple;
	bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rzv9GAiPwBRPqrzj0H4vgHUulW/OsXHY7EwahK4HuQURrQo9LOGigDtSW77NvdNhpUSSMVAtXoY2Ax/sfi8UuNY+8tCsi7FwslYpDU6+YCYXUZ77SxORwr8XCg9jsApKS3qNAF7xiHS5ZvAXLEsLivyuaUoiGOHZCtmG3Wt3EKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ZgMFuTFb; arc=pass smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ZgMFuTFb"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38e3efab7e0so3823541a91.0
        for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 10:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784656192; cv=none;
        d=google.com; s=arc-20260327;
        b=Dx6RsRrn4E03umPnWyoj7K5Y44NlBc3U1K7guGt5JBemlU/NwrkUiPTcKkjOFjJ9lh
         tBfFCW9hhpxn6wwLB262X4onMPZpU8TxbnC/oidFUCn/1q1zRQzRo9lLyWH4cIQFUE2K
         q6MCgWEew32bmuBzOdOl0AZZD3crrywMZcC8wIOQx3yXvcw3aBDQEUB5MzKMAD1QxoyN
         Fidy/GNVEgCCdnRIt2NSUd/J+kzIP481/yCdQn4thLUHI36Oc15KpHwZm9R0K4wNwfDo
         ZO5YG2iMorJu/wvtaASYxmIKXrE7m9LvewA8IILRuy03EMFYH104oRn+9kqlftDxwvE/
         MdcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
        fh=/Ys5YoHzle8cVO2tFjF9pEo8uNAXTfFopJGaJfHn9bs=;
        b=Aksd+iFbDyc31qpxzaTUy4X9MnLNkiWhk372+O9Seo3gSV+u+CspV1Y8bfYu1hppM8
         +52BM9jrUOdev7yuphaEPoWix9xe25VqJeHq6uYKBxtmS50Dl55+VA/udu6CsVs1wXEw
         v1A+l4OorSgsZkqzqVtPLGH6y8R47Svz0/1p9ztA1qZnDC7qVwjD+utwKh2x1jJkEtA4
         oa20KucqSFwR3qzUlVruSAwoh4hI4Joehjjvaq+osOdfpXJKOdPExNE/wXhTiOZH0JwU
         lNU0kXAGzdc1avwcIPs5Mo+aKbyVDUfpkUy6soMPyzKCmscCllbFiolrv2dEEADmJ9d5
         efzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784656192; x=1785260992; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
        b=ZgMFuTFbW5QBVbDFT61DhLd/4BDvDw+gMzT8IBfdZZyGNH7U85jgysPP/UtOAsD8p1
         oQrDrEYYRQFGxDVWr2sNBrJ94LZZTjaHXd/7R8oX2iwvJ2yg+lcDGDggsUQgYcKMfty8
         asaPy468x4LdKAkguJctYH6ex+3gzJO74Lmj3b6yXxjL32RL6t4f6yW4FAaSzc70Aguz
         aUpyzzhfTxpSFH834H8daZ1SSFazWD69lfychzxJ0ve3AiiQQ5yCMVNtrB55MKE3D9yc
         bTJAxyy+rU7Of6yjIMIFJIBu0k1wJoK0Kayo1TjvTF1xxM5u46bPspr8LeDVN0niLMQS
         l/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656192; x=1785260992;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tsGHkYDWUyVUwK6j9CLOUT2+Uosgm0heWC5tQl2SEBo=;
        b=GdXqF57VctSmyvVscej2z9qDi7Cv8cj4lrg8sBaRljyvgJNlqT05M/ubPsvRhVJ8W1
         Zl0RLng5+BCmKzCL5nzl5bG4EX6HPToRguRWJf3mez1ie+DNE5nH3edz4WJ3cXSFZWC5
         y24Ej8e/fipfQnnDMYegJJbX8Jum9WSYGPizUWv/uig1QorY4xdulF4L8Drgj+4+9VAz
         h6ZVOnGyNo8NdjOLhN/CD/m76KYhJ/92hD24sg1VsRY/s9r59IUXBthRFQfLlpLABZrm
         uL95CM9LIklpH32C1GoFv65G50jUF7fH3mBqrn2oNUd2xOR++0iNiHli6fZjs/H92ITt
         LSkA==
X-Forwarded-Encrypted: i=1; AHgh+Ro2uUGsf9tWUjkvkt360pd/JmnS9bohYnAObgCc8VJCU0yUwQFDgchudukgQZvqdbQAP+fYai01WrAH@vger.kernel.org
X-Gm-Message-State: AOJu0YyGRimk3paNB2N7Tf15El4JZ/LpEC8rzbULaf+PUt0yynxeImR/
	paHUb/JNssr9MKThansogwjoDLOGC4RXQnvL8z32VQmzFZLqsal6UGqK/NdSlxbWJr6I3uLEXad
	Pc9NZoMD514eOHdDqeK/plORMevNdLzbESyyUW7hkH37+nH9mXoDaL6kf
X-Gm-Gg: AR+sD10dNesY3szSWIEn2Na43LGNevGm/4D7l6wmZQi4/z8g/u+kPmS+VpU/9WcHDgV
	IUNGLAfcv0wz6o0Ibxo9tNK2cCU0SxYqXjmJRtX8sFdNc7vlJAyB3Ig3k6RFXWVzqkMjbET1PY9
	1gBYAxD2AD7lBLAQIJAZ0mgwAjjo/ImAhAtukZrXziTatHKfDvGlpDJsBKLpNUtBmFgZRrPopP6
	XsFYE52SDZpjMkpTqmvR819un7as6SQiUQ1q3da+ChzJVwK+z2Dw8npCFOhYYWf65Se1TecWFl0
	8lbxtIiqMc8jLh5Lx/mq6H1aJQBJGEcWeTh0MEMtOBO+h39v/lBIfA==
X-Received: by 2002:a17:90b:4c81:b0:380:86d8:8162 with SMTP id
 98e67ed59e1d1-38ea37ddacbmr527514a91.18.1784656191610; Tue, 21 Jul 2026
 10:49:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-2-mykola@meshstor.io>
 <20260720144943.GA17375@lst.de> <CAPzsNDv6hUV3gHdaxuwjRcr4couUKq_M5DKObFNaYqCHnm7ZMw@mail.gmail.com>
 <b2c37f4f-79dd-428f-915a-2a862d20924c@deltatee.com> <cb297ebf-3731-425a-8f48-6be3c7944366@deltatee.com>
In-Reply-To: <cb297ebf-3731-425a-8f48-6be3c7944366@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Tue, 21 Jul 2026 19:49:39 +0200
X-Gm-Features: AUfX_mzYRDnXZ96aQ_20QUIhDQu3bcp65YEqla-rQQb3UzXkujG9BSCJpITYkqE
Message-ID: <CAPzsNDvKwg1SCDyd2Cf4SVeCMQicUPYRgBmq-0ZN9m6QjQQ74g@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] blk-mq-dma: restore BLK_STS_TARGET for unsupported
 P2P transfers
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
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

Thank you for review!

> (Arguably it might have been clearer if the switch case explicitly
> stated PCI_P2PDMA_MAP_NOT_SUPPORTED instead of relying on the
> default).

Unchanged in v3 to keep the stable backport minimal.

Mykola
