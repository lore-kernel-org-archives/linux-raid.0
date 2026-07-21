Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A6415F27
	for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656327; cv=pass; b=OyxZQiq1hITMXqxwGlHLr6hz0RxVFqTxJzE9dV3TfOFOXOoLzJmSBb9LbD8O3zlc7Sfk+bQuOxzJHTIff2eB9qMnuN1p9YEIkydMTehFmbo54M+ntOc193AZFLu/Jo3Wvx6lXZk/gos8NlXnqAvOXt/iPXJtHOmbTmNsrxGe2yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656327; c=relaxed/simple;
	bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbw//QCaz7HfgvLe2fGzMKiNn8e6vs1JUPaJhS9+RPrzchQ8j+XVdRStfVaL9cg/K6XTo5EpgbBBan/124aO+oYwqC4qIO2TZgpMblpLWaOE5gzKWDo+tGRVu8M9vo29hV8uW0VqoOn0BrEKXt7VVHCwEjMqkkklxM+uo9CV4u4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ciM98YPw; arc=pass smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ciM98YPw"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-381216921aaso11061228a91.1
        for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 10:52:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784656326; cv=none;
        d=google.com; s=arc-20260327;
        b=m97ziSq2ZY5meOITGAXJ2E4kO0RQIv3Z9RX+S1DA+65LTVcsWLZtoNfH2pMxanVheU
         TiNcCq5B+yB99lc4Ifr/jC14UF+Y5AXyonvEaY9BiJgRmlF4PTaYdrQTcWFv6yVFQwfi
         2dbj6YQn04hH+Jm+uXDXGY7MHImQNbmZgmktoMjcDQ+5QmxoAJVoMppD6Va/GOGL/bD8
         lKx75PLincazX/HYQrE7eRrE1m1u/UogOxV0IRrBd4SqFr6hlZlyZdHSYpO+H1tDVM1j
         aFwfkI5MHQF7kQxSiL+odDdvo0u643zYGwtn0UpgASL4BghFFiQXYXh5kUm57XquGEzN
         TSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
        fh=eL0QM7H7A6ZIfroh3qH1LtNK39lBG/kUKFI0+sb+KXk=;
        b=fv78WlAaJHFzXxfWk7hsaRTxf7vi36mknVT0RIAaBWgV732/4W0Bok/XjyslEJaM1g
         JDy80NRWdJiAnkH0aHCsccqAVZqnNMfu1UK1r6kKXa2o6JYJpvap5UbQf+R/afECs6wn
         LydOnpAcp/09LANccrqxAKA4r07Ltt4LbcDbcANgyrMrGI1+wtW3TzcBpX+2ayj690Vl
         P1ZcP+7bAvou+AtM/M2ODvTo+K0HkrHfzArDqILZSyDUhF2ODTqeo2cpKwNzEg/rerJu
         mSgftMt7OFRW2Zc7oNRHkdwBOomxpCFOENSfa1Q1YRVtLzKZL0ZN5yOuTxgmUJCXCs5m
         V+Lg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784656326; x=1785261126; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
        b=ciM98YPwwqhVDh39wBw+AH4bzjh7xU/N/H9aik3M5yBvwF1UCf4YAQy5msJ+4GYErU
         GuzrwUMPXRtMbduUVSvtYyerXesojT+AKo6LuobEd3zGS3krQ0v3K3CiO0MoGDlvRR2d
         YwQWsf92fTVscp0PI6EsFqtvArWWi6JlPi+0lXIbcva2+LjMWSheh2y+qebh1iwX6nlv
         /zue2udrnV4TyGi1x/P02OjHk7AWixl7D0avY02fPtazPCrtdPjGHrczQoJgYws2T32j
         ci6WxZ4oInTDjyHSWWDQIN0Y9wR5ZuXOLLouoEKSkL29s6p+QTsUV+pD5bCx2RTmybWX
         MQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656326; x=1785261126;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U1weix+8QOcbtdINHI0GYDYejwzqLj6PgDCfT9nNcoc=;
        b=OZeEgFwERNTYFWqpdOo/3P4wy3Qnt4deg4KNf5MQD4WAKmwy2kWjrBsFHaeJ+VYdfK
         NINJAzpyEJ5mo20DMXF4DtDADKoPSjtUFqLyhlhRWZEHq+owBlCPwy+F1WM+B4YVjrDh
         3gnUohe/2EYCKw1SfVy24N5WU7F+VQPLcchao8OZabem/mS/+M1+SBt5kFMbsoCsZaCh
         fbEYNjIIWkJ7b7ru4vzP6NN9SBhDdRj25lITvnB9svBoN1jnofQvJY9TbZk3bJ+4xuLe
         K6vUvoiXyneA2X08/caTgbob1MMifuFHQtPDI6qMTy0meaOS778Wk3tnTvKXh2J1jFb+
         e8BA==
