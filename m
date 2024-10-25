Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5119D212191
	for <linux-raid@vger.kernel.org>; Fri, 25 Oct 2024 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729863103; cv=none; b=RrqSzZ8eu8Fd3wlI+PZVYQiEDHUndTDnusgN/CTNGQMJR+eXpJYS79F5u6se6Xv3shL3h2LjYl55mp9geudj/sDQsg2KMjJn/L5q7h8BYjJ6wHTH00t/+OysRRVQKqZKhjkrfbD5hr8kgsd+zSo69tWzfEJ87SQYTXwyuMCeWIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729863103; c=relaxed/simple;
	bh=uf7UAsZwUXG0HjIitsk7ytpb6VBUhLGUqiOtbx3qVkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DSaQ7ETk8PZbH+GTJTA3ITA00cKMMSxZL1EjUUwfXltQY+5mN2kzbY3qtEJz419IJbg/fRoRI7HpMfu2EkrGMYThFlfCX/5xbd2aXmlSMVLuSPP6KK5QAzI1Gh2Vl0JhlwHe8BgbB0kEeNh73akrC+4j45/1DziCtEgTqJAEniM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=aiDYG0dK; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="aiDYG0dK"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e2ab5bbc01so279949a91.2
        for <linux-raid@vger.kernel.org>; Fri, 25 Oct 2024 06:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1729863101; x=1730467901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uf7UAsZwUXG0HjIitsk7ytpb6VBUhLGUqiOtbx3qVkc=;
        b=aiDYG0dK2YhMdMU9tzmi81e1wQ6G8UOqLcJ/rMrZZn3TFuhGM72hF4XRXgGq1xrVKG
         cpIMNTVxG08U0LyQ+pRasfXKCEgIoG1T6KemEzzQmRhpRRlsWDYLNmBIEa5SYOXWl4ZI
         K58oLYNFToZ5B9zcNN7wZi8w7ZQR7TkLa53VVub7Xd0zyqX9RE2EMIHSKBXKBEIYomPY
         +SPmeGBsvvINlMPU5yEpQSEBjjfMNZLS19ty7PhvRyk/8TxrKcOiLFkyxNd0aIGnsigt
         3yZDht+EAYNgMnFD1PnucNFiIOuCganxT7nZlqir5lBycfbC+jw+4Uf75m8blSFLcnJN
         WgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729863101; x=1730467901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uf7UAsZwUXG0HjIitsk7ytpb6VBUhLGUqiOtbx3qVkc=;
        b=smqeEcvO6HteZ7a3jXDmYRj8AUPRr2H6UiM291EAnk5Zdett7xVfObKXoHkhCX2IVe
         DHaXNFyJJtO4jlwl6/jPIvjo9NHLxT9BH+gJ6itNC08NHP3KDCnMLQgNaXYUlHNFkOBQ
         lHe14Izu9uYOXM511ILgRestyBQE1pOPAx4OGj62NEK8We72vLKltC39Oqq8B+uwBp2w
         EBGCQuNlR+Q0XmYkQ6DVvgVY6FWWh68ezjMJnZ1QPI+VsyhM/PapeF2xJ2RbDpAY3yv1
         Wd5RtYuyhu4OdfAQTQbZ5HkBapVgJ5I4jsfnO0G2NOE0f3oaXOgJYQ1gghMDxPFQeIxd
         BUhw==
X-Forwarded-Encrypted: i=1; AJvYcCXdX2FUQAdA4uwGXKbhAqlF2J0T52TZkdIEe9Dp+kbJWPxWSHc2kocflubS4ja//5k+H3RWQqEiWEGw@vger.kernel.org
X-Gm-Message-State: AOJu0YwH9C4mqAeMzFWVdfE2zi+OqvWrhjemg30L8Ked/xdn47JSQmL+
	pdbPwRO9oCoREeOEtI88jCqTLtptY1YAXY7wJWy0crLAGODg7VZ+W+KosDq+QNlJK86zKg4WP6h
	ilqGSci4GQdAlzgmerMyp4DEA4nk=
X-Google-Smtp-Source: AGHT+IGcBTijq7YlHWuft9iqzC9HKlPlFEjSGZ5kx05SSgeEyV16VuL+kSy8D7Ey8WV2hSbLLNtJmY9/iSIK+7/XZUA=
X-Received: by 2002:a17:90a:d80d:b0:2e2:abab:c456 with SMTP id
 98e67ed59e1d1-2e76b5b7e1emr4603265a91.1.1729863100658; Fri, 25 Oct 2024
 06:31:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io> <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home> <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com> <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io> <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io> <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io> <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io> <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io> <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io> <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
In-Reply-To: <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Fri, 25 Oct 2024 15:31:29 +0200
Message-ID: <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, John Stoffel <john@stoffel.org>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Take this with a grain of salt,
since I'm not a kernel developer:

If you can trigger the issue with bitmap=3Dnone
I would say that is a valuable data point.

On Fri, 25 Oct 2024 at 10:40, Christian Theune <ct@flyingcircus.io> wrote:
>
> Hi,
>
> I=E2=80=99m working on getting a test without bitmap. To make things simp=
le for myself: is it helpful if I just use =E2=80=9Cmdadm --grow --bitmap=
=3Dnone=E2=80=9D to disable it or is that futile?
>
> Christian
>
> > On 23. Oct 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >
