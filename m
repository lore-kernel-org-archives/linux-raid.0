Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265E71465B3
	for <linux-raid@vger.kernel.org>; Wed, 15 Jan 2025 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736954619; cv=none; b=Wugr2hVz3Ew0eSSo8jHVANPynWlVKv84iwBlnfSh2/pug0AIMaRR8sU1uyhw0lvNTb5oC+hMKZ9f1Jf5bm3Zo8AsdIRFxVmbxFQCOLqzZPbR6mdpv7ImPQ+y30U1XPrDxLq2xCyghjvIt92maonrlKYGNUmWv+bQdi+cMGEn6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736954619; c=relaxed/simple;
	bh=ZJUVq9OhB9ny/u6rokJquFSH0K9gk2yYCWzL7i9SMJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IrLB/UhlfEi3vysnA7Li8ue30BxhEQlWJeSWG0HTHlC005lVEpKJEiv0TNrjYUP1LFsMkTqlAZQQJVcFuiB/O2gm36gWi/EDs/RGjj2yQCSSeBKXiU2pl2FlsmAK4KGrw25vL5NXZ/GOOfyD92KZ93wSELzfhKI2F2tVzeYly4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QkXv4urr; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QkXv4urr"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ab2b29dfc65so1055671766b.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Jan 2025 07:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736954616; x=1737559416; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJUVq9OhB9ny/u6rokJquFSH0K9gk2yYCWzL7i9SMJk=;
        b=QkXv4urrggUHi0nRbAoKyJyFQpOwVR5Qzi3x1Ttx6BP+DY9v4FMhr0aD7F43SzU+pk
         XBElymxoW/tV3u8ZPHL0hTF4GAgl118f2/ARPWPn3MHLqYu2AvpnS63xO9RUU4DsN/yT
         vX9i4s2uPqwtnpbzLBh46+imukkVgSr/cK51Zwnl0WtF8UaWK9lHuF4hH7hWcDD/uDIh
         1r5G0BikY92pp/7uYgHXtJDWB9PhMLa4l8K2HbO3fCiqrvwTQm+1O7y8l68Z6uv6BmRp
         s8AWv4Sesfn38xP7ieKZ6HZ5eBsxNcw+DJXQzUVY+1ZcsVhlMsH1+i3i0sAE1Bqx3oCk
         A/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736954616; x=1737559416;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJUVq9OhB9ny/u6rokJquFSH0K9gk2yYCWzL7i9SMJk=;
        b=wjuB7LjLd5LgBNdhwqoULL/9+FtmVs4kywqSxA25yA8fo8p38Q7g4ozaDPIh27mJ5B
         wTH5T8162reMNH+RgFf3V+jtfMd4mw0nNwde4OLksH4DNwSFBHujTt4cj5DPvYN5swba
         fhlSSxibywhWA+mqGHgDwUKoY9sGxXBqebMnPxssSWJQF+AzYkTjCDHuivA2F40J4AHB
         5gFHxlfDTuN/gEuGkzHyqXrdtqApeLKYxNWX2yWy/VBrfXKiM9YSpXis/rwX4zEHtULV
         udI+h7EDX4BxXfe5sPZXiqS5jtm6RA71ABKdDIW2dpkucPaa7AcbnbdX3EXJKtWcHUFW
         9tCw==
X-Forwarded-Encrypted: i=1; AJvYcCW+RDHop658FLEpj5D0nyZVG0jjKwgCYc+8qBEE13CIhKbdm3/wPrlFhVMvHN25u1xpwLf7F1gDm61t@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4VePIFsDc5y212UxwJwkEkuAK41VgJ2/SPXag9tLWJs72tHS9
	nxB/qRRkHgFthd7j+SLXd6xwFJOneRAl3pcoobJILoQE0miX4WuhxwLoQ0fhjia3CLwoW8v24gw
	gUmpCqrKNs6HXmVq3tPz9P1ypiQ==
X-Gm-Gg: ASbGnctx+u2wFuILtBqQjSfECHkEXOa+dw3UGw3WGtOlVMW4vj2D8glot0fCRWfDug+
	GLuid3J5x1vQpBf8HUAeM/aJIeMT005ZHzBw=
X-Google-Smtp-Source: AGHT+IFHPqdKjD8ExD/hpF2CYkmvWDbLh1x3N1JJWNFjVZWi6+/EoahsTCyklg8fZO9PaDBTM0GYwArOBrA1Eott4hI=
X-Received: by 2002:a17:907:948d:b0:a9a:9df:5580 with SMTP id
 a640c23a62f3a-ab2ab6fd625mr2755649266b.19.1736954616230; Wed, 15 Jan 2025
 07:23:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250103103801.1420d5d5@mtkaczyk-private-dev> <20250103115422.20508-1-tomas.mudrunka@gmail.com>
 <CAPhsuW4i4FfgPVzAO-+jcjNHiWUuOrg4g3FKJbzt5f6UU-GbdA@mail.gmail.com>
In-Reply-To: <CAPhsuW4i4FfgPVzAO-+jcjNHiWUuOrg4g3FKJbzt5f6UU-GbdA@mail.gmail.com>
From: =?UTF-8?B?VG9tw6HFoSBNdWRydcWIa2E=?= <tomas.mudrunka@gmail.com>
Date: Wed, 15 Jan 2025 16:23:24 +0100
X-Gm-Features: AbW1kvYaZ_h-6ZLiIahWJ843xGZblG9rCkidexqd1u7eOtDwO4_iuLs5z_HYDbA
Message-ID: <CAH2-hcKnt-KJPRjgOrKq+DPYxB+sztJWYr4ZVJ2Eq7bVYe19gQ@mail.gmail.com>
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header file
To: Song Liu <song@kernel.org>
Cc: mtkaczyk@kernel.org, linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, 
	yukuai3@huawei.com, yukuai@kernel.org
Content-Type: text/plain; charset="UTF-8"

> I think I understand the use case now. One question though: Do
> we really need to write the bitmap data at "mdadm --create" time?
> Can we instead wait until the array is assembled by the kernel?
>
> Thanks,
> Song

Thanks for reply. This is kinda what happens already. Most of bitmap
is populated with valid data during first time kernel assembles the
array. BUT unless there is at least some basic structure present in
bitmap superblock (magic and geometry), the kernel will completely
ignore the reference to bitmap in the md superblock. So does the mdadm
when examining the array. There seems to be some sanity check and i
honestly think it's not a bad thing. It just prevents kernel from
overwriting data at some random offset, if the bitmap offset field
ever gets corrupted for some reason...

Tom
