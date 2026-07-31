Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC94B3D567E
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 10:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492800; cv=none; b=lQkssrSIz+22/uXfWY7vcHYUv4XTkimKEwxLCrtzOCCT9yYK5lgjhup1fMxPh2DZ9Ab9OnluSYaE3VgvUo6FVI6lyqPayz3PITgguoA61jHvaZRxUsyDjzsw65IJPojQanJ5jR8zHgVWZsjNVzNkWwrRYW4eOEgDK30x3V2ebpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492800; c=relaxed/simple;
	bh=nm6p4bCsEhzrIXzKPeWoR2zZM43GZ06pG/aSvAnZMpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQ1KQw81ueG29ZgsQCQ72P4EQc5O+ndlm+gG4kz/DTn77mCJ4tgGoyHcy9PaPazVpR+4Q+GZOdOt3kG1HDGGfxTSzeswmE2xkPfQMixqW/nKmEKr5Ss+GZZhZpp0oyX6Cs3uIh9VfbbuE45/wTHe1Bh08sxM9ks1jBBosWmGo70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=bvUCJWmC; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="bvUCJWmC"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4799b3f7c83so603192f8f.2
        for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 03:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785492789; x=1786097589; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nm6p4bCsEhzrIXzKPeWoR2zZM43GZ06pG/aSvAnZMpk=;
        b=bvUCJWmCvvAhfwL9VcKPgTtG3LsjS5yz2MD3AMOONyWT0e5/7v9JxO6XhJI0wcCnOa
         bnBjmWxcXJCXrwx47oWUIl22tntRN72eQmZMRC3DCAJ9fjQ5Eqm6b+vBnF6KOOeb/tu9
         JUzfw/bfaIc3fKdD9oFVjE6Lfu1CppmSx+m1yIE3hFJ5jwv3sY1jtIM9c8UtX5s0rNqV
         g76aHpArDP+TBB1fFn1NijpBd2riBEPpDXO/BXWG8ExCfA7pqTn7piphKcLfhkIx0PpN
         GNPVSLccgSH4ZXNzuYn9FoVpSPDkgdoFtYfogeadGCiYFHcX9TRsde/MrcOG5cgXXy14
         ruZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785492789; x=1786097589;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nm6p4bCsEhzrIXzKPeWoR2zZM43GZ06pG/aSvAnZMpk=;
        b=VHV8zGfyB0OF0U2K3V9qm6HSBWIBGjtZEO66oPIDizlm/uBKQCS9wC6tlH6aXHd4RJ
         VjaXXSvFvx1LXXtgxnmaTswAeru2NGmdNrRNEtixUkScwcZkW1pOYWLuYYnDtl/k2jZW
         THmBnhtshtlZYraeLTkc8aqOSnmhTpbvOhC8fBCiFjuKj0d3jHEoL+lwI7doSLLNd8ed
         hviBLtihpN96fNDZrE/157LVmuSPyRt378RzwxNbV2ir+OWFnA84GsRnD6Oi2mFfWXq6
         XEg7IzEOUm8VsuHRA2lcTzMpnamYd5X5V8fE61cw5jg1wahjKqitGxFG+avRD4JVRM94
         Bdyg==
X-Forwarded-Encrypted: i=1; AHgh+RrAsvmO6RqiMimU1gZoamy6eAFwxlu9MEEgEryaXJ0/JeIQw6ZNhECo3r684mbKw1D3xDTFOeELadMq@vger.kernel.org
X-Gm-Message-State: AOJu0YxRGCWiaNyixTJkPmWH1RQgZ4xPoxGkqKwXhdvQe34XGNtLxQlD
	Ks/+v/F2L0kBJ9VyGZvwK2wZhRVCkAizBzgNtjKIKoX6C0B5i/H8y23mzpoTcsQ2nw==
X-Gm-Gg: AR+sD11xPEssyG3DxX2zLIslyfCirZmvOSOBQNKynBIr3eo/FQdrIagdKdON0WojDsG
	0XkLLklp59qtdiBVrn7Ca1nhFD6R1L8kIdjzLSV4fxQsq1/2lbEnBtrDkEMRXUmnYxi0B+TCT24
	Q8HPMQK+LOfKwpWOTSe1DXq4xICWDKPcavD+oXTtg28lTsX3ugsmZ+HYvoQM+pRU0Lo3tGuOrXk
	nbYSMIGRm0yBxZmcJYloLjEu8lMcaXiSNjR84jUE/u1PQNtqo1+6hUTcmpiMFvbUtG/SKt/kF/8
	nFc5XZmJitxzraAC8EeFlFnr9p/mcSsS96QWg951BASRMAuqowe/EDoM1mcyTY3ALZcjx/SGF2m
	1yDmmtOJ20j2OARM8xTSPG6XPx0LhQY9kBONumxxkY1TTI407nfPV2J7X506TAqAJaqMmYOyoos
	hJ/5qCR39zNwrC0QTQkUzZ4sNc64owWAFXwBaZROQRxcCsv2R93WifpT25s27dVEwFfb1lVVFDz
	c8YrA27g+5rrmIba6Z3u2wnl8PtgU9L4FoPeAKioC/M2PLk4ORZraRBR5uE9ePFSfp2A6IFoTq0
	x/fU41HcDG8YcL/hwxdoU6TJa0apCeRxCs0H
X-Received: by 2002:a5d:5d89:0:b0:47f:8192:b451 with SMTP id ffacd0b85a97d-47fd2b67734mr3024558f8f.55.1785492789167;
        Fri, 31 Jul 2026 03:13:09 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41d0064sm2943140f8f.5.2026.07.31.03.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 03:13:08 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Yu Kuai <yukuai@fygo.io>
Cc: Chen Cheng <chencheng@fnnas.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Liu <song@kernel.org>
Subject: Re: [PATCH v6 0/3] md/raid10: fix r10bio width mismatches across reshape
Date: Fri, 31 Jul 2026 12:13:03 +0200
Message-ID: <20260731101305.3806801-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <9199e9d4-4023-46dc-8eda-431ce3307c88@fygo.io>
References: <20260711100352.425177-1-chencheng@fnnas.com> <9199e9d4-4023-46dc-8eda-431ce3307c88@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kuai,

Thank you for applying the series. I tested latest md-7.3 branch.

Good news: md-7.3 is completely clean on 4 -> 6 and 4 -> 5 grows.

Tested-by: Mykola Marzhan <mykola@meshstor.io>

Thanks,
Mykola
