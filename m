Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9552F0C7C
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 23:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113619; cv=none; b=XBm9CiiV8LMZPeWqLHkVZ97nDUpJM3dYKThRXEOYT9PGiQbdfMtCeaqPhITgptIhuK/BTaFc+cmm/XAZQa301DInu0bx6PHAzSAiglksiAoZ/fXuwZ9avuBkuBLYGARuvTC95UsBS9VozXnPHxc66dpnv9CGjk716URNG68SXNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113619; c=relaxed/simple;
	bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ngdq9aMllKTfYJPpRzJD2V2klOxegrbQ80lXInNpcje4iqRCh5ic455GFxg3gtiyRO+vUJvZIt7t8u1wusQtjEOLWWxPxhlDvl5se8yGZXi+47587dWD3ju15PohuGlThXNnBLbeitWOHxZ3wEKoMq9H8iqtARAXKj3r9tuV1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RapJjHXY; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RapJjHXY"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3434700be69so8638319a91.1
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 15:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764113616; x=1764718416; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
        b=RapJjHXYPOdTLcYLs/FvDuCH+2uk3C4YvOZho6lQ2DUunXzuffgOyrJJdJTT+zKarB
         Y5bxS7QTjTICzx73EqYjfUkyl0FVw4x9IAxmcOzG0aCf9aVAGcQLF+SDf8po/2gyqqil
         u+gb4VscO1GMmQtuJOgEikKXerndt1NLulnw2mreQGqo90I/pv4WCBVSlk7wWQqvo0fD
         8ZxKliCAngF8pEnFcZP66ohQJSs5e4FCjllfn5lHxNKjvERABRh6B4AROdQzHDTgEkH+
         MWlBTtaGwqr/gZ+ENsb+GNvzwbp76+nYbH4gEUbWlRmpDTMmG7owIjbQdwNz9RDxBy+J
         8lnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113616; x=1764718416;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rkC5tVLIYNbT+NJhSO0xtU9bfDYrwdByb9M2iU+wBw=;
        b=XP1B/xVTTLNl5Tvxbwa53KUV1GD/Q0Fu6bqgRVQK1r//jBBJ/lR1fuYNbVfdHESPTD
         AuRySYtOR/HnG9tfv1KIM2LP21xn1dUxv1+4HaSnyaYbJSkawqoWZc5iPN3bplFFUSqZ
         8dcMPGDVDspPsEXzwHr2M+6Sn1NIwZFLt/15QJBUXY4By4Jz++VpzFvh2pSELmW1q9Ve
         d/tTFKtKaLPvwbzYXazzOYcBxrJmNwIbdu4Vunpu1mKAj8HAhvq7NyIKCJLxu9q8xeyP
         sE9OpDWbIrOMMQrVhKMkWnAAbNGnRgOoIIcihHUCB8bUF5z7VqP+MembXdwTffONHa22
         jl3g==
X-Forwarded-Encrypted: i=1; AJvYcCVb3N5M5G0HeprUC6lrfSQFNXmTtsDV5x1MacEX61Tq7EHLH3iM6/i1GtJCFNExLhul6YzTpWcQXJff@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3Biy6aAtLh7dwPY7u/LaLZeW9YTVg0J088qMECFSt40FD2mqo
	ZuQENKLcqDcsJjfdsDawUeu1e3sRIp2ywInEfcFmMtJWie0P7iWMQfm+
X-Gm-Gg: ASbGncuJJI/G9jyDVvGRJLFZmtKz6304R8YMz1Tp2RORHlLVMT+Vc/rdQ5BxNALTOoU
	E3hOMUOKoR/TioKx2wWsjPi61N8ZhjJR83BJyMk5fGaIoCwzYYL7bJAaoVmZGTzW9LDG9ltS4j9
	goNKMfjb3lZRqnWB5p1lbKAr38Nb936VmRU63sabrljVmo5HFpwcczEYCvfoRvXe4gY0dMek3dP
	5AH5kSrbyLZ8x9Y4OMWPlML6fFPJswN/ZIeDagYUAynGHbmHVIgVwAKbQYcE5QhY9v5VSVxRdJZ
	DZW9VXdstYOHOqVbsZ0hg7ajE99GsSOhk0OBKt9swSz2LKVqs6pclxd6FviNWZaAzbhAlO6L+EZ
	SO5ZyreIWv1PsDOk62i9tJOeS7u+wRt6ssyK0Tv9isW83zGGp2qzbfxODiWzRD94hHUq2ccleT1
	vtQWpoPf7hU3tz+aPW3Hsj1ElGBtU=
X-Google-Smtp-Source: AGHT+IGN2yQvKPDnQSI+rfi8GFgwmIi2Dp/WjRDvh8wa+7M3RBmYm0POoYwrQhejduq1ue9sQHFv6Q==
X-Received: by 2002:a17:90b:3a4e:b0:33f:ebc2:645 with SMTP id 98e67ed59e1d1-3475ed448a0mr4374100a91.20.1764113616140;
        Tue, 25 Nov 2025 15:33:36 -0800 (PST)
Received: from [192.168.0.233] ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3475ff0eae4sm1654152a91.4.2025.11.25.15.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:33:35 -0800 (PST)
Message-ID: <2146e663be965ee0d7ef446c7c716d1c77a8a416.camel@gmail.com>
Subject: Re: [PATCH V2 1/5] block: ignore discard return value
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, 	chao@kernel.org, cem@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Date: Wed, 26 Nov 2025 09:33:26 +1000
In-Reply-To: <20251124025737.203571-2-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
	 <20251124025737.203571-2-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Regards,
Wilfred
