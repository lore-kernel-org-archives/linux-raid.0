Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92F72114;
	Tue, 31 Dec 2024 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735642950; cv=none; b=FTeN9N/JznEZP8Qbhm0AJGHtEZ0xC5ZIhZ6kO/26i5b1d0ni9ifLFW7UcOBhAq6qUS2E1/LpUXdvqq2bMSXa6gi2G9iIO6e2OWmTTYn7c0NH0NMqo3CNT8p3GTdppWuZ3bbfIUunrQ4S8baWsw5ZGorOU1+4KliNNYI6k/LlR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735642950; c=relaxed/simple;
	bh=6WLIbhFDumIaygeecfQqDbcZuV7Nk8oz0a3Ofyh7Vbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RzgmYpeqvODUmo/Wm7GQ+RcCsCOdR03iWRfFmlE+nY9T1gJarIIOqlL4/nKgdUae4KC0V985gvDbxHhwzuNcLd66tt2UazV7jz5AbBlJbwDayegJu0Na+7/qSe5vXj2JGnwHC177hv7i1XcVfn69RQB95rwVVr368B1JXvP/fYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRQLxpoK; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRQLxpoK"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so680506266b.3;
        Tue, 31 Dec 2024 03:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735642947; x=1736247747; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CRGjUkn7eqsnjG04q+ct8UrjZQp5gHm4owxu8U8CA7s=;
        b=YRQLxpoKwBwkLSRcqos3DTlBuzkaYTh8KXwAjIoYdHeHy1KEviBDPicYzabBispFSt
         4Ne/BzJ2/Bsw/m7HFZVJM11OXRr0PRDJivfYRGS0GL5OpoVdmgWv5XLd2FjL6m7xJNTE
         RDbkZvoFOmU60YybXsQiJswYT9MhkGJJC3lQTFW/mTmHjhFRVxBJix85oQWlS6+JtmHX
         4PD0xCaVNk2wg8HTwnuVyrSaoNH270/piWtWg52jUa3bcfF6R6nxXILd0k2tXUNaDh6X
         2OMhEtOPsx0pnmYG5DTLcshiuD3UAVgEMOw+pAyO0f61Rr2DtIZ+8RiFIuQ+DeTW4J7p
         3PDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735642947; x=1736247747;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CRGjUkn7eqsnjG04q+ct8UrjZQp5gHm4owxu8U8CA7s=;
        b=ds/gOYuFqRDoLp8mgWvlEF+vf8QrfHwNnQabaI1mqz5nHlqjBk1eDU/ETM+PwPRhI4
         0o56LryXqi86OU4lzns2HFkrJyTubvjQEZ7Lg03XmDp0m9V4I6UpdFnYanp+5Q3nfaUX
         j4j0wapRWgtF/vdaFrlWBy3n7/GAvZVrRrbsFcvDRIPsMG3h9nB/hPZVoqrLY51HYVso
         uLIv/8GH/td22KYmmaVJpbntC9azma0WIqLpOLegg2UF08mPQCfi4G6m2QI5GQcF0juB
         HoBc45ntnN7UFdzNp1nj0w4JipkptuRQTWTjAnlW1/IYEy4CPQnl1LJIrD6KthBDrAga
         6xvA==
X-Forwarded-Encrypted: i=1; AJvYcCVXxXzDf0TBmxqPOYDc0cDw3rYScem/fAmb6KBR5IsUZP16iBP7S3d1xNw4Qbnq7PQ/nhODE5qhoHwk2rA=@vger.kernel.org, AJvYcCWPznmHWX6RnvIYjUY4O/DqxxHDFKr5w11KTaAiUMMdwYAOGt3ZRPn+9OMczqMpwq6rkmRXh8I2Zn4CRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBK1Co9MqgySVhtSw+81VbhumjOGk+GdDjSOOy+W+WgIHGoN/Q
	vrmUyj2W+7Ys/rJxfq3qB+4aA2d7TefV+8VUsT25sRvkpb9KLB6VDU3qo7nmXbZdCzP3rRROC5T
	QS3MSDJ3+o4R3wLgi6vSP+PUGzw==
X-Gm-Gg: ASbGncvqwTQDP7fc9bT8TdjdRPV3g5XGFV6/ob9pHG/8kng4Nv1D1zNF01qPwr7ggYS
	Uyv7S0trYhVubsW8i+ZjRD92orznrw4Zn5cKy
X-Google-Smtp-Source: AGHT+IEtoE5hNUfeT7NODn5hWH5jNuBxVOykPYeZ2cCUW+A7qqJCB0bepsYV4kyE1byZ807+sQJHOfmchOBotaKtR9g=
X-Received: by 2002:a17:907:6e89:b0:aa6:538e:a311 with SMTP id
 a640c23a62f3a-aac2b28eee7mr4026173966b.18.1735642946833; Tue, 31 Dec 2024
 03:02:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
 <ebbec264-7669-03fd-7ffd-3c728168cdd5@huaweicloud.com> <20241231095942.446f4d4a@mtkaczyk-private-dev>
In-Reply-To: <20241231095942.446f4d4a@mtkaczyk-private-dev>
From: =?UTF-8?B?VG9tw6HFoSBNdWRydcWIa2E=?= <tomas.mudrunka@gmail.com>
Date: Tue, 31 Dec 2024 12:02:15 +0100
Message-ID: <CAH2-hcJR8DpvHHFc+NjYkjrjqNiuE8CRxhQPh1YMnVWE3rXPQw@mail.gmail.com>
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header file
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

> > Thanks for the patch, however, Why do you want to directly manipulate
> > the metadata instead of using mdadm? You must first provide an
> > explanation to convince us that what you're doing makes sense, and
> > it's best to show your work.

I am adding MD RAID support to genimage tool:
https://github.com/pengutronix/genimage/

It is used to generate firmware/disk images. Without such a tool it is
impossible to build disk image containing md raid metadata without
actually assembling it in the kernel via losetup or something...

I am already using #include <linux/raid/md_p.h> which includes
references to bitmap structures:

$ grep -ri bitmap /usr/include/linux/raid/md_p.h
#define    MD_SB_BITMAP_PRESENT    8 /* bitmap may be present nearby */
    __le32    feature_map;    /* bit 0 set if 'bitmap_offset' is meaningful */
        __le32    bitmap_offset;    /* sectors after start of
superblock that bitmap starts
                     * NOTE: signed, so bitmap can be before superblock
#define MD_FEATURE_BITMAP_OFFSET    1
#define    MD_FEATURE_RECOVERY_BITMAP    128 /* recovery that is happening
                         * is guided by bitmap.
#define    MD_FEATURE_ALL            (MD_FEATURE_BITMAP_OFFSET    \
                    |MD_FEATURE_RECOVERY_BITMAP    \

But when i use those, the resulting metadata is invalid, unless i populate
the structures from drivers/md/md-bitmap.h so i had to copypaste its contents
to my code, but i am not happy about it (including half and copypasting half):

https://github.com/Harvie/genimage/blob/master/image-mdraid.c

> I'm with Kuai here. I would also add that for such purposes you can use
> externally managed metadata, not native. External management was
> proposed to address your problem however over the years it turned out
> to not be good conception (kernel driver relies on userspace daemon
> which is not secure).
>
> Thanks,
> Mariusz

Hope my reply is sufficient.

Thank you guys!
Tom
