Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DF129CE5
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 23:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718235989; cv=none; b=VsGpIzq+uDueDsRUqWAMLTd+uhHNNS6D+Ef09Pv5Clb0KIpwY54fLumJyo04kvVStarFwfU2CLb9+eMUJILFF/v/wCyqb2Z6nDssh4hlWK1/O8GdvEz65mYWdll3/eKIavqyQFIumnz/MPactA3XP7pe/E9AKuyoZYUU76RF2RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718235989; c=relaxed/simple;
	bh=+5PkRpBUYXGWWS+5ZFNQ3zra4VnFReXDlbIumyQCW9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HDAftoCQZfc/aCSwxpTyjyDRKo/sH3Z5u3tdvr7db7+6nf6bZlaIPCki+fhpXS9Zcr4NtfpaCB25qOxLtXBxaFoURJAErV2JBfBc74y2OigjhZME5xwacPC0PcxHJjrQZBxNcDqx8QhqJ5+YlnC8oKM59tGW0Cch3ZyVw8fC9vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=e6GDh4YY; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="e6GDh4YY"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2c2f6b47621so299732a91.1
        for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 16:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1718235987; x=1718840787; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+5PkRpBUYXGWWS+5ZFNQ3zra4VnFReXDlbIumyQCW9U=;
        b=e6GDh4YYokGOAelXWvJ2FiSPFZM9lWDOFLOER6I8qCYLDXwQMvlENnzQWelZMM0EJg
         Lm6AMs06ZcpLROmgpbz/SsTav853ZpqxxF2Kjzilb0sz/aD5xua4gQGIs1vpooYzXz1c
         dKVyI/X2Xb9EvGqIupsz+pHqlqwmkPMZHAC1/qffh2e/MIa2GBOAoKzm9sjWeXLbZDMz
         yiZH39uDSUVNELiwIegZkydq+MGeIbtDepPfYR1OjpMpKBxL0Wab2w6vT1W91mVCyhZb
         ewkX2zcjMTB5d4+gImyoYf7MlQoHBz7Dp1j5ezKdBPoraollc5ic8CsZj4ssMMBq9/Lj
         1eJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718235987; x=1718840787;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+5PkRpBUYXGWWS+5ZFNQ3zra4VnFReXDlbIumyQCW9U=;
        b=Uzy54PiV6ih6HmVMHLXH3CsIy6dI8OEUrPFt+6wtgaKMrmlBy1Fw/6z/DwJiFKt5Ug
         xESsHly+8/LPU17q0KVAN2ZtIVdBW9eifxQ5bUceVR8/QrE/8oG6ICx5HeBSfaT61Az0
         HarPuTlIIXd1GYMeAOms11O/DXLQC9bY7iRsha7Bg8J+KAEYM2OMOEuhFYaKhFiCECRX
         h9DPZ+v50RtloFh+ZVc6J7HmAR8JsXehkoEH/Gn+pOWeV/5Ws9oP/nOOWD8orvNBMA+y
         OywTHgUcCzx3HYzX3q9HAj2Nqi4Vr+oye20kGNMXaKzrNLr22AIVbaZjUTX7IISAiGgy
         Aiuw==
X-Forwarded-Encrypted: i=1; AJvYcCXAgqyAS+lsRIJW+ZM8YINUWttW2mNJwG5Vj2oh6d6LolesUSXrmk4TFun+n3N+TjPKh4NZ21LFTpR3WN+5+PmKZDUUPeEb0kVfAw==
X-Gm-Message-State: AOJu0Yzn8hejTTFKmLwZNLgos5YwE9qZsnbP8TNMDmz6xZObKngCFmRa
	tvAaEHmLgswe6BMqCyvnq/DuZIVVA/b6wMN6IERm1l+x/FZ/uNfV1stgL4p8Da4Tqr1tq5wDTIo
	abazLuWB+TEM0RCobPMACg+wxGzclOm7ySV8=
X-Google-Smtp-Source: AGHT+IEk6noDyWtNX16D9/JZOs3LzxpnkaqXmsFf4HarUdK1K1uKEGl0XYoYbS4IQH71SLgVe/ZnQje1hHNfAXCav3M=
X-Received: by 2002:a17:90a:2e8b:b0:2c2:d171:3e7e with SMTP id
 98e67ed59e1d1-2c4bd8bc944mr1565889a91.13.1718235987255; Wed, 12 Jun 2024
 16:46:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZmiYHFiqK33Y-_91@lazy.lzy> <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
 <ZmnZYgerX5g8S9Cp@lazy.lzy> <8eea69b5-4abb-46b6-8c7b-05c7ea0bf591@thelounge.net>
In-Reply-To: <8eea69b5-4abb-46b6-8c7b-05c7ea0bf591@thelounge.net>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Thu, 13 Jun 2024 01:46:15 +0200
Message-ID: <CALtW_ai69FCuHCMRDMzTxiEb6Yg22yd9vr+2d5_Ya1GSPbacRA@mail.gmail.com>
Subject: Re: RAID-10 near vs. RAID-1
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> stripes are "half of the file on disk 1, the other half on disk 2"
> that's not possible with only 2 drives
>

https://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
