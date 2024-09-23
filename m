Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F184DE0
	for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727127787; cv=none; b=mh9XGP5ZJkfMTWXmOLm1mPwq2y07fn70/BL9Hm5f6WOMbuV6zeT/7YbUnfkE0bQq5Y5twScc5M+cCmmrl37Ey8ZfhXDIWZsVVMt0Cj9Ui8o17Z9Cte+6GhLZ78ZNdwN31fS9ezKMKWSQC5kFb8uMX9IiSXgXaiY6iaa5vuSoGuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727127787; c=relaxed/simple;
	bh=9opc0lkIcTHmTsGo4J1Z1b0jeLRQ82yHJ06VfMebnHc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbTosJQHOt03S6DhYTT/qGFkcAPg8owo7fhhL2WSxKfim57mbS57G0RYxyV6mwztvPV4fodh2NnbLInaJPPv2nuo52fXEyNd9xChi3UTbM8t/J1ZAkCcjXshV75ChfNMvGcThmYKcWsd6wjvUumvO+Bpt03dh9RJvehBsxgPOLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKJ0qEcx; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKJ0qEcx"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6e1f48e7c18so12009897b3.3
        for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 14:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727127782; x=1727732582; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNat/x9hZZ6CB0jkoJm6TQOanUuuUEd80c13wRWkxMQ=;
        b=KKJ0qEcxjm1OeR4rvtp68Zbs8C3PXpPiIW5NIl44dqSLiFcsFA/oqgKqBo59ZFUQvo
         OCfJ/XiMCd2J327AhdmyvloPNR9naasqw3eqNgE9Cu6CAFzgwKh+rCtoAWd1U0ASoomN
         d/MVz05BI60MoU6iOJMtI5ZPTbcm6040T4Rwpyk+qRbjSLe4M1i5njTWUI4T1XA28bZr
         co4dPfxwsd9PNiJXRw9wCRoyGVF73ji+CJHmScOMS21aftws8YsgvZwdCTxBYxAZSwb1
         iXqzfJdZ/pDq4Rhd1qrPzdIj0mtSYqrfcji0fbYVlmPMhMIav5N0hhgGws48feA6ygd6
         bK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727127782; x=1727732582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNat/x9hZZ6CB0jkoJm6TQOanUuuUEd80c13wRWkxMQ=;
        b=Z6lUh2wAvms5gIaTwT0wj03hulXH36WJ4XfLUFRyR5DVUkbXTpxZRq5nELp0n8uCBr
         lJFw5vmBuA74r1ZME6nDo3OJpJAQ6Gbz/dfS3Lbqpp6Qod3YKRHrjT2mCTk6pgegxgNw
         XYi2kr4eBhQKjYMdmSdxXgcuk//EZT+FxMn4ds9qvmUha/tDKyNIdHhyWOJt2Jh+4DNp
         i2vegmBHlYscOAT12fURUn/v60pQMWXzpR+J5doCH50dOF7r6nNB2gy5t4W410qZtAQI
         CTOl/IpR1UuDCqKgUzKGQCzQ6Cnixiz2w36Ggzmz+Dpv3rwwBDuE9u5PN/c64jNvXsJX
         AGQA==
X-Forwarded-Encrypted: i=1; AJvYcCVFcrt9uSDvxoE1G+BcXdzbKAPT7jtHjgtDh1wg+8ER4SiJuOqipmEzik/WLBhjjvImfmu3AJcccOwC@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb4IK9QlqqFYsvPoDsFDH27XO0bx/809ZXmO2+tWEEzaRx9cXO
	7IhOWuqnPaXetc1HQ4x7NabCwiDF1lGcsyVB+yrkJMls4q/aNMhSIcPaUZ05ZA9Cl3YvWVAGRmv
	ui8mdVDnCNdMQKqvyQKp8XlzT8hMhIQ==
X-Google-Smtp-Source: AGHT+IEK4XOey66MjzieO1/ESm5HBBVyNTMRgZHIAYHA2vi2iVgAQ01G9Soj+NAciKHzqnPh4jSvYWW8QABNhg1kLMg=
X-Received: by 2002:a05:690c:60c7:b0:6dd:d0fa:159a with SMTP id
 00721157ae682-6dff29037a8mr84681387b3.30.1727127781650; Mon, 23 Sep 2024
 14:43:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com> <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
 <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com>
 <CALtW_ajc4rx4Xfh4+6EtGLQm82A7upro8wF5y8WuXuHS=KJVEQ@mail.gmail.com> <89cde0bc-ebf6-48d6-80da-59d93fb4757f@justnet.pl>
In-Reply-To: <89cde0bc-ebf6-48d6-80da-59d93fb4757f@justnet.pl>
From: William Morgan <therealbrewer@gmail.com>
Date: Mon, 23 Sep 2024 16:42:50 -0500
Message-ID: <CALc6PW5myLPmvzfopxQ6YZQeYxMT76J3w36mJpM+fszoSEWXrg@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: adam.niescierowicz@justnet.pl
Cc: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	Yu Kuai <yukuai1@huaweicloud.com>, linux-raid <linux-raid@vger.kernel.org>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2024 at 3:19=E2=80=AFAM Adam Niescierowicz
<adam.niescierowicz@justnet.pl> wrote:

>   We had similar problem with disk reset.
>
> In our situation problem was with power. When array started check or
> rebuild disk power consumption went up and circuit on the board doesn't
> have enough capacity.
>
> --
> ---
> Regards,
> Adam Nie=C5=9Bcierowicz

I find it hard to believe that my 850 watt power supply is not
sufficient for 10 drives which draw 10 watts each (100 watts total).
There is nothing else connected to that power supply.
