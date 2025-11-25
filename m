Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0487030749B
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764083981; cv=none; b=Ddk1O4F1ALwoO185+gXzuxL5PFE9kksuGagegt8nS5Nd28AKmtXrm91TMG/IRfFdUnh0FMeLhrRkeogMuXSFs4/hOz82Tg1yAufwY/aYQVXbxWYBP9PfaMEqeW6h5QWdma68hip6UlihSNk66ib4BmpDnjhr+r6OjjEeBbJNTdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764083981; c=relaxed/simple;
	bh=cHJEDtarRWqOgXb1HtWmmk9rFMCN6Rpm5GLL00oUUdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/Bz4OEnyI3n34tyClw14ePuzwsy17JcYH8qYRf0Os81jy5JG5RIUHA0Ef/iNv4OjhfgTqd5JosqhSegWiImMpKK2/fRhbu+3x1U1Hk4pa81fBjl0S+mNdle/CuS4e6rgjAR2zZYYtmPYt94vCqn+jDbKOLHa7C3T6cOX5XpT9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=CG029mWc; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="CG029mWc"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b983fbc731bso630180a12.2
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 07:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1764083979; x=1764688779; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cHJEDtarRWqOgXb1HtWmmk9rFMCN6Rpm5GLL00oUUdk=;
        b=CG029mWcdQOCuqyMg+0/IOhExYnlqzMgb70IUYNFlIhY4e0Ees6A/JoTUnBPtsjx+5
         NlY/jVTfklqdeZAwovhqvbz90q/Ro9vWiqRgpnbIqkqhRss3EmDVn10w2Vw/YQojhF8R
         NGo5c8PF7FT/3f7MNIT9lhFnsijMba6aLQw/CMmwPKQPBxwhrZjwkF2wQ9rMVWDo3ZDw
         dia/2FNSHQQLfuuwYBWlX3EM3JN4uc6PbtO8h8TIiOOvPFX6bX/2CGqXvhqcTj1rhE8F
         fIFAv4SwTCh0l4gyDK7IaLwvr0we4uiTUco/bTuNePnoNvqa8cX/UysbdlqVMLOAb36b
         NjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764083979; x=1764688779;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHJEDtarRWqOgXb1HtWmmk9rFMCN6Rpm5GLL00oUUdk=;
        b=JLbCLrFDTwjLc+6IRwp7os1ANB++EQnc0J2TMRu+862VAVMMt5RkocHbq4nPtRDSa3
         MEiujYw7zNn5vr4Oz37/S8o/qxrcQfXzKD/JSGGwdGRM4PSoQuQWoMOFJMsmwbfaT9OL
         HxSgs1rkK9i4JyFW06X0XJw5Zwl2tzF0KjTuNis88s4y+RaxO/fXtAqSrIb3FOoga/Yb
         /pGvSeCpxGJVmjEMPhd7KniQKmVS/eo5il81Hs4Ij6/ovHWwF6T/wwj/yvRzGXqxBzkZ
         hZHUdLKcbrCjr96W5nSw1wq4X2GqvLuGpJUhC/Y/2LOXyxviCW1J0RWwZ57ppZ3UvR+u
         c9DA==
X-Forwarded-Encrypted: i=1; AJvYcCUbNIW9WdTz2sY5mZZ+mUDzwgnxak7Bhcx/EnSCXYTa+B6gBurtaaBfcFbGyD1+GyEClo3d+rkjODEP@vger.kernel.org
X-Gm-Message-State: AOJu0YwZ0KSiKAA2ZIsHwjsm0x/4Icd/OToWwLpmgq7GUpXOXpuvJXY5
	g4stkaxFM0KSSjcYYcqw8XFTtSaveK9h8yGRx43G0PmncNQVQx/Wsc3rt8IHFu5VVFgNcQYpHAW
	4z6Xr53LDsuoxcV7UYk8JJ4W442rrEXM=
X-Gm-Gg: ASbGncuzQRLpPbdOCZpyr2yp65Q25nCWyWY6gXGK0xjYiAtFuZ2A/TLdwFp4obRRHDe
	esdMLubxdG///UqPAw8TRUP1UTrOGzGekOeHsJRga9wgxB90lWiv1sY13QKjCKUbDL/z31JM0Hv
	fGtMA2wXnjx+TMjTCI6iEcHWouQf91AXqeN288jiDXxpPsQPRFq0KV2nvp3Xk5q/XTmiuMCP5xK
	ImGDGhnYAjknMDhHkAkSplxS80NdlODWWA0AzaINyFBoKzx4cphPO7cSQ==
X-Google-Smtp-Source: AGHT+IEsGpw71TAYt5Qx+xiPZwRdX9y2YPf86ws3cbvh1p1Ksz8fXR2cFJ6hSGISWXJbuAla2LVthHyeUTZN4xWYVZg=
X-Received: by 2002:a05:7301:1906:b0:2a4:3593:5fc9 with SMTP id
 5a478bee46e88-2a7192a30bfmr9837552eec.3.1764083979074; Tue, 25 Nov 2025
 07:19:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
In-Reply-To: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Tue, 25 Nov 2025 16:19:27 +0100
X-Gm-Features: AWmQ_blcIVy5rRWTRzo2Xktts9TtQNTMQP5scAFdkld9uoxXMZx9jf6i_05fv_c
Message-ID: <CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Issue/Summary:
> 1. Usually once a month, a random WD Red SN700 4TB NVME drive will
> drop out of a NAS array, after power cycling the device, it rebuilds
> successfully.
>

Seen the same, although far less frequent, with Samsung SSD 980 PRO on
a Dell PowerEdge R7525.
It's the nature of consumer grade drives, I guess.
