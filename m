Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D488F382292
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152151; cv=none; b=XXIwVsXutywLrgUJDm/zM0m3JFfUdbcpU6U+ya1+wCZEfiEXx02FddHhsqNZiTo9eMpwRMx6em4LmdEX695S7EXcJ0FDckbk+e9alTUScMN/qtQSjVXmMfXI+JS3x/vHTDJzyZlvNnnFexWzSQFuA6B5MQtfrffqJaqpIUKP3y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152151; c=relaxed/simple;
	bh=tUacAQlkKVSQfQjUzaLm2lm7YcF6fCoS64CLbnNXJP0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SzK6sgPPdyQyevYHuSWPLXKoN+Ewb6tS1Jizcat8L9NtOuv1ZL/hvzdx+CqhJfJhGGBS+6NxgG6jy+a/1ObUaRgITRxm5qD3H7mPe9zWEbGidpKS2Z8qiiRuatNBMURtyiehTT0u/ymx27CqxgUmtNNtmiiyHJhuVpNtg7pVfsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C/w3JtkO; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C/w3JtkO"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48442ea8f59so812165f8f.1
        for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 01:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790152148; x=1790756948; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=tUacAQlkKVSQfQjUzaLm2lm7YcF6fCoS64CLbnNXJP0=;
        b=C/w3JtkObuzwpZouop36oa9BGFBg9n/apU+pq2LsrtiMUhjLNCKAHGU2fT6IyL2qrm
         JUHWhJa4202fdwY/OXkRH5xacZtlAqtefIL+vN3uK5EYj9gqSXl7am2KKBJyKD53DZmW
         0QKtostJVFw8JAFAzDBWslXU8Uo26D28pnr0DeRweBcmxIvHnJHVnA73DW4DSL9ZocZz
         8M/EXNY2afwbvlMRPVnp0XjZxPS1Zok1nNGldkj30h23+ANPlaJQ4Vz6PaCAV9uZZi5l
         MaiUJXni3JW3Aaihtftm6/Oojr7s6pKGPF2RlmiXCinH2zrisO0DowZZHhRGqSi1ddQK
         U5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790152148; x=1790756948;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tUacAQlkKVSQfQjUzaLm2lm7YcF6fCoS64CLbnNXJP0=;
        b=xmF9+iI38ksd3sNj8wt/eVuCdwlRubV5LS8f+i9HXXROlqKE3/vZUrws2ATNNyn3JD
         h7aK3jAl/P8rQVE5ci7lI9TPKzeMyVtjg2jF8lzfBY37keTDTTcjDe4t3JOmCqIbz/4L
         sbYU8QjfSbRcXn8DEi0ox+Lx8OknDUWMp1HDHEBdm869REFt7y+6L+yr5KWPe/mFfeUW
         MMcgIqA21qEDR856oYZY1cz+V8EYmQDUOtekVJZjkVpCr5v2RkIwqKODzceJolCSInHL
         LHtHRur7/ZlRZYHDcmZrNCkug8oOgNfKTwppio7M5VkKFaekZdvWAtG/XCx+DWfqY/qd
         9mxg==
X-Gm-Message-State: AFuF++mst/XdNthvg5/q/Pbum5beCwKX7dd3lqDJt5aV1A9J87k46Vl3
	ts2QKUc3WE7VgJRpJsYtfCqk8RuSS0frORvu/M0kr3FoAS9uZSV3NVfPO539+YKtm0o=
X-Gm-Gg: AYBFou0X69BdamGyhsttm0OH3lY7kcov2w6kKoc0IYptcYb5aWuXxGBXgODG/EZ9Lsn
	Ju+KRqWd7A9l2GofJhjnsbfjk2YmD7sJ1TlAvL+kZxgcekuqXr54lnUv+A25/7KgnlKkWzBv1XB
	Wwo4+YJms/G313107bGjK8LfFS9D62DskpP+90yQ54TkvADP4OiO46cDNNGchPJHqzEWSaZy4XE
	Q8ceQEsNto9PKZ7JQjuaqS3qpUq5MQyttgO6jS2beh2uL2yLS/uGbVEvKHwPM3CpymYdUfWmzTs
	ndjWAV8yzrt6jXJruxiWl0YfLPO1IBU7CjMERHABY8BS7hZN8IXOVpS1WaLdAAPm7R9PNH+9OhX
	EW6D5knMT4DQ0KJrSxlse39lfkSdedJgo+SQJi8ku4v1y0aUm5w5yhsuEZok4LlY4WxtimJVKgP
	ZzNX+eV8D70ZDhTc7tNk2hHe1FhOnJS1ycv8FtiTgMD/nDCNesO0wBsFr0VV8OAZ2usxmEB1/vz
	N0Iz3ZkH4Plf2ZKfiwpjPFZqYd6w7l0Lg9NVRohTLY6K1qsEip2PDgqBueSEuDzCzGvynrdfqY7
	PCd0E4pnlt0ufMp7P3nwW5y8y1ZYoRY0iy1SVwvK/Dxg1w==
X-Received: by 2002:a05:6000:27ce:b0:488:654a:981f with SMTP id ffacd0b85a97d-488654a984dmr3676033f8f.10.1790152147758;
        Wed, 23 Sep 2026 01:29:07 -0700 (PDT)
Received: from p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48868486461sm5136850f8f.8.2026.09.23.01.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 01:29:07 -0700 (PDT)
Message-ID: <adf11fcf1435728f98b4f94c1821d86b83866c14.camel@suse.com>
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10
 when using FailFast
From: Martin Wilck <martin.wilck@suse.com>
To: Kenta Akagi <k@mgml.me>, Xiao Ni <xiao@kernel.org>, Li Nan
	 <magiclinan@didiglobal.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, 	yukuai@fnnas.com, shli@fb.com, mtkaczyk@kernel.org
Date: Wed, 23 Sep 2026 10:29:06 +0200
In-Reply-To: <010601a0cc7347e3-ff9a517e-b03b-4de5-bd38-93b664f3425c-000000@ap-northeast-1.amazonses.com>
References: 
	<010601a0cc7347e3-ff9a517e-b03b-4de5-bd38-93b664f3425c-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Kenta,

On Wed, 2026-09-23 at 04:08 +0000, Kenta Akagi wrote:
>=20
>=20
> Hi Martin,
>=20
> I have not given up on it, but I have not managed to post v7 yet.
> I still think failfast should be usable even in setups like that.
>=20
> It has been a while, but I intend to resume work on it.

My thinking is that, in the fastfail case, code to prevent total
failure could be placed in the end-IO code code path, e.g. by
attempting a retry directly from the md layer when the last rdev fails,
instead of setting failing the device. But I haven't thought it
through.

Thanks
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
