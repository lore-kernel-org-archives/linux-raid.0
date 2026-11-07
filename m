Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794074178;
	b=es624LE5wnjqgDLWER6aqV3V11VxLfbbNDnmOT+7KBrwhrryH/hTC9ST7GCulfsuq2pO
	 3GVPAfT8u8hLAS+PEK8+1DVpZwWDMhWdbOkWbCWs3aeyV9HIGQKQ+hrul/WeqgXaH2jYU
	 LDxW0/6h+nXMltdFn40SU6H8rLGX1GaW6WTjV4zBc29zhM1up/AYraAwbUDRrHjEPsuPx
	 YJAFZkubtg16y8l1BfuRfczjR2c6NuCc2ZzGaeAIHh58HjHyU05N+yf/uJwhQEvRJS85b
	 FzGFIXUqREneDXRfvJhnIevmfPlCiPhnd2MX0QC5BGxx3VpYx3WgDfopfU7C8X6sLmQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794074178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=AH9LGqWfLPGgaRsP8Zicyr9XO62jY8A3Vt+hci1ouxw=;
	b=36wiS0a/a3vUP+EvzA0YHD5RUrabfcIBN0G5IPW+gB1hzLXHWpgEQCFpFT6xQpVIffX8
	 pwyKbYtu3RvEkht9YKq3B5tCSgksxIv2j8yJjudO40p92gwvlrk+brNl37cDuIG9c8xid
	 pbh19ElT70Q2MDxqYcyGyo4ZvYtyrRUX4ZAwfyQk3mIGoNUUK6z29+TPp4i0Ing6v6vFo
	 dRwVU9JOofykwGy3LX+g62u/ZTu8bhHROQOQ5NpmhsC3BNuQMWrLCRnn69g8NrNLoa+zA
	 3oJ8U/o9mHA9UClIqc+HHMXeKonAm2ihlekgud3NxyNGisLfOWxoy7TP3ZLI1jPHmDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OFnSudfd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E71A606A32C
	for <linux-raid@vger.kernel.org>; Sat,  7 Nov 2026 17:56:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E71A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OFnSudfd
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ad47c246f8so190755a91.0
        for <linux-raid@vger.kernel.org>; Sat, 07 Nov 2026 09:56:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794074178; cv=none;
        d=google.com; s=arc-20260327;
        b=RMPgLKr4WnDBfSstoR/eLhru49qNsP6c8sCcgU5yjmhhAZgFnnfxs3265oOXOMnzeu
         wBr7zf/Q5J6msPjfJ3kYZ/FzmK70HMW/rawWJHzVfKTlksKjz2eUFIeCK6uYGp+Fd3ln
         l3p6Ddrs+rLuuusEYmdHkUrfZsWLcYiie4wfD7fYGFb5T3sqNnRLQWePSuGx+oE3wGl6
         gG6FnezVmMYIqALsULiJBO2bcAAYNeIQ0PpApwstR/YMLwECXD6InRezJuPS5EXQYcCy
         vfOuKqCpMp0eY3bgp9bgZF+Zm706P38AGygOjO+JzlOYDiPn/wlVnAdE/EtNPhpSW95u
         ClJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AH9LGqWfLPGgaRsP8Zicyr9XO62jY8A3Vt+hci1ouxw=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=mMVIf9vnx3xZGRf5ryf/IaHDcVZZXKLFxh7xL9P2qKRPN6U9Ma4U0hGNL2R07soCDL
         zVNqkFsBtq/xL/PSGaG+tZ+7S5OaC8GdbNAvaJC4xialEpeHePS92bwbw1Pq51GPZ4Ga
         SiFSyOpQTA5gQYIFKoajZ5A3gQhNrbZqUSmbtsQzXmYLNfokAoskh0CxICgSbOi4ioCO
         v3psvHCsBO7BfSC2dFTkoo/UkQfkrieCZXcTxJKnaJWCuAwKp72Rw/eV9+V2BUHXF5cg
         8oX8Xasv33qWpLTOED65RQc0qJ4QGeHEs8U2yeALL4seOqweNBMZSW6XK5fc16/l5CCW
         30Fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794074178; x=1794678978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AH9LGqWfLPGgaRsP8Zicyr9XO62jY8A3Vt+hci1ouxw=;
        b=OFnSudfdOfC2FNNQxernytq2hZnxzq3liyX/zkWAzSs/ngUoc9nePQNink5SeHcb8i
         yUhsT65MwUrbkHIr4kA3G/ErGwDa+/KEua8YxKcA1aTHaRHCJXKuGCDP+BmdAjQ2fkUn
         WR1IKNQPLxlwGvYklMvkEH1QFJdgJy0v4/zgMIYs1FajYMp6OVNQkyl0EW57k3LMKXDr
         veLET5CFLGaiPnPtbDosjZMAMaHuN0aR1z2k8sIp+d2uGBaEjYGjftVvTaFYeFTN20Em
         C5FL8TOFkzp2XWg16sExnHdysJUC5SqDdCy0HFX/4Yh+G6gKMEzIiQOzAOaAtSgT0c+2
         /1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794074178; x=1794678978;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AH9LGqWfLPGgaRsP8Zicyr9XO62jY8A3Vt+hci1ouxw=;
        b=OYqqkE9yEZclz17EzpGzdUdeCKQNLwer4SiZuZUwZDL8OmaCByDlTFyCRZfoNZh+Gt
         rhd+CXsh9pBo+L/ZhP0M2lnvlZWTf5HXIlSOMzZhuFsabJwdk80X1Zx4Fkmb2kxXkU2I
         PnbxSfZnaXYf+4rLE0lQi99mKd6kbIgd/VfAUFrMrHRju89ZiCzA/mER5yiP/SRnMCL7
         a66ZNmdp5mTQvFeLSoSOEyiC0E/Gl9KsUUPzKP2+9yU64RoFgR5j2S8guzsMnXyw9o05
         n/REkl5llQtArshUGlsO7LoHnM3CxRxVWe7qymK5uxYBATQ7VJxCnDEXTuEwczDXnDIT
         CZqA==
