Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA05F30F95C
	for <linux-raid@vger.kernel.org>; Mon,  1 Dec 2025 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764598395; cv=none; b=tR3dschgnPoQ5nOTtyJI/aUzBjAYOMd/rFUIaggajerqKlXCbNmoE0Owk3yGIDaAAKLfuogMOC/rTCIP3DqS7jkugsVU40K1Y7hKz9KU+Bc/g+LfIW9/yDTQ7ONIBDv+N9t7GtvfyalIOLSfq718buqSfySIrcyYutusfHN98nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764598395; c=relaxed/simple;
	bh=CRXxibKS5o3QXS3SaBQ2sZAVP47i3yD1ZCTFJscAjgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YD6Lraso8HpAtpc01ye1ypIW6mONd984ILrYLXriudQs6v/xIHLKcgUwK9u/61SjjHoYUxqr/OqcdRybcayOVrgiws6jC3ol+9R4vA6QSe8EA92lI+UD5Jf5sXW0npt9L2czm1ol03bWMNI5hvn+oxIMuyqCbEKVzGhBUizIMIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com; spf=pass smtp.mailfrom=lucidpixels.com; dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b=gNalMFU2; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="gNalMFU2"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-65748e230f9so1687032eaf.1
        for <linux-raid@vger.kernel.org>; Mon, 01 Dec 2025 06:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google; t=1764598393; x=1765203193; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ht3XFr7/7WOcNzTNEuT0DuzzCseuuyaUOrQvdMSUmw=;
        b=gNalMFU2qL6eRv1t25i/kxuxAXVu7Tkx0sZT22nI0ZP8+UopokH7d7X9fybriPlmIk
         e/eH8a4rQJlJqIuXLJwEL9w/Y3KH3UTxWmBi3ak8H3x/V5hj76pKMCpDYIZmOnDxFmor
         3P7yWORdIGtzZw+HvEOGSRvbx7mEkWvA7S9p4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764598393; x=1765203193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Ht3XFr7/7WOcNzTNEuT0DuzzCseuuyaUOrQvdMSUmw=;
        b=PbfLy+zlBSasP3IFqVwDR96OmUrTVg5r+Pedr8GUaDqYTuu/S9xt2EQhbovLV+7ot8
         GNGPnZy6cPztv+FKUuCcHl4IhaXuLNqC8zYvrB0pbh3Eq/SIflYkU+R8HTY8XQ+V4Zfc
         W4ghMNXYw2pkoA9dq/bS2/jMjiD3lhMDvpm2T3foRPansqIOckAJS1T9neAnZE25iV9T
         f0ZywlG8H0+pEGqF+4x7CxYa1BYu5FpDwgWRoGJ5Qgt85GPL0zu717IGbgV5oNHwxYHK
         ZD/llofcwAe//9zjy9QrO5C3aaGXPZ/hAc05b4/P6isKfqHPsVx5EYBxnmPvXLIhhr3I
         allg==
X-Forwarded-Encrypted: i=1; AJvYcCWhHHhUSAtYeElu9V02+z1cUefzYPbzZUPCvv8qAcIJ4XnXab+0puMoeQ3Io88JbXzbioV73+XzXwsH@vger.kernel.org
X-Gm-Message-State: AOJu0YxXe7KVff8nNCTJgmX+il/0buc3MPPN3KtQKrl4/0geFYsN4xwB
	izesyb3lQHJKIir4+RDcK6f3KLSk6naecOcxD+KlMTjnA2KBZwehWtLusKShkh60xZDg0xT4k0+
	20SFrTBYIYmFGVda9lkkXxGB6FQmb1PvaEhfKVdMNuQ==
X-Gm-Gg: ASbGncvpMQXJipRLz98TfrpuPxmazyRWK8Whn9761lBCSpH+BN7UFESRik2qLj68JqD
	55nc9euvgMoLkIabNeylfl6pVrwsk4Q8/F7QtG6qjw7sPkxAZLUHFnWHSfQX8KmWkk7W6iZAc/m
	LsqILdmR4rc+E0CILkqmZL9GP42g5xXH07YpDs90qRhNAdBfVS3gSoKLb+Z21gkcD2bu96cyb1r
	B8ImaIrJ9I6sy+9iG7Y4ukGRg5Fs15VGcDMaINsKisvAr2r9osbAo4WZqzTOFleDG4HKvIhPsLd
	tddJzZM5hqfWEU6FUR3ueMKimcdqlfREisZ3gDdJuf/uolHNWEcw7KSxDm8EKXc=
X-Google-Smtp-Source: AGHT+IHBbgc8lB9i54rXSqzF6P8AJv0GIEgsiuXhi6WtMVciJYCjym2BMgYs+T9pSsyV1Wq14+HPqiEfCQEl0yeRACc=
X-Received: by 2002:a05:6820:1524:b0:657:432e:a820 with SMTP id
 006d021491bc7-65790eb8958mr14276460eaf.1.1764598392784; Mon, 01 Dec 2025
 06:13:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
 <aSXDnfU_K0YxE07f@kbusch-mbp>
In-Reply-To: <aSXDnfU_K0YxE07f@kbusch-mbp>
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Mon, 1 Dec 2025 09:13:01 -0500
X-Gm-Features: AWmQ_bk3d93SsGZafRPWCihS1bzPTNFEpmuf6SICcoksQ9XfTkFEcuzxLZZu8X0
Message-ID: <CAO9zADzUZYzM=xkvHPXepQP_+6V0f4__yroPNV6feyPB27Ju=Q@mail.gmail.com>
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
To: Keith Busch <kbusch@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, 
	linux-raid@vger.kernel.org, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 9:56=E2=80=AFAM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Tue, Nov 25, 2025 at 09:42:11AM -0500, Justin Piszcz wrote:
> > I am using the latest Asus ADM/OS which uses the 6.6.x kernel:
>
> It may be a long shot, but there is an update in 6.17 that attempts to
> restart the device after a pci function level reset when we detect it's
> stuck in nvme level reset. For some devices, that's sufficient to get it
> operational again, but it doesn't always work.

Nice, I was not aware of this, thanks!  As this issue appears to
affect different consumer-level NVME drives, any efforts to address
the quirks in various NVME drives to restart the device while keeping
the volume intact would be awesome if it is possible to- get that
point in the future.
