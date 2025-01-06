Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DF51DDC1F;
	Mon,  6 Jan 2025 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178069; cv=none; b=NpwMUZq/8v2T0lAPCbspePT8Nt0Zy+O5qo5aNi3dzool1VE3KQ+Q5dRvLuN4hp2CKiIwXskm56ZNX/9K2gZsEsnNulhdF+3mL1LfuMBVdW7CFDmXd1X5SDtsDfVJep2mbVvVpsE8M416uY3ph09uvgHflNde4WVm/nKV/gY7QI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178069; c=relaxed/simple;
	bh=yoG6+WArlsjOCBoo7XkruO5nKHN7y9E1EjJ87t4zfIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3G8v6QXOPIQb5//kv+iFJw/nfGPmTym+zrakChDRpA8TYvWgIqRN0WV+3yPXnHlhffbd5d4GpGcIlLpPBY7ZoCWvmCHocoVy+P1gkOU3RVmeHwBUZ4BAh2bO0511tjtbSK4B05AXZnr6zL7C7qm+ONML79/VAZYzgLsll6E7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGDRa1tN; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGDRa1tN"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-4b2c0a7ef74so8179194137.2;
        Mon, 06 Jan 2025 07:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736178065; x=1736782865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HHDpDpmv2A5YiL2QDQoz+0mXOlcc2LYRgqo3E8y/Pmk=;
        b=lGDRa1tNusNzdl7RkXjNXN8vSM8vY7IL1yqU3MjT81mTOYh6SPAGpbshAC6gf/MjRP
         E3UiWe6aBnd+eGZnD23Xarg+2zOwR/eGQjocFNCM+199Yf29S5kqtdlQug2g6q19g9ia
         DPq7QBaf4+OZsSfaxaMQfeBJpx1hhhUHjU1HKM0wNDMuejuF/kOFP6lvQxmPHInKFsFa
         4wWuK/XRDOhIj6AEd4nNxgxlythD3EdJ9L2QadM4qtNI5dArbe4/9DOkbppQlGrEXUww
         rLjMY1kVnXNZKSyjh1L2UtQJD0xoUnXlBigF8zTx+waWLEfcITmGBCXeMapXOPyxfmrU
         UJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178065; x=1736782865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HHDpDpmv2A5YiL2QDQoz+0mXOlcc2LYRgqo3E8y/Pmk=;
        b=LYKaZZvcJhOCDR7//gVHKRswl2lvqGU03Rk389nx6SCIETYsIIsD5+hUUruYIdGkLu
         Q7/D+7AxDmUIXA3ZF5I7CMyiiueEXwSFyOaiEb9apKSagdtVM8QU7ncw29+pCh1em5ZF
         O9+8mWQXTaXbkNN+jsmi38W3o0pZmYQTHRtpXNlv5J/k2M3r5cdckhtGcaU05BcQcgMs
         YR4PoN0k0n3A+pr70B/WK51DDafO9/l9eKBS3iXgdRxyYX6/yKROINNdvGpK71Xduo95
         haIpXPiXD0bl/ZgvaZHEOOf7OmtBbxea0NBPwS4HLiULfP2loLni76f5JWj1Wy/nyJQf
         1A1w==
X-Forwarded-Encrypted: i=1; AJvYcCUEZlzs+7xz6Jms4mE33kXPkPzJUneCwQMKUu2wsqQdJ3R54gU15bIws17DoWXYuNT0JGZULVfZVzb9dA==@vger.kernel.org, AJvYcCUQZpNshIKFCTwst1XTO+jU04HMxP+p6bNHqruim6vgZMpTW+EWRGf60E24hQ3PNxFCxmZNgM2coEvENqc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0mxoBKt+udQfu+g3pC3tCvsDpOiozFM/brC5zpfa0tzXDEhy9
	KkmmyKCyKAsBiDKqdTXh3o3TIJReD8lOP58SBK+Xih2feicopfJmLjB+WAK9QS+NN6Hn2G5bxii
	vVYyGXYLb7aQuTh6sK/0bPwY1FzEnAqI=
X-Gm-Gg: ASbGncum1+UOfhvBnY/P0ztMF2X8Ks6Bi2atVVvASgrBzw0ZJTJnue3xFlRmid5OGqL
	14DLtlgD/hNApqupxwBMVi17jhgWGwm1D4vg=
X-Google-Smtp-Source: AGHT+IFV5/4tD1TRojoe5+3DQPNJTsIA1oR6LGHsCu8KYpKIWsv7Ipyf7DSDZsrtitWJEwkw76qzwZykUPs40eSx7l8=
X-Received: by 2002:a05:6102:3a0b:b0:4b1:1eb5:8ee5 with SMTP id
 ada2fe7eead31-4b2cc47782amr43655325137.25.1736178065550; Mon, 06 Jan 2025
 07:41:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com> <Z3v17kZYZnvYPpsl@infradead.org>
In-Reply-To: <Z3v17kZYZnvYPpsl@infradead.org>
From: =?UTF-8?B?VG9tw6HFoSBNdWRydcWIa2E=?= <tomas.mudrunka@gmail.com>
Date: Mon, 6 Jan 2025 16:40:52 +0100
Message-ID: <CAH2-hcK-yF2SbxpXzB2c1Y73gjJxRfbPkmAOvmfM1Uh6QyT06g@mail.gmail.com>
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header file
To: Christoph Hellwig <hch@infradead.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> the bitmap format is not a userspace ABI, it is an on-disk format.
> As such it does not belong into the uapi.  It might make sense to
> create a clean standalone header just for the on-disk format that
> you could copy, though.

If you inspect the header in question, you'll find that this is the exact
reason why this header exists. To describe "physical layout" of
MD RAID devices. Which is just fancy way to say "on disk format".


$ head /usr/include/linux/raid/md_p.h
/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
/*
   md_p.h : physical layout of Linux RAID devices
          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman

po 6. 1. 2025 v 16:25 odes=C3=ADlatel Christoph Hellwig <hch@infradead.org>=
 napsal:
>
> On Tue, Dec 31, 2024 at 04:09:27AM +0100, Tomas Mudrunka wrote:
> > When working on software that manages MD RAID disks from
> > userspace. Currently provided headers only contain MD superblock.
> > That is not enough to fully populate MD RAID metadata.
> > Therefore this patch adds bitmap superblock as well.
>
> the bitmap format is not a userspace ABI, it is an on-disk format.
> As such it does not belong into the uapi.  It might make sense to
> create a clean standalone header just for the on-disk format that
> you could copy, though.
>
