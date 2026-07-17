Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43973F1AB0
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 10:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784285765; cv=pass; b=sMhWjw3qfoHdM/D/vYvP2ce6Fq7VEyaGB3R2sDPb/o1RF/O7kuvL2Nab9Ug9orNIPPldHAoN5HN0ofgmn6XXF6ftSPJxV9a91Gi9FlSadsoiSuv1Ca3uyf8Y5mR3jInc1ETV1cuBFbC9/JvH/xiSttWp2x+OPtJ6MbVLcpGftwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784285765; c=relaxed/simple;
	bh=Kda3YFaCY0wSzxzuFDCO6UFCLjDITUKucDaor/KsumI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gukT5PBxve6roMAIo+6bAL73olofg6fC2zTzGK4g9HiwG8/1GUfW0lNQNu+e42/tN2naFapuhNYbmPqeDDTI1+iBhB6ScAaIBSZVbotEG/s0q2+tySeLGl/sk7wc1S1kzYoQH8ISx7Q4sdiyJyAj0BByl5U6lC9MDUR0lg+PfFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jxYuTax2; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jxYuTax2"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c160420289bso1070323766b.0
        for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 03:55:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784285748; cv=none;
        d=google.com; s=arc-20260327;
        b=s0twcE+NLN+hK8UUAwo26vt+yGA+lHhQ+YeynXL5J3EKSWoFsxeJqvFVqFHIjdTMTu
         jwJ9fZgTzRnUIHSy7mJVSlugJNwJOTEZOaDcjViEjgrQvqWh4scdUGbn/vauQPv8wN3c
         eDTLifRZ3JS64/UfszejnV+ig35c6kW/az7e8ztQQQP4ntQkH2Z4jr+Ab9vfibTS3n97
         H/+URJfHf/OV7v/5edraLikOm7H/sU8K1afw3oo1pZriFGU6jgL6FmC0xXNocjFfaayK
         Y3VhnulZIyRgpC/19NUjeWdJYVCj/wpqDok5MZ+GK6i5zBuC/I/qPFUhwLoqm2p2QpWY
         +iew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1W9mOBWe8snHEbUrgd6IOO4i3t8dLiUueUtkFhJutTc=;
        fh=eDEjund4mqjgVyQ9q4ziO/kTr5N62VvGw4iu47CeTVE=;
        b=Rbk3MUoFBiEcAWldohGz6cdlQw8Xmaac6fWtGJck+fZAqh1/0bLJXbm9OfxOL5F6gm
         99OcG3QBcFJrPfgGixLIHPKKIr6FF1UmzqmrbMrgK1mefyQpiLAmnZQ17A6ifGtegvwi
         rgezCKeqcV2pGKyCmS4I7/nVCZ14p0ajO/zCKBbarYUgnPRkA1aZ0rm2YwDfQ2R7aYF/
         EQAfHP+fPkdjKYXR7p3VxBk+ud7J7/NC5xZSQzs5XpZX4Dx2ARFl4dJ8FnD7zlt42CXX
         xRnZ40OfuAIH061ZS/EVHoMafOxjDGdMY8LyX/QX6yf7PnfTga7ApJAtgC6ravtd8Q8r
         D5cA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784285748; x=1784890548; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1W9mOBWe8snHEbUrgd6IOO4i3t8dLiUueUtkFhJutTc=;
        b=jxYuTax2FmkvyugtfygwzPJjgQH1tUehwPVzKiGaoyCijhyY2l3i8Bp3cEcvc686xy
         PyjZvkvmD5/Gv3jYYOyG7mm0OasfLAi3JO2Gr3oEK4QcOcNGlcsQKkyK7EChLwQIpiGz
         47WuIJy0mECR9aE0wYHcdBd4Yfkuf/XCn9QxOOzwaz/0kyrK17nmLGkDnU5G/kISSWRg
         Naa1fc8XbQfOkSme5lTHW8qf8LasY90EIpn5qGfSqHsRsi+ORti1nQEq7MCrkCZOochi
         A+j8CIh7OA11fL7o3OWyQmjvVH/XVTTKFHj4T2DryNbxjtsrq7zkaqLUjr9vAuYVAOcb
         A6oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784285748; x=1784890548;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1W9mOBWe8snHEbUrgd6IOO4i3t8dLiUueUtkFhJutTc=;
        b=lpLdNu8cQ08LiDWuowMJ1inuFogR5r1sT4xz5Se4mGj4eb62mhmZAppsFdunEXwADL
         lnStAyWFsiHb0CRC2mTjJSZd51nrl/qhtaPo+1G9JlwJ8HfBendau4IBH525TpBGlp0Y
         JXdU+kdw8LkQ75d07AFxANPDeYrNQWfAzXGe/eNHJamhKIhNSs17YJM+BSi5U2+giapU
         s6qOhGruIK4GYFk0xsv2l8T2WjoaGQiERc6LY38mOJ6kk/EwMJqrI1dGPjK/mDSJqjlH
         t0l+h/4SOuJJb/O1+H9+WmcFfTJJzz9FIqttHyYHQVhcbdcq+mbIM26RLcVD+UDLqK3b
         PV8Q==
