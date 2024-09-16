Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A76814D2B3
	for <linux-raid@vger.kernel.org>; Mon, 16 Sep 2024 12:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726490978; cv=none; b=X76NoLUEyu3JJgMUZq8a0EkfcTQ4PpQBnnxCk0pRhFXe04gHWBqW4f5325zHUTbJ30L4PWSYWwdx9IdiLdYi0jPhBPEyY/V6Bpbw2jlXUjlmJa5hLsELjo9yoGJ7IdgyY0ur9pNqQPs+sJ3THkumPX9bFeamtaFF9SE+mzIcPFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726490978; c=relaxed/simple;
	bh=vYC+klXNm0CL8YDrlugHveyB/pXXMcetyYIj4JCgFXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kwOgzj6nRM0J5LyFs7Bb8hf81A6jLMLRl8gBuYK9x7GzbS4HzOs1x2XMdHsUUd5oS2nDSt45rYkPpBdax4zJO87k1nqEBRabK9G/C+/JE/vUAKlPtJko9aR6n8Z53rjifssVmRNXZbkhr/5bSL7Tinz2w0IRLSG5gmAu27R4yUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=If27oNmR; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="If27oNmR"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6dbb24ee2ebso37429537b3.1
        for <linux-raid@vger.kernel.org>; Mon, 16 Sep 2024 05:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726490976; x=1727095776; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJv1b+gRupr/j9vt4r5/saWTbBI2qDLAE4m1KgGhV4M=;
        b=If27oNmRjxVWKOsvPX5EdcOf9RCEEBEq+QMc+K+l1Vg+hv1ky2Se9Llg2e6tZUWFR/
         w4su0C0fsaJRxha8aM+c0u6y/QOT0bDnxOCslOr+1EutuYDlx3T05M0iGKmgCF7vc1V0
         2jTe/bJZIJPoSzbG9eUZD00zVSODWZ3+cgxs6+MtAq3Hi1Dhkn6/MPyAOh2QgEMHWHTN
         uDocCT68/Xg1FtgRxLu/AVN77LhWtHniJPHCAP+xGLAqRiYBntnx7opb3wLuP2bbR4nz
         KQ/rpNd4n2aagsK2wGds5lOIDtgmb0Iufkz+YKzsUr25CSvMzn0WslibD3qB9VLqEoD6
         DwQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726490976; x=1727095776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJv1b+gRupr/j9vt4r5/saWTbBI2qDLAE4m1KgGhV4M=;
        b=MRj1qmyHFR7oyN5a4+G6WevcWaHKs2wbwg5SrcPnxJjc8nr1aoiIX5WoXD+kRuSNDO
         KgZ3GR0YaI8slR1rs0geMQ/pyO01mqCOi/+iMaihiFUzRInQmqsErKzhAAi3VoMn7dan
         7Z4OZdL5VLnWS5F/oL3Gl/Sp/aEy59e9BcLwCj8zOrmE/AfWHfbVTR86cz5AOCgEwkam
         SlebAItqkk8f/eoQi1BiaJqRQFKOSjOpwqAiDJCfTLPzvAJ9FP3iLUbbeHgySEGASLPu
         hCDOQAF/BUJMYf3AK/CCxZWkHeNTQ/arWo/pU5tll1jO2D4Jl4J6Jgm6pErDawfTr+pB
         xfhg==
X-Gm-Message-State: AOJu0YxtwFSr86mJqE1b+7XWvUEe4z3FlnoG7vS1/u6q4bpWoVORjkkb
	iC1aVOLhFxvIECPxmJqEis7nKfO3h11bYkLG6Ox9q6Zeyce7bFuz2uenfFgPYic1KhKCuSRJ/At
	NQz0Qlh3TdKucxxtw+Fh4fOJa7xA=
X-Google-Smtp-Source: AGHT+IHUm+aNIhAoznJ6wt70eo0zEKVUxHA+Hs9m1MO9qVYHfoSGadsk30qqV5t8yVfd8ghAA0VTzyLf56KVpHhJZxQ=
X-Received: by 2002:a05:690c:b94:b0:6dd:d894:bc40 with SMTP id
 00721157ae682-6ddd894bccamr10501507b3.26.1726490976230; Mon, 16 Sep 2024
 05:49:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com> <CAPpdf58ivXpOCeJ0xLDbVBqQoVZ4gEO8p-j+9W0yYvxXX_k8XQ@mail.gmail.com>
In-Reply-To: <CAPpdf58ivXpOCeJ0xLDbVBqQoVZ4gEO8p-j+9W0yYvxXX_k8XQ@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Mon, 16 Sep 2024 07:49:24 -0500
Message-ID: <CALc6PW6fZ4wpRW9BqVwqd8p75xyHZHbJ_VX0nOO17xbzF63Ewg@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

No, the card is just a typical LSI HBA card, not a hardware raid card.
I've been using it for years with mdadm with very few problems.

On Mon, Sep 16, 2024 at 6:15=E2=80=AFAM o1bigtenor <o1bigtenor@gmail.com> w=
rote:
>
>
>
> On Sun, Sep 15, 2024 at 9:48=E2=80=AFPM William Morgan <therealbrewer@gma=
il.com> wrote:
>>
>> A suggestion was made by Dragan Milivojevi=C4=87 to try booting a liveOS
>> with the same kernel and mdadm version from the time the array was
>> originally made. That would have been Ubuntu 21.10, with kernel 5.13,
>> and mdadm v4.2. (That conversation isn't archived here because we
>> forgot to hit reply all.)
>
>
> (I tend to also have this issue - - - I just forward the necessary email =
to the list.
> Hate it when it happens though!!)
>>
>>
>> I was able to complete this task but unfortunately I am afraid it made
>> no difference at all. Exactly the same behavior is seen.
>>
>> I'm going to try to enable more verbose logging from my HBA controller.
>
>
> I'm wondering - - - (most definitely NOT an expert here!!!) - - - it seem=
s to be
> to me that your card is actually a hardware controlled raid system not a =
straight
> mdadm (software) controlled  system.
>
> Is that possible?
>
> HTH
>
