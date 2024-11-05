Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041F71D5160
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730815482; cv=none; b=lea/UoCCTx/kQH8EZd3XNiFIZyea8OyleqR330hcKmDVu+zpuv2I77R9yiQEfg+ZWXJOAfGJhfATyeqsi6Tibhkhw/zInTB2Z2jm22pMAhN5BbsPEHeXsrLUspUfPTDCge8e5bLXhtinvs+PLXRHWlWvPf8w6TmfiS7m1mF87Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730815482; c=relaxed/simple;
	bh=IHOtoSuEVC15PJxHUSnSOdhrPGNrqdpmqbIbmqqpvnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZKwQp0g2Qe1ECW52Czv3eUB0GGb/wXKA3Ow2rYgT8WdQu8gkd43PCORkjEYSUO05gyBiKz47BmKgw0f+62gRzfTBIJzK3a5UisoEyO3kGd/+olYmwQLMi7B0U6xWvjwW2Se9nDcMtZEmZytrNVzcQb41Lk7ZlBI5MtwTXgNdkHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=Iz7qHuc5; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="Iz7qHuc5"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20c7a14ca26so3713265ad.3
        for <linux-raid@vger.kernel.org>; Tue, 05 Nov 2024 06:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1730815480; x=1731420280; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IHOtoSuEVC15PJxHUSnSOdhrPGNrqdpmqbIbmqqpvnY=;
        b=Iz7qHuc5kgD2m/F4N3ywvtOCee1kKsqe3DPRICWKVZTbnDBw/4mx8x0n7Of41cHugp
         eyVJgYM2ErptJT/0k7ogtVIiMOMMbfA/+YhZd9slmHErSnwnDbBnzQJU680ftVSpmuit
         JZvmb3uiAS3gt2g9+iJRJcG/1vQf4TsBkEjIyYQtUaL3D2o2C79AlZq+/k77HGocMX9B
         4cg5avuktuq3Oj4/DxL4EwfWNu7ADSnJNcXWwXQ55U83ISI1LcIYvqns3XJvO5bLL0Kz
         oJmlE6ocVQiOhsb41S8cryWMSRuhlUeKr7wSVtVYvN5Gu6bLr2bz2TigVzha7gqPlrG7
         7Q0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730815480; x=1731420280;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHOtoSuEVC15PJxHUSnSOdhrPGNrqdpmqbIbmqqpvnY=;
        b=hWcwWLeKUEaPSTCU8quUVRAxlQXIXEfz+6spilYV7km0akWOBOkw0tIWlwErya73/s
         rHIq6lOqjdrmS+r8GxIOCsYtdCdE6D5CnsdcsyN88CBcpMu4kzMiEEB9BBHhytIbSAiT
         pSmLcCp47zhoZRXD9uuKJzdvWeGTDAtl+TgpGCFhID87jKnCuqeAcdKTANiUIAbrWHMc
         Bqw1O+BYrQ+RcMEapMIkztqSP8wz4uTpt+DseJ8ay5BvOShe0pNNjqRyFEpVVH+thVmG
         FOlaACzKMP+dqr6MBUhj4Zed14Dl/fMlhbilACcsxdcgklV6Zex2tbCy875r/kgoWQ9l
         rIfg==
X-Gm-Message-State: AOJu0Yx9YPVfDhH5uA6FCVP4ai9+LwgaLI70kIR72YoQpK4OMS4oENHy
	GXl99I2H8N1JrDNuKLcCYfXI+QKeONq/o86cERqrXfWsXa2B0LmEr+eMwG0cvSdEMebKtkFlXYj
	xMuqpdWRdyDZvY+VF9bLaaNsgA9KDPcoD
X-Google-Smtp-Source: AGHT+IEurHMX13g214RDe7IkuS0N8evB05x+IlPCbD2vpHYogWcCg+eCLiolyBSmGFN5Dnk1eHF2KI5VbyqD7s7Wr60=
X-Received: by 2002:a17:902:e54e:b0:20c:9821:69b0 with SMTP id
 d9443c01a7336-210c68db63fmr223757595ad.1.1730815480213; Tue, 05 Nov 2024
 06:04:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
In-Reply-To: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Tue, 5 Nov 2024 15:04:29 +0100
Message-ID: <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Nov 2024 at 10:58, Haris Iqbal <haris.iqbal@ionos.com> wrote:
>
> Hi,
>
> I am running fio over a RDMA block device. The server side of this
> mapping is an md-raid0 device, created over 3 md-raid5 devices.
> The md-raid5 devices each are created over 8 block devices. Below is
> how the raid configuration looks (md400, md300, md301 and md302 are
> relevant for this discussion here).

Try disabling the bitmap as a quick "fix" and see if that helps.
