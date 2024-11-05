Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB515DBB3
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 16:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730824492; cv=none; b=Myx69bWeUsVYiyJcuL9q0m5jjjyQZxSgutGgYKstn70Ar0xGvwtOOz9pRpMQKy5pgRZPt1Reo589csgAH8uJPEfzvbiINrlKjpH+jhfhF6q95svuMTr6qVFHYhXMK43CjJry5CDdLpvjUwr9IYwMVN5KSQ05Xau3caIsnJW+jG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730824492; c=relaxed/simple;
	bh=ejvS/c9SP4gn2VsLhzdz2V/hKKEGe+McaI+H5Vy4BwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h7Zz91KpGAcrDVKxD04G8XGXzoqOdOnWQQUaSr1QTwzRF1fSIM5k3Tn3qd5Awlw0NFuDwl9rUmO2yS6xmGgyUtgCTymf4MYitp3q/cdjBOwvk6Cd0CE5HNMFzsKKc7MMnwbMUGhgU5yqmsP96czazT4G/L/tz5iGZiGgWp4MLHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=CMyvBPjL; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="CMyvBPjL"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71e4eb91228so437804b3a.2
        for <linux-raid@vger.kernel.org>; Tue, 05 Nov 2024 08:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1730824490; x=1731429290; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ejvS/c9SP4gn2VsLhzdz2V/hKKEGe+McaI+H5Vy4BwY=;
        b=CMyvBPjLD9gKzIIBzVHSFnJxceRDw3Hr4e0QuDSNIjTZpcQeoq+gAame4upAd0iiEP
         AHZT5u1AcjQRWSaOtu0HwjyAzVE+M958ko4nsU/CtR8U4MbcttkC/28dbEXFbUS6Bo0r
         x67OgZ1FRobRRksT1GoIwW17ft4HPcNiObM7KDYZ1P6tNrA1DcluxmLi8ORqfUaNsQs9
         7M6LWKR+pJrpGMxB6QvzD2HJfa934PmkvwYx5qzXtg0BAiWJV1XrwANQI6u4G9BCMCfU
         1sgAhL4GgubJxzfXnfPF0R3Ww5UKsl2cVWbMAgY6OFhBN6uM0i/DsnHmOb0XW6CtTH90
         ntXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730824490; x=1731429290;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ejvS/c9SP4gn2VsLhzdz2V/hKKEGe+McaI+H5Vy4BwY=;
        b=aHr576CZihKgfMyIC3Eddcy5wKcZe54hva1E3EEm6+ONCU60wKpbYdtoIu4aYhPob+
         jmyFiu4pF5afpO/ukvu6eEgulgVcDep0wVIECRh9wZrmfyvy1CEu0Zf2Svwwa8KQhvrF
         YsuF4gVPyEjZUz/RhUWnF//z27Sb0KtkesMNDwvb9Z11FxvjffYI8rbomYccF81X6WV/
         aWbsIUXEfU5V3GUAJPKYKRfWkjmcpszHkkJjn30/p7m8MqpHehSqKftNIszYsqEaylHj
         G+JOUT6vZJFM4W51AYlpm+48gS6hjgcT0/VaE5DPl1SC3XJlBcLtWajcH63MAk+FM18Z
         Fllg==
X-Gm-Message-State: AOJu0YxLb9VRekDiQtTfJLJCDoZsERLqzafgJIXJlSaVvKunAv9NYOWn
	X3jy1oXWxf7rlrg3Nw6LVo36Wmo0kSc32xOTkFtPwL6im5e9F4kHnO6jFx8mvfv/5ejjYpygPOc
	QchWyRfNr4moPosCjE42JlR/pm94=
X-Google-Smtp-Source: AGHT+IGuz81IoaEhjDfTia/Qd643TRNINCqwbEGoLJNAk64ZGJOmUr1NqyqH0nnvgBTWU1d6JMpeftxnkIR9jRuMOeU=
X-Received: by 2002:a05:6a21:6d9d:b0:1cf:3a64:cd5c with SMTP id
 adf61e73a8af0-1d9a83aec36mr24047164637.1.1730824489819; Tue, 05 Nov 2024
 08:34:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com> <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
In-Reply-To: <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Tue, 5 Nov 2024 17:34:38 +0100
Message-ID: <CALtW_ajuKUC0a3mDMjK5mmN_ExRPJmQerMcp+FOXJjjj_nzqYA@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Nov 2024 at 16:34, Haris Iqbal <haris.iqbal@ionos.com> wrote:
> Yes. Disabling bitmap does seem to prevent the hang completely. I ran
> fio for 10 minutes and no hang.
> Triggered the hang in 10 seconds after reverting back to internal bitmap.

Others are having a similar problem, developers are trying to fix the issue.
If you have the time, try with --bitmap-chunk=2G, it's just a hunch.
