Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9113AE6E5
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 19:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746830; cv=pass; b=Kk5+V76WirNddMMupCvZtv2XkJbwUjfNNXet7GDOCD/2kKNLhRLafbSgCKMzvlaBUP6Pv1pLV3F5EtG6A0O3HuTU1FvzqyBdtey4vIIKtlW4CYPQP+odVRaRQSZXlwJqD8Fng80Rj66Us5uHc76YxQeOt1Q40qjU/aZmebIQZ+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746830; c=relaxed/simple;
	bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nb3QwZqq5gPMj7rjR648DW5RgJZwwlslgCI6oVuLtezQ9tKQGIaoRPQrx+IcGP8f59jg5kX2FgNdVspDOevi6VFHpSJUuEBwqITNFMDhJOiAAFm6lctgNiDZhctX9bFQUNkO4OSRuT21e9+nGc9On0VyBTk7A4QhPTDEcGgfiqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=bmx8IWw8; arc=pass smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="bmx8IWw8"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e3617ba36so7355603a91.3
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 12:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784746828; cv=none;
        d=google.com; s=arc-20260327;
        b=WiqEpZ1pPFE5g0aW8S96Ic1Z3xRUN8fYozQzzNnO0Rl0COj5vLjF/qGEM7f6AA91uv
         Nuz3Kr9cmp7OD4GndBp0fbfwjDDUoHm5u3heHm9j3yDNwog71DiUDM52ebDz/J4BFVGW
         +ODNC39a2WiiKehjuhjUNWzU94u/923vmlE+lICyhfbGhj8p6hHjoWBIiqLm63jZFuUn
         DrLwYCyR5ylWHNHVw/s6JLBCHd9grWsRi1LeqxBxB7NHv6wTSisE6Y0+yPTJMw0Z+s7R
         W9+3JHOBUTdp4nkJzNyNDuYfiyVzqU3IWIVRThSOrqEGGQZikFGlgWgEfVM4crbaL0l4
         Nsjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
        fh=h4WMSUco3uoYPKhKGx3rPwoBbGjlfPMXS340ILlhhHY=;
        b=hd+KxIpPuoGADiXyXaD51HlPx7wP9SWuIPGG6Jx5hB/bGrxkXfScMdHeJCUmroPeqD
         /O91BXJYhtjZb+Dv6SUIO4ZUgnXmHmUoHphblGV4KXGq6mEntj0zWmHAW0Vz9pkBT1Qe
         Roo3u5s89a/XvGQhkMYteK6tJ42H7IJ1tfUe+cJIKZgm6peeWerZOHQ0JFtCU6U+HGJO
         63WiZHiSJYoIfR7Y69/S3bL8qNDGf8Q2u/1IzjoFv1h47klMNZ816GsEqExuOVu3T89Q
         hDV3eg5+lPaVGv3yCVWeFVcpm6J+qKk0FHybYWQF4VqKdkj7ofQNVuGqCAblHi2tOst0
         2Jlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746828; x=1785351628; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
        b=bmx8IWw8EccXq4m0q2xSFHQsBaM7x6V5/xPOZKKKJ9H6I8O7Lq8jQnEF/cVXbC869H
         jofO3O+ROTrCELauECzFq6zSVarnp5OCXBfAmSGShwoD/+ZXWAtnt77BtELaIqs1ex8s
         JDEYbaQnaEt47S64G1iz43BPk+bRmqYGTERDiSpnKK5kpdneIOaS1REu18d15SGDbUJ+
         V90ZfDlC02gHOefOOoSra+QBljTR4RXLcm1sIarf+EQ9uE5F21HDnFwC0gQWSR8lyQFV
         ofZeMsCKBd/CMn1SA8HxJMgdEs1x/in/zXtjvOa5w8O/Ay6z8fMcIEQwFKzKRBBcajOF
         dcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746828; x=1785351628;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFNAerwWaEDD0qf52Zr8HyArocr5+58TcoObbHLHtE4=;
        b=V5+mboVDKcR5/C6nEDkMuZ9xOoVQdIqtCj2khKdT+fRNp4wSgtkU0ax6AzKcB9i2+J
         MxaReVa+NZZ/IG74ldref3dgHyQq4GiqWDcYcy9+9zmXUPWyv2T09AVgeCP53ApyFY3m
         tPyvbZVWkSoMkV0+f5KiXohCEDDZ7z4RdHuFSwJFYyfQWOjQWJIBQFmREkoQTmVgRvgo
         w5+P+mbycMIbLDSaRzIPNIDyuU6iJty0G8z+v2OUo1ISwG6W2eW8FalMPOaC/vT5eYIs
         ZOdtjl6qeww4KqTFq1qpoksC60jrCijxYUZwzIoMrT0hejzOJ0Ue9wl8WmsKvDP7G6G7
         p8GA==
