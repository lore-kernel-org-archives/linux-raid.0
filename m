Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B6B7DA67
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 15:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730820886; cv=none; b=VOm7EeJoq1EIPwSko7fYhOVzye4MsR36+etv0K429DPFlPoWXnLvaW7+00nYFuc5NtL8ZVrdrg5LV185Wy1M4VU08ps4AE1H4aogGskVzgAfpIfDBymwttEu36hKceRjtoSXOp7w832eE6ptKz2N/t1fTSv3zm1VAW35S4f3JdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730820886; c=relaxed/simple;
	bh=0FedNKqu1ZHwzYt1VC/VTy6yaRoSwcxOlbX09+uRmDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sqy6ElsNFy0kZwOhy7jgsu6m/Y+tk8I5sp/rJQaALA2hOwEBPgSK2eTNom3IltQptygkxUDXv3UIzj41kbk+An9+HUOhmUelswZWD3sBY2v1Eq2XvYkxVz3DepY4tbp0RwwgF5zPDTzXb89tM/LbDoUOp6WMi059ri+f58BhBCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Jo1Gw9tl; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Jo1Gw9tl"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so82274571fa.0
        for <linux-raid@vger.kernel.org>; Tue, 05 Nov 2024 07:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1730820883; x=1731425683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FedNKqu1ZHwzYt1VC/VTy6yaRoSwcxOlbX09+uRmDw=;
        b=Jo1Gw9tlfaNcVjWcU1v+4gI8dIASZ0/RNzVgwtyfSFene0+bKfFuYvbFDgSZYD/guu
         /v+/qr3ouXzY/C7muRH44stM67M6O4VmFKbedGasUyM99Eb+roVMJoqOs0aXcWtC2hAW
         YpnsjS1YTAfsG7nBGpgYRnBh9o4GfZglxPfFJ+Gczs2hSfNA2ZR6ECrnMlGpsovXRDwo
         pat7vlKLK1rJr2JshAylcctQSVKnKhdec2+rWthm4PzQGfmZ+JkT5EuE88eZ6wwib79J
         UqmTQIhfLXp7sLtsbtvaPfd5bd1CsbT0i5L/U8kCDmJ7XEicwBx4dl00DuHGfJwI3FFI
         jwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730820883; x=1731425683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0FedNKqu1ZHwzYt1VC/VTy6yaRoSwcxOlbX09+uRmDw=;
        b=eN+YY/FrXyE9BVkG5ZnU+hDOCrpiGihJA90fY4Ipg3siVrsWTUEMiRJiWabih1SFZT
         kS5rgtqhnP3gnc6CtjNCLhOJk9EiRfTUZow/1BGULQ6NlbnfmIELacUeHlC1WJIfChfn
         WQW1GOjvJe4rABYR+xXNH1re617Uwgj4iCFl2SE/meojEhwGpBDKZlnRs8tydQh08t4Y
         Sp7UVqKnJgO3kiZvjuFbsZ30lwB32Q11rdjtZpmDaF4S7rOj6QIX9OXFLZNH7I0wTo3W
         M6e+Bkz3BX4BvQlBH5+mhiSe70m6ZbEAVHh65vkmPyweDEc1sNcqhNLbMVuFm8RBbcww
         4tLQ==
X-Gm-Message-State: AOJu0YyOhxDMmGJMv6D5ULWuSGF2xz4qvMSv20O/3q183s3OABXIbfPx
	anBWUg3s5zt/5XkpAEQFGf7lkoS7NwJm896g4a5a6IGjuX9DUj0F7KaJNvOxM6AkrVlHowumgil
	xxwtUaCdhs4+waUGqidA5xRBuJfDc+pYyHnHIGQ==
X-Google-Smtp-Source: AGHT+IFIEkNWdobYc7IhJZDnEnngiEhQJsOSYROwVtx+HJI24xAdSSXYvUtv/7b7zVSM4Smk7ZoMNE9/VGshICJe9Pc=
X-Received: by 2002:a05:651c:506:b0:2fc:9869:2e0b with SMTP id
 38308e7fff4ca-2fedb7c7dc2mr118768531fa.20.1730820882597; Tue, 05 Nov 2024
 07:34:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
In-Reply-To: <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Tue, 5 Nov 2024 16:34:31 +0100
Message-ID: <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 3:04=E2=80=AFPM Dragan Milivojevi=C4=87 <galileo@pkm=
-inc.com> wrote:
>
> On Tue, 5 Nov 2024 at 10:58, Haris Iqbal <haris.iqbal@ionos.com> wrote:
> >
> > Hi,
> >
> > I am running fio over a RDMA block device. The server side of this
> > mapping is an md-raid0 device, created over 3 md-raid5 devices.
> > The md-raid5 devices each are created over 8 block devices. Below is
> > how the raid configuration looks (md400, md300, md301 and md302 are
> > relevant for this discussion here).
>
> Try disabling the bitmap as a quick "fix" and see if that helps.

Yes. Disabling bitmap does seem to prevent the hang completely. I ran
fio for 10 minutes and no hang.
Triggered the hang in 10 seconds after reverting back to internal bitmap.
