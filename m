Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CA77482
	for <linux-raid@vger.kernel.org>; Thu, 20 Mar 2025 05:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742449578; cv=none; b=jZ3WYosIDQWVjJMZQTiir+do2B0fzg8efS/2TrdXz/6BqkpUEKIUTjoHr3sY7pR5UxJHvP7pWW1/XSzr96wlRGX5th3RfuJXj8KE1R4ISghLpXs2/Lg9d5+wrJ4VOmChxy6EVPfrKLwOsrp/eb4tid8/PjvAqpHJmwSAWlTsEx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742449578; c=relaxed/simple;
	bh=w10MUh5sX2e5Jxt7uWkrd8IfQB2z7r2wHnBu8Mr/RfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ESSlnH/zfplxJl5XrANzKf3Enc2rN7C8xdszXcQasD83rrJGD+cOA8GXmRJDNUQ/Uwcpis8QRqJZ3KOxuiPCRPdZjXRnxmNJlM5+K18/aHurBjIyEzaLfPxCm5z5bTNJrQ6sP2PMgiavgNBTX1Sw2wrI3KqpRs95vYj358LI4Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gxypsnnS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gxypsnnS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742449575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w3q80VUKuc+bnjnuFLzddX//QfDue9LptHU4h3m8H6o=;
	b=gxypsnnS/jnE+VOILb9dWIm8qZRHhgM/JNpamatRrIaqipmMWAd/8NPaRf/PqZ4vV5VFby
	MD5L6kfkln407/Lgq+S+FRTl1lXLiChixvYp2Tz6R37n2WaSlvRHyPKZMC5dmWaW5NlXfg
	nqVyaQFwvlpDxRxRdpvmarSh8yxtgOE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-YY10SU-HN_-_ocqLzfKkBw-1; Thu, 20 Mar 2025 01:46:14 -0400
X-MC-Unique: YY10SU-HN_-_ocqLzfKkBw-1
X-Mimecast-MFC-AGG-ID: YY10SU-HN_-_ocqLzfKkBw_1742449573
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5498f71580cso162655e87.3
        for <linux-raid@vger.kernel.org>; Wed, 19 Mar 2025 22:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742449571; x=1743054371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w3q80VUKuc+bnjnuFLzddX//QfDue9LptHU4h3m8H6o=;
        b=n5v8QtU1dsr/fGD7J/89hgUEQ/sAm4zR5JyYS7/0Ww0izOPUOAnsu8NDPSvYpp/tMg
         mHPh7K2Q/6rkriBTRhbTWOTwLtCT4J+4AMGVKGccycTjWvOaXrd2zaOUPogk+RbksJsJ
         wR/M11biz+Ip3ZdXq+v9gsj4P7OHbQCyvGIc2CIKP1f2QKXootTKiYbAEubP7cfJrDCh
         X0Kla74iJZxTGlErCuOke++wLJX92CUUsW1NKwRN2Rw7y6g+qEsXKSonKABfgYtf7l8B
         5sRQfgQgvlD/jjiDO15fBDQizFUwZqjBfNIY6tai1MKgsBO47vNOrP3i8uTz8n5Jv8S+
         xPgQ==
X-Gm-Message-State: AOJu0Ywn/YzYGvWxNjw6l8YZoIndvDtSRZKlCJcFD0MLO+apWhCmwsT9
	+2IpUn/wPPp3UpDHGHOFfdlKXLIkp6DnIEnUCv1Yxz3M1Un4AgvxXZQPip50VhwDMUftl8a1PV6
	j8BaaW34KftxZRay+GdRzGNHspKf8YLpggiE+Sr6DbIvPURExiYpaJ1rSrNqZqv9+ssckI/H8dp
	kotvY2HnVfttC2kr07SQ9eDwwmxWEwHOdQQerHrVHg5qVC
