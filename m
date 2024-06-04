Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858081465BB
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 12:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505195; cv=none; b=BJvYaYyzSoaqolp9gUo1rOp1oCDkJec0NAC6IjybgUqt8EglCYIecIpOBOAbwek8ebxP4QdPCnug6fz+lxANpVJK/ZQqmGNCYSVocmPgmJoy7Sc+mPZfcuFzoSOmgP7QldbJIFg2yKDUTuNhlMHdUfd628dtHUTQD0O6dqHY1I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505195; c=relaxed/simple;
	bh=NXW1j4Ieg2nzadFvl3DM8Ghb6bC330ClsF7c6MjBmxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZpXHbPPiUH/gNGU2QhhURz7kiBrimjFfDXzBwk6gLCZ2gOXIVLjzd48/xJb5oIQOa43RxQ866gZxUFivHbEMGKU7kaupLtd/jyfS+eyF/d6OOHeOxgebXzUKloXPqoOiieKiaxnmai/RpSuY0VtutFsp+FEYbm16PYVdecBDbLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bPj9DQO7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPj9DQO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717505191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iS6xQ3th/yQmC0sKOHvI2xRA2lFfuXvBRDYCXPrgQn4=;
	b=bPj9DQO7h87iIclquuQir1EVqwdYIW37vfr8zXm8Vwjc6lHh8xoXSjiJXwW8yoh/GYnlcC
	WGlMstqcSTBVBGier4MIL9b1SXrk/XjgfJg6c6O/3ySHSuFpzt/D8D2NEZghK/zBD0hUlM
	288ohH6sDOK3Rv/vCCZsPGGqzsxDBKI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-RhoOSyKYNeWaSEu4fD1AYw-1; Tue, 04 Jun 2024 08:46:29 -0400
X-MC-Unique: RhoOSyKYNeWaSEu4fD1AYw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2c1e9cbab00so3027221a91.0
        for <linux-raid@vger.kernel.org>; Tue, 04 Jun 2024 05:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505189; x=1718109989;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iS6xQ3th/yQmC0sKOHvI2xRA2lFfuXvBRDYCXPrgQn4=;
        b=bxHeGIDhf1R33P5TpOGbtkJ3CsqtajrE7eAKUEW4Q/+c9b5d1JH+9HbIueUpyyvS1A
         vnSD1ZVj0lGliucfn+1isnJVTbQCZVMe50hoeri2WvuwM4Z7lhLOXEN4OUCmUlLBuZgl
         /tH/kopzoSav4vNYh321EI0LiyosLK60HjL//BT7OE7y/RgQ+0Sw0DJQREWEhCEUuCHZ
         PQ3Cjh7p/OrfHqA6QbGz3hIhuCuygm3T+yZeN2Tvlxe8QRYpdZNu7vQqFbSZn+f2VaY+
         CGVAh2bMFfhmerUhrQOO3ooJ3KkW3tosVJcnnvduZ6FOOV5j3/ZaVCPDdRs8uijSrGwr
         Zqug==
X-Gm-Message-State: AOJu0YxQDWWFfFqNMzx19bz44FbQtcTiOXS92bDt8m8gxbeUuv3cTPtT
	zmXh7wIsYKaNi7ElLXSF9cCwbAjwyIVLjbcdH7qSdoGBRd8ZfJdk5zt0eQPjTH3ATVbJJdwUhMi
	iJg+HYHFtXRazcVv3DQ5BiLpIjBFqg9tD3zhNFc6J3NT/VLYTHWhWOeb/6wwPIWlQVWStVKHa5y
	f5ddOwoSUemxSnpMHOiYyqRbuzmaYCBIwIMQ==
X-Received: by 2002:a17:90a:17cb:b0:2bd:47fe:6dec with SMTP id 98e67ed59e1d1-2c25303f6c3mr3889290a91.5.1717505188776;
        Tue, 04 Jun 2024 05:46:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGs+stGNBOP2X35oT+W/b+GB//307eKX+y5g0OgTuBmmF+94EpBWTi3ReJpEMjT5MwGwE96XAet5H3lWUwVZcs=
X-Received: by 2002:a17:90a:17cb:b0:2bd:47fe:6dec with SMTP id
 98e67ed59e1d1-2c25303f6c3mr3889267a91.5.1717505188387; Tue, 04 Jun 2024
 05:46:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528143305.18374-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20240528143305.18374-1-mariusz.tkaczyk@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Jun 2024 20:46:17 +0800
Message-ID: <CALTww28s44pewrDH-w+djGVnUXi97bZD1upESixCZmUDPNKHKQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mdadm: add --fast-initialize
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mariusz

The discard can't promise to write zero to nvme disks, right? If so,
we can't use it for resync, because it can't make sure the raid is in
sync state.

Best Regards
Xiao

On Tue, May 28, 2024 at 10:33=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> This is not complete change but I would like to get the feedback on
> concept proposed. There are few features for optimized space zeroing.
> We already support --write-zeroes but Intel would like to add support of
> deallocate command (discard) in the future. There is also Sata trim
> which could be potentially used.
>
> The goal of this RFC is to get feedback about proposing one option to
> check for few features which can be used for performing smarter
> initialization instead of resync. With that, user may just type
> --fast-initialize and mdadm will determine what can be used, else abort.
>
> This won't be merged.
>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>
> ---
>  mdadm.8.in | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/mdadm.8.in b/mdadm.8.in
> index aa0c540399f6..be592d70ac9b 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -849,6 +849,17 @@ each disk is zeroed in parallel with the others.
>  .IP
>  This is only meaningful with --create.
>
> +.TP
> +.BR \-\-fast-initialize
> +When creating an array, check disks for optional features to perform opt=
imized initialization
> +instead of resync. These features are: NVMe's write-zeros or deallocate =
and Sata trims. If there is
> +feature supported by all drives, it is executed, otherwise error is retu=
rned. This option invokes
> +.B \-\-assume\-clean
> +.This is intended for use with devices that have hardware offload for ze=
roing, but despite this
> +zeroing can still take several minutes for large disks to complete.
> +.IP
> +This is only meaningful with --create.
> +
>  .TP
>  .BR \-\-backup\-file=3D
>  This is needed when
> --
> 2.35.3
>
>

