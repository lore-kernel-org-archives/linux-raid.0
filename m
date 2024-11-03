Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5301632EA
	for <linux-raid@vger.kernel.org>; Sun,  3 Nov 2024 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730650605; cv=none; b=g+RrUHXvQvz2C+ti7JBDXBTdlJb+WxJpexGmHVk/OzYQBAuf4eHbW+GLbIO6NsTgy/r1eaHnajO8an8UBOO40Synqh4XLynkX4hCDThSw7bOwFGW5isVocM29TXMrD4YE1WPfgw+YhTe8mi452nUOhy9jNpC1ThA+2WciZWEERU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730650605; c=relaxed/simple;
	bh=9UJvROld1nNyMIMBZeKybMqWRrUbfmouF7rDcZQ0d04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=feOCnOz64mH0+uQ1tZhcJZGLj7TmabdMUzLIhxMzykKL5k3iB5FomXssszACtcgxxXT2Se3OxZYAKeveNujiOCFzSTrJHB/YmO15G+8/8dZV1Tjr2auzM1bBFufJ5hLKfzInpHN4Rul7k/HTwtUSu8rKaU5Dfp/5pQYpbWsKKro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=Rz/qlD3b; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="Rz/qlD3b"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7ea535890e0so573859a12.2
        for <linux-raid@vger.kernel.org>; Sun, 03 Nov 2024 08:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1730650603; x=1731255403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UJvROld1nNyMIMBZeKybMqWRrUbfmouF7rDcZQ0d04=;
        b=Rz/qlD3b1wQb/G7gCJ02SI+pAO20mhQovswO0M9BUGDQkHhxB9/pmQwGgP+yv2Eg5o
         XawWgdXGUs4huuFMlzYb8FX/Y3bneXGwZYMswVNojbQo+v7jhM9z+0sSdglA7z39/rxE
         lPiy2/rTef4NT3058QfAdmK01Am8d8RXIyqszvs0rjXhPpm1tz0k6I9XKSAwWaKAmLme
         IxKlqgtEEU78OskjDOFKPraQDDpJx2BurKJchVJOuLgtD/Y9sC+36uqhMmxlWR6XxNiQ
         LqufeYO3FSQSgtFZ4PDqpnn0e7CmTC09KBaggSzADkQkMxvGod3Z2hA54W3glEDUkHd1
         EK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730650603; x=1731255403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UJvROld1nNyMIMBZeKybMqWRrUbfmouF7rDcZQ0d04=;
        b=krC825T0oNEF+ml4OZLzawyDfW6Uh4SV0bDTMou4D6PK7l48RCxz3KhmGcqHJRHiGV
         YRDVVq4Dh2EEXAKjvjm08/J8gHJHcmzs5VBAlCnjf0MJhe86oqbiZqLqwWg1PxtnV5KY
         5UOYZSQ+e4ittvdCgO9u9SX5W9DezF+M26K0nad5qgeGplaZgAR1/gasHOpapWEb43tr
         OMIxTZqDNJGqvBYHwbZJwiO3JRnUAQBH27qr2Wd9CeujAo+Td8s38lhdtxbONLPp9uWm
         hnY0pwvX3tTWJte72W0z72pLtQJSUfCtn3/HHzOkL4opF00L+K1Pe3d7NsctymShS0Fu
         vjwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJDdkmOm9+c6vMWwN0m9zeB3nHQYqTU9GkWjo8m74c3DA2fOiM1LGQ26h3qq4vpyl6iMrioOlPWnLt@vger.kernel.org
X-Gm-Message-State: AOJu0YxTJxrzLYDM3Uu9X9HTEju+K2Y5ZWr94O/40Gm4/vLmazw9ninY
	rNJcsetRG4F2PEkQpxU/jgvQqPZelHs+mYfZqxKZC0mL8UPTG9HkoN07ZAfjLVPBNumVNHg3V+c
	xE7yksFCtaPiNm332PXzXjS5EfS8=
X-Google-Smtp-Source: AGHT+IFNtryVrpA/GFB2oSAlRbklg4p8/W+gqCZTneLBWKvOn6bxEBr+2V5ngFKkYUZ+uzlXrrop0mUqoIFnStRKLuE=
X-Received: by 2002:a17:90a:77c5:b0:2e2:da8c:3fb8 with SMTP id
 98e67ed59e1d1-2e8f11c0f04mr14694874a91.6.1730650603433; Sun, 03 Nov 2024
 08:16:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io> <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io> <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io> <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com> <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
 <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io> <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
 <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io> <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
 <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io> <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
 <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io> <26403.59789.480428.418012@quad.stoffel.home>
 <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com> <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io>
 <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io> <87E347A1-059E-4F0B-865D-6862EEBE0C64@flyingcircus.io>
In-Reply-To: <87E347A1-059E-4F0B-865D-6862EEBE0C64@flyingcircus.io>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Sun, 3 Nov 2024 17:16:31 +0100
Message-ID: <CALtW_ahmXeCococH2PpEzsswOcr+f9nuxp4hFBZYy2eZBxguHg@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, John Stoffel <john@stoffel.org>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Nov 2024 at 16:54, Christian Theune <ct@flyingcircus.io> wrote:
>
> Hi,
>
> running without the debug patch again on 6.11.5 I=E2=80=99m still able to=
 reproduce with bitmap enabled. I=E2=80=99ve gathered the full list of all =
stuck tasks.
>
> Just as a reminder on the setup, the layering here is:
>
> nvme drives =E2=86=92 mdraid =E2=86=92 lvm =E2=86=92 dmcrypt =E2=86=92 xf=
s
>

If you have the time (this is just a hunch) could you test with
--bitmap-chunk=3D2G