X-Gm-Message-State: APuU4Z+Qei5pBbuMnDBqjXQ2L+hiQIlDmmGYGLDU6qv/FUCGFQ4wVsqa
	5ntobfe8voJItU/Zf4SVVoJHutMU0mTy8ri1Gkw4r3jWuHGBpOqFlNsguSZ1HeswwEdy1wDnDyQ
	1+/sYFjB4IGe4r/PNrnm9ugr9QmgoNCJg0/KvMK7HLQ==
X-Gm-Gg: AYBFou15WXnrdscEgugEnK9ElRCw5E8T2Ss4/Y5bst2zvHodyN41r8wXpforMmMEdlF
	t+xeuyyiYp7UWOpty8X1dQ+oULblkwVrWFMXO5hXnWqsI4WCYgkJdSCzzMr0NhYShEu8aDXIKR4
	0hSQcDTkgM5iY/PxzBt3V2TFiP1RhGPxTweQDv6e4DSQ5k9esI++q0RPk+bnZZ7Olnrd6kJC1Yt
	HQMj4YB8upF2TAQZERXOgmKXDaI1ruFIBVfave/GqF6PkpfPEyiovWi4dvmhssVYhH3qW1dMAsM
	qd6prHhI4yF4ZNGAFgRPUVihym8TZ7wrE7BGpIeJiX+hHnedgjr1IxXdRQ6tu0yMdCDrH5eQ+ia
	u65XX0DscLlgwql2/0lDL6Y4yc9NCVoGqjBeipw==
X-Received: by 2002:a17:90b:4a89:b0:3b0:975b:2256 with SMTP id
 98e67ed59e1d1-3b0db6f8e05mr9097288a91.4.1794074177596; Sat, 07 Nov 2026
 09:56:17 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261107164305.11476-1-lui2012qwq@gmail.com> <sashiko-outbox-203076@kernel.org>
In-Reply-To: <sashiko-outbox-203076@kernel.org>
From: Chengyu Liu <lui2012qwq@gmail.com>
Date: Sun, 8 Nov 2026 01:56:06 +0800
X-Gm-Features: AclHuK9CALZ_fnVs06UuMczhS_NxicTk_7Y07aK9CoCt30E_RB7xhrK7ulJoreQ
Message-ID: <CAE=Q7=6S1mGX9no7r-Cu2x90gqSBB4TPk=OYWe-npUwLabCPmQ@mail.gmail.com>
Subject: Re: [PATCH] md/bitmap: fix missing_pages restore in resize rollback
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 8, 2026 at 12:53=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
> - [Low] md/bitmap: missing Fixes trailer for commit c9d650322829

Thanks, v2 sent with the Fixes tag.