X-Forwarded-Encrypted: i=1; AHgh+RrddAx4zzkEmuYKWnVd11jOdzpZQJpZPQfIe9xXxcqdJAGMhxB47jiVdvDQwffc30HToHA5kjwyjVzj@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9j9gH5H9xlUBYl/nvNo8SlP3eShIp/6VRJjBcn/BpqfKKxYAK
	Y/1pKhy7WHBNGE3VqPoCNk7Xmo3qMZFVKZPAPv/SapRbbZgxCIwlMzRrrJBnFuHS0qZg2XVmrF/
	5GdYh+4iKBRoc5F0KRx0R/OG9mRVdCrIrmSV83tLq
X-Gm-Gg: AR+sD10YUY1tms8zeEoBeaOLzq6e03oB11jlOrd6RfixLx2vYhzSt5i/FwRrX+Yb1YO
	lc6xu8U1+yJTklgiSheTagcUBiEtO/yQy77nsLF0Z6MfvkM0yngZaIz3hQYOZIOHD/6wQO+Z2iR
	Zc1nIq7ih7D9faxMFNgAp5Qku2OQzP4qPB2ni340wjH3HcMjOqdQH8otjkk9Qaa6qVlZCC4beGy
	76ObEkJVUe0KyzG+mVga/s2C+8sWcrbtqpXLsoB4AWkgFzojro4limfPNm7QZjPA+UYPYYVr0gD
	VhST3+zAMiuA2vmeK5KxTqAYGjnJJ7dBBzFgkYXOk5g=
X-Received: by 2002:a17:90a:d2cb:b0:37f:ad36:8fc5 with SMTP id
 98e67ed59e1d1-38e4b515bfamr20269142a91.23.1784656326031; Tue, 21 Jul 2026
 10:52:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260718162547.448892-1-mykola@meshstor.io> <20260720124304.GE110966@unreal>
 <al5IJb-L0FpztnYz@kbusch-mbp> <20260721124944.GL110966@unreal>
In-Reply-To: <20260721124944.GL110966@unreal>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Tue, 21 Jul 2026 19:51:53 +0200
X-Gm-Features: AUfX_mzytkhLoaPSiTn9RmB0hwu7xEFpMpTLbojjFKRzqIcqMRM-jx5SaIRHGbs
Message-ID: <CAPzsNDuY9OB8FWb8aPTpxpVYC0u1ewCmFnvQXfSKQO6xqEJhBA@mail.gmail.com>
Subject: Re: [PATCH 0/6] block,md,nvme: correct handling of unsupported P2PDMA transfers
To: Leon Romanovsky <leon@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava <praan@google.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 21, 2026 at 03:49:44PM +0300, Leon Romanovsky wrote:
> Yeah, too verbose and conveys almost no useful information.
>
> Lately, I've started ignoring such submissions to prioritize commits
> from people who put real effort into explaining what they are doing.

Point taken, thank you. Please check v3, I reworked descriptions.

In any case, the problem is real, Leon, I would really appreciate if
you could review the RDMA changes.

Mykola
