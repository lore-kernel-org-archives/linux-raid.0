Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C032226A0D5
	for <linux-raid@vger.kernel.org>; Sat, 12 Sep 2026 05:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789191390; cv=none; b=RguoEQEXStpzJys9r0gGRTIzlbgXjmNrKrM73aEsiwtBFc7ym3ps5wurOcYTLqGj4rZJ8bU/MxqdBoU7wPvf17pZ1D4VkHatPOkPxtt5pHZQqvye5csLEHhOycU0r2y9plj6RwU0JUwHlUYF7JyTQljViG7tdHbOiqd6EZMwbA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789191390; c=relaxed/simple;
	bh=YS6Bmi3ur/g06pxTgi2HZpCx66s+nN/m2XgLl6TIFoc=;
	h=From:Subject:Date:Message-Id:To:References:Cc:Mime-Version:
	 Content-Type:In-Reply-To; b=OYadKiDipB8HlGdRO7I3sXIIGsGtBRxPHlaqXfQmdW4RJW9i/wjOqfJAjDUJPyCarPF2v/y+eXTz/sOXJaTJRZogR9Un2WzE/lcFLVDWlnn22bsr7XN3i16DGeFKe1ylvjwsMhTKUd60Zm7SYXgMIwBgnpfvtTXxHSaWADAKUOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=C5NCI/ga; arc=none smtp.client-ip=209.127.231.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="C5NCI/ga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789191375;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=x+1CHNOPbt8KaGgVhkriM21cLehyfxKo3I2vYEiFVTs=;
 b=C5NCI/gaNmTQJVI8mi6MRMxoYDZ02O3ptav1cEtNf/TaFf5ASu1MK6A5khFKV2bjvyEbkz
 ZNe0FwP/Aar/GGTKG/eNTFDvvQ7dfUmSgCtfXG4NAreiwU0378bRsf2/HsGQzY+DR87aA8
 6sOfGb4shG4oPVRdTKBBf466TfLwZ5t89zc7muVyV7SlbhRFZkWC9dQP32QY5MiKdb3zum
 Vtk1nGk7mXqMEzmwwCZvchKbioFvcR9U8EWwdJWDbY5R6OCfJeGBw2ZP0LZXi/Qa11Md73
 Be1udthljMXXCPkETu5Legc9wLI2vExyd48+9gxPm4dx0mAwFsam8OKB0WkwVw==
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v4] md/raid5: validate payload size before calculating payload_len
Date: Sat, 12 Sep 2026 13:36:10 +0800
Message-Id: <f55e0683-efec-4447-9c12-bd400470c281@fygo.io>
Reply-To: yukuai@fygo.io
To: "Martin Wilck" <martin.wilck@suse.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Sat, 12 Sep 2026 05:36:14 +0000
User-Agent: Mozilla Thunderbird
References: <20260907155103.2325511-1-mwilck@suse.com>
Cc: "Xiao Ni" <xiao@kernel.org>, "Li Nan" <magiclinan@didiglobal.com>, 
	<linux-raid@vger.kernel.org>, "Martin Wilck" <mwilck@suse.com>, 
	"Junrui Luo" <moonafterrain@outlook.com>, <stable@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aa4e4cf+b95795+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260907155103.2325511-1-mwilck@suse.com>

=E5=9C=A8 2026/9/7 23:51, Martin Wilck =E5=86=99=E9=81=93:

> Commit b0cc3ae97e89 ("md/raid5: validate payload size before accessing
> journal metadata") introduced a bounds check to verify that a given paylo=
ad
> fits into the current metadata block. In order to calculate the payload
> size, it has to access the members payload->header.type and payload->size=
,
> the offset of which may already be past the end of the metadata block,
> because the loop condition only checks that the first byte of the payload
> is inside, and the payload entries have variable sizes. Later on,
> payload->checksum[0] and payload->checksum[1] are accessed without
> verifying that payload->size is large enough.
>
> Add another check to make sure that payload->size can be safely
> accessed, and make sure that the checksum fields are accessible.
>
> This issue has been found by AI (gemma4, Gemini) during a backport
> review.
>
> Cc: Junrui Luo<moonafterrain@outlook.com>
> Cc:stable@vger.kernel.org
> Fixes: b0cc3ae97e89 ("md/raid5: validate payload size before accessing jo=
urnal metadata")
> Signed-off-by: Martin Wilck<mwilck@suse.com>
> ---
> Changes v3 -> v4 (Yu Kuai)
>
> * use u32 instead of uint32_t
> * use <=3D in loop condition
>
> Changes v2 -> v3: Fixed another issue reported by Sashiko
>
> * Modify loop condition to make sure the payload->header.type can be acce=
ssed
>
> Changes v1 -> v2: Fixed issues reported by Sashiko
>
> * fix use of wrong variable name payload_len instead of mb_offset
> * add checks to ensure payload->size is large enough to hold the checksum=
 values
> ---
>   drivers/md/raid5-cache.c | 34 ++++++++++++++++++++++++++--------
>   1 file changed, 26 insertions(+), 8 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
