Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC1392C39
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881475; cv=none; b=DqoK3YR0UxXVJ0/NBo73lmZdgHeToFkghd5lTuyKTvtrSKASulNXar5rMXfN99nUO4MYBtyUma9FUnXZn28IIJb/JM60J7n54jt8Ej6inkxulut/8CdwHpWyZW+x/HygRCKHZ6mS5lUNrADx6p5kr0gx007vEMq8m2eb4ggl474=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881475; c=relaxed/simple;
	bh=nXtwUn+NjPRObmT4cOtGmM7dgAdwJRC+fUheUU2sS5E=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=fa7pft4gaPdwLLOpekC6gWhcA/wz/c8Q0tc4EGTSx5MkDr4xjZK0vzwpeGAx9RRkeiYp97ULik4+DPdjqiJfOEjUvuJWJxGYO8AAbLwu9ZMQea5xW1fPd7rD5/x11UqkxHDgpOJp2rXjdIV9yzxx4Wwl+r1TOALkRPmlimUJ+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qs1LjsTQ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qs1LjsTQ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so5289804f8f.2
        for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 11:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881473; x=1777486273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UgPO/NbskuOhdPOSGOgEbfwqbCTSS2Gc0tnUci+MT3Q=;
        b=qs1LjsTQAhEyN7SuqXnfFy0loULr4/nWx4+YLRPKhyzVYR6dRpFvtswIVoDB8IMrhJ
         5wybA1whF6hdmKQHtpLJg/0Viq9DzMb7HgN4Y3Plh3kyUIPDCwbJjtEhscZJkSF3iV2w
         U4HuYcgVuVc5WSwxFHhFXJBAmwPn3iJeygeVCW8i0bg9UTqtVZphjUzNTS3LmRNh/WZO
         CcvsVrRp5cLj+8Z2YMU2+CtiV6BF2zx17oJBXGyEnaN2x8LFPAfiRTcRtDtMHOv3TlBb
         YxvS14BbIXNy+jNG9m9p4Bq2F6+jlOLJByzW1uLhOXlhVfdgJGeyo7ITqADe9D/ocY0D
         8vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881473; x=1777486273;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UgPO/NbskuOhdPOSGOgEbfwqbCTSS2Gc0tnUci+MT3Q=;
        b=ik2fl7HFw1zXmssoXYQ5B4TOL+s9ZdEDmclnsGo+TEya8IWoT5GHod6WFZuiLMnZqT
         KpJHzXStQD+bnSleZs/JIUHK+kGm1ylKRGyPc+dQWrEx8swXsADk1V1yZSUbjG8j2OpS
         MeA2Q6RnphCxaA374KKYy1RnAetilhfEXMnfvTBJHf6VXLJlqMTRDsBESN7NQ1Sev3LI
         Kpu9DS+vfzp+3hjepxsZglVEMfj7jpKNHkGRJxOckxhPmhTyspxfUGAcjMuQd2LXt+FR
         D0BkjU7SG2KNa08pfpBbB7Xlf9AzGrQuvaLV3eYvK2uMqCCoQAYN53Rw6jpcFm+p4reU
         WDtA==
X-Forwarded-Encrypted: i=1; AFNElJ9Hhuiedb4Tcd+NuYJvBrR6o5xb7Ti/N8SJ4mnfYhn+1RcXcB+n9dgSizbSyl4lSXXsC/Cjf0DEwD8R@vger.kernel.org
X-Gm-Message-State: AOJu0YxtBGuF95zS1dQoaol8FTVJIehB6e8fU2GYdkhAKf/ou1XXnnNL
	L+fXgzG2seR/8k+RaGzRXRg3PTSduYMpptCj3cueD4RxMUPJSWsq9fqv
X-Gm-Gg: AeBDieuXOz6RTa/rRdZJUhf+fCSbscAib0O2SMWhVESBM/CWtXywwA/1P55PdkII790
	E02dqteePPCFKxK9wAOSnHpXns439Yz+pAqrU69RJ/6CmCJUg35YtoRaNQ7OA+FEgrgfmN+VQGF
	XIHVRN5POnOvT3vBXalZr2ltnbF+RD3KQha67qBrj3yRXGRVO3++ri2/dgJ+iaMlmm+4IwHIfiq
	9cIZVgiwWIeP15sd2h0Q1dNTm+3sbj88ZWKKRPfcR23yoEyJyk+UnNeljf/HdqZmqdtIdMOdSZh
	rGJzpNbxTWFE80qdJnkRkSJT+b6szpAkOGqH3PQq31nEsO6vp7B8EfgGL68APybzt1nK0DJgV6v
	GIKaozTI+Mzkw6bIEFyffX2QgRlB5LtS5xgWRYb3B8XqEJOk8/Np3F2/VYewIKODojZM/vVKrKg
	DCR/d9UEHpQytVE6tNmqDJlN4iFleAp7o1J2pP
X-Received: by 2002:a05:6000:24ca:b0:43e:a70d:7632 with SMTP id ffacd0b85a97d-43fe3e0b463mr37323014f8f.25.1776881472867;
        Wed, 22 Apr 2026 11:11:12 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4ffa8sm48497290f8f.35.2026.04.22.11.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:11:12 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:11:12 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_3/8=5D_xor/arm64=3A_Use_shared_NEON?=
 =?US-ASCII?Q?_intrinsics_implementation_from_32-bit_ARM?=
In-Reply-To: <20260422171655.3437334-13-ardb+git@google.com>
Message-ID: <7DBC760F-0524-41D9-8A6E-6119F0E1AA9E@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard.

>+#ifdef CONFIG_ARM64
>+extern typeof(__xor_neon_2) >__xor_eor3_2 >__alias(__xor_neon_2);
>+#endif

Creative. A  reduction of about 150 lines of duplicate code while
maintaining
the __alias for the 2 input case is great.


Reviewed-by: Josh Law <joshlaw48@gmail.com>

Thanks!