X-Forwarded-Encrypted: i=1; AHgh+RohSJ62pRyrD7X3pPbHxtH2nezmLs6K7DD99MeaYHJjI9knKcgSVqXfqQy9v6H2PTzgVzoSdXP//p9p@vger.kernel.org
X-Gm-Message-State: AOJu0YzKzIkkU+hr81DDX9gDUsJDHUIevFeaobWgEGxREhhzcQOdDmsj
	03Ilu6D6y61dUV67rgawblfGyUo9cpXBckgTKJS8XTvjxehopJm10GgNyoMGz5kGFEfcpsURXr4
	Q773z4FvmbVUsn5nF6HQpb6NuEGrz8nsDza0/2n0h
X-Gm-Gg: AR+sD10Xw07eMBl3PTFkqokBN02Q8Dg5TPF5lupkwP98S0K3HuWJWVmRRjorhmOVqrR
	gOvjTuy43m72m2/mu2ycF4AhPzMuKZM+G9WA3wZQ/BngOfVSzww9FHcNObdiC2yuvBNFEBeciK0
	RpX39uAm2rTym+u4OzJUl5zVr4Lk7POCez/KxvW4mOHhOWWceyBEzLe4r6BXfLkz2+r40FUB5rl
	qYlHpWE5nSKhB8f5zmnZ12y+Z1VCjRaDm59q1Int0mupoOPve+vaY/f5pbGlmKMgFjJAjSUgZ4y
	GBuAmPBchH2wbAxfBl9Eb7klB0RnoBRuS0A19ECT+dRYa/aHO73cxVjaEf6C0Gl69A76Uqgt9he
	+wuBlTJgTuzlZfZAvMds5ueCielq8h5TKQdOX1NE=
X-Received: by 2002:a17:90a:d40f:b0:381:11eb:d78e with SMTP id
 98e67ed59e1d1-38e4b430c6emr27167946a91.14.1784746828497; Wed, 22 Jul 2026
 12:00:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com> <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
 <9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com> <20260722083015.GU110966@unreal>
In-Reply-To: <20260722083015.GU110966@unreal>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Wed, 22 Jul 2026 21:00:16 +0200
X-Gm-Features: AUfX_mx6Cta37C8DCF1XHW6rVQfC4bnrtxly1T6dzUQd_16ovjA21XsyVTPdIOg
Message-ID: <CAPzsNDuGfneEmx_nWqw5vYLyPyK8krfWChNRcsxO7icTEDDX5g@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
To: Leon Romanovsky <leon@kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> I had thoughts about this series too. It seems best to avoid
> the P2P path entirely unless all legs support P2P.
>
> Can the md/raid code determine P2P support in advance?

Yes, and it already does: the block layer ANDs the P2PDMA queue
feature across all legs, so an array with a non-P2P member
(e.g. an nvme-tcp leg) never advertises P2P at all.

But that flag can only say "this driver can do P2P in general".
md cannot see which HCA device does the DMA for a fabrics leg =E2=80=94
and with multipath failover it can change at any time.

So the up-front gate covers what is knowable up front.
This series is about the remainder.
In mixed case, one local P2P leg plus a remote replica, with it:
1) a failed read just redirects to a capable mirror;
2) a failed write records bad blocks instead of retrying forever.

Mykola