X-Gm-Gg: ASbGncs9Itu/yPHIAaYYKY/uVWyw3mRd1znW/NHSnz/ud0hid2a+orloFoU2IXa0lTy
	L1QJyHDGr6MtELdxo7VXdRyyU0CW54OTWSlHYTdSTrurtcEfrH2ixI8xHfpyjR88QBCOw+MIdnQ
	==
X-Received: by 2002:a05:6512:3056:b0:549:7590:ff24 with SMTP id 2adb3069b0e04-54ad062ae52mr552081e87.22.1742449571077;
        Wed, 19 Mar 2025 22:46:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0azr8OFFHGsR3VKeNBFWIcQ4oZCE+qd4KoLpXnINevDrTIg2WQrzv1oqy4folbTmbYesWW1OTc7r5qOXXd1k=
X-Received: by 2002:a05:6512:3056:b0:549:7590:ff24 with SMTP id
 2adb3069b0e04-54ad062ae52mr552076e87.22.1742449570649; Wed, 19 Mar 2025
 22:46:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250319171058.20052-1-mtkaczyk@kernel.org>
In-Reply-To: <20250319171058.20052-1-mtkaczyk@kernel.org>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 20 Mar 2025 13:45:57 +0800
X-Gm-Features: AQ5f1JqsJdo--dWGh5Ep1zrpo86pCG2sPHcpe2e5fc6xMsDt7ZSZ0RCtmbmQQzU
Message-ID: <CALTww2-f_naEH2XFXNKhLNn4LkJf9XS6nNiduHXXyYMQP0bQpA@mail.gmail.com>
Subject: Re: [PATCH v0 0/3] mdadm: Use kernel raid headers
To: mtkaczyk@kernel.org
Cc: linux-raid@vger.kernel.org, Nigel Croxon <ncroxon@redhat.com>, 
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 1:11=E2=80=AFAM <mtkaczyk@kernel.org> wrote:
>
> From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
>
> Sending on ML for wider audience. I would like to confirm that there
> are no objections to remove klibc support.
>
> Kernel is exporting md_p.h and md_u.h which were newer used by mdadm. Thi=
s
> patchset integrates them with mdadm. There are some missing defines in ke=
rnel
> headers, so they are redefined in ifndef blocks.
>
> md_p.h includes asm/byteorder.h and it provides endianess casting functio=
ns.
> These functions are also provided by klibc. To fix this, I removed klibc
> support because I determined that mdadm is not compiling with klibc
> for at least 3 years.
>
> I also removed uclibc because it is not actively maintained, on other han=
d we
> are working to enable musl:
> https://github.com/md-raid-utilities/mdadm/issues/76
>
> Thanks for review and feedback.
>
> CC: Xiao Ni <xni@redhat.com>
> CC: Nigel Croxon <ncroxon@redhat.com>
> CC: Song Liu <song@kernel.org>
> CC: Yu Kuai <yukuai@kernel.org>
> Link: https://github.com/md-raid-utilities/mdadm/pull/149
>
> Mariusz Tkaczyk (3):
>   mdadm: Remove klibc and uclibc support
>   mdadm: include asm/byteorder.h
>   mdadm: use kernel raid headers
>
>  Create.c    |   2 -
>  Detail.c    |   2 -
>  Examine.c   |   2 -
>  Grow.c      |   6 ---
>  Kill.c      |   2 -
>  Makefile    |  34 ++------------
>  Manage.c    |   2 -
>  Query.c     |   2 -
>  README.md   |   3 --
>  mdadm.h     | 108 +++++++-------------------------------------
>  mdmonitor.c |   2 -
>  super1.c    | 126 ++--------------------------------------------------
>  udev.c      |   2 -
>  13 files changed, 22 insertions(+), 271 deletions(-)
>
> --
> 2.43.0
>

Hi Mariusz

This patch set looks good to me.  You need to re-submit the PR based
on the latest version of https://github.com/md-raid-utilities/mdadm.
So we can know if regression tests can run successfully.

Acked-by: Xiao Ni <xni@redhat.com>