X-Forwarded-Encrypted: i=1; AHgh+RoJAA+s8fLQBG3EyUckZmnoNfdM9QvOoPbY4+ZcKeTzRBCz3lAhUbAsDybYFONkTKIH9HWtDRaC+B8D@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8Xawz3ZrqdVm02Y6ycJJ2vJZUSHWxWFDaKMhYtCqyYAcji/wE
	iYx+8SCZ6gV+7HNAzIs5pR6SdIKfWV2DSMh5vI2+fVwLiJ8Er09+SU/MJ1vRtpIBtqbxpZyhRKV
	0iptG3erBaKirb7rPGFBuUplpxEaFi/A=
X-Gm-Gg: AfdE7ckS8HZs3MCVAg2DNzPlrNNXhjFsl61hnmmqsD7USswqdvzkDFQsAtB4RuLm7DJ
	2VvqltfOF3RpS9Vr4h+LCtDw8ZK4ZKT3x3Kp9JXa53pmmNmxtL4x0t60mHhKMXuEtTKk3COqkYY
	rpYazuoqGhGejorWsb5cHTCEzXK6RKR41DmdVge71Kdy82+Ell9DhpfqhHMo7ll1Qtt0hX825Rd
	p1wCJNJR8+mXNKPze2B4XEKT1HByu/uSt2+tJwZUqYVI7Iwup1IUgNaZ0+Kf+lV9hNfyzo=
X-Received: by 2002:a17:907:1c9b:b0:c12:86a5:3ada with SMTP id
 a640c23a62f3a-c16b47d7e5dmr93165966b.36.1784285747987; Fri, 17 Jul 2026
 03:55:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com> <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
 <m2jyqwduba.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
 <m2ech4dt8k.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box> <59fa3f9f-eda1-4f8a-917d-8f6612639a1b@hunenet.nl>
In-Reply-To: <59fa3f9f-eda1-4f8a-917d-8f6612639a1b@hunenet.nl>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 17 Jul 2026 05:55:36 -0500
X-Gm-Features: AUfX_mwbL7Sq7b51hFcnPWnkcWgEtAQMRp0_odATQLZf1NTDp7SpjtKt0EOFofk
Message-ID: <CAAMCDeefBEP0c4oW3iX4_cbZBLDuyfuAtCREtFgiH-qS4ZaiXQ@mail.gmail.com>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
To: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 1:42=E2=80=AFAM G.W. Kant - Hunenet B.V.
<g.w.kant@hunenet.nl> wrote:
>
> On 7/15/26 8:04 PM, Abd-Alrhman Masalkhi wrote:
> > On Wed, Jul 15, 2026 at 19:41 +0200, Abd-Alrhman Masalkhi wrote:
> >> Hi Dion,
> >>
> >
> > I'm not entirely sure about the media refresh part on modern drives...,
> > I'll have to look into that first.
> >
>
> Maybe, we could ask the smartmontools people about this. They should
> know this. But I have never read about a refresh action in their
> documentation.
>
> Best regards,
>
> Dion

I am not sure why you believe the smartmontools people would have ANY
idea about the refresh action.  Smartmontools simply exposes the
internal drive counters that the drive manufacturer exposes and/or
documents.

The refresh action is 100% entirely controlled by the drive's firmware
and has nothing to do with the smartmontools, and the smart counters
may not show any of the internal ECC forced rewrites.

As far as I can tell in general the drive does what it wants to
(refresh or not, relocation bad sectors or not) and there is NO way
that I have ever found to force the firmware do do something else.
