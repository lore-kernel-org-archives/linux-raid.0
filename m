Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F332D20D517;
	Thu, 24 Apr 2025 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745487177; cv=none; b=f3jkE7dLOaZN9ePWoKa++OikKbnKiXkUlFQEGVrBhuqG0BJRVc9QOdPsR9AZcYTDxundRPQBQF1pHcHQp93OzyxnqoSFeXj6uSnK67ZN+6KrNmvBvfpz9jMqBhASu5VKGpixoWH0IfMvixbNw5LfVpOZENqDq1QU0XJ7mH5/to8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745487177; c=relaxed/simple;
	bh=QDMufKRDOVpVG9Zh1oBN2ZmPI1qB75GqTKDEzLNnjNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SNaoAc01CNXnpdXFALkbrME+2H8G6MbuIOQWHquv1Oa2z/Ahx4hhTiHa1QvkmAk9eMIC1ih0K4BEKWNn1ufljCeQn3vimNrhozFWyOq2iTdb6QE5KI5L7RkNuh6LvL+TinAJRE0DxK7g5mhOHSXTYQvV7RQpsvalB17B6Fp5U4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KL9Vgs19; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KL9Vgs19"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abec8b750ebso154538966b.0;
        Thu, 24 Apr 2025 02:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745487174; x=1746091974; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGhIVtJVw+xSzGO4DuHFiJed+7La+q9kJjJ9IcJqqW0=;
        b=KL9Vgs19Tmznolm+huYQjZGQVO26OWbsEsLcjgRZZPBPJUq3XyZVzTBqXY478WWaYt
         GTO7c1Fxex70xWQck5EDxSukAb+r8rvQHS/RLZPa2gZhNYVSs9CsgA/bnk075F1r+K/L
         +L65R8X5TL3sBvyRu23yx9bXC4CKfZX1HvcvVAkn/LhiQ96cckGUhM6KRn+LatYhHFgH
         r/QjABZS1bHr/Y0NVyDJG6D4MhPGO1PmkfhnZSLNklATu118T5Ecei9J2krJH2pyb5mu
         W8Q3m2lXSTnx07UNPQGRd4kUmh2Wpc0YzgmFWP+bAlixC3T6nEVMz5Ig1TU1vU3pm/5D
         8yag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745487174; x=1746091974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGhIVtJVw+xSzGO4DuHFiJed+7La+q9kJjJ9IcJqqW0=;
        b=FDVUP4avUFYIJypQ4bQAkkmyLMVm5ryFBa1Xcjbl6e9ZPkt0lrCO56jHAwFWtn7QOb
         Uj+StqSLd3VqSHrI4HMU1JUfMn3717ZoBYUHhw0majdPAa4IElWfdcxZDjBuxpEXnKWf
         QE0xCa2V9jddWQFMeJ/yCZY9SxbaLl51oOvHUMt9t3mhLCjurTInYwrbTIzIQCdaznTN
         5DGlGLslk3YVrbyaKlYUnJGFaBon8McFOlpHHIRBw4hUS6JV7Xlc6zaSSs3ezls8v+fV
         wDgPB/Sj3kxPfG4/WdJTNNF1wShQwh49B4n8o9xnHTXaT4AiqDIbC0asSBjdQh58p+i4
         usaw==
X-Forwarded-Encrypted: i=1; AJvYcCUuV5d319bijpgA1ETOq+TKwg+fn33Mf0Btw+oZDX3V8uuzpYb/lkN3OTqz+isM5dudSHfJE12l@vger.kernel.org, AJvYcCV0AGozqfiTn4O+GzHz7xbZTjxoqzPmQ7U83YDybQEExFn2Gi9/gPyCr9e1usGr8L1Ql7QfE5fL57MlgQ==@vger.kernel.org, AJvYcCVLUZ4fjb6otyDFFkjuVexjWlartoBM8GoPaP65pRidqv5NMLITGqKhrSmfj+2NgoLYQs1LAWhtOr3sO7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZZbUhJJLEcTnHKg4AjnBory979ElLOmi5BcYGcyFFXwiu9uul
	JcimWX6WW39vkkky7FQCqCTiSXmvMHO/gOsFa530kFbGZedTNPiP
X-Gm-Gg: ASbGncs0uXX2gH2u0zz+MJsxahgpB0exSW53geSXnvrjo9sFzvVs9YF3ru310g/IQAy
	DGrMAoC6NUmkoMVd3gxCh4fAjSlMW3iSv/IkIvt12gqdBsSOT2AmYAj3wHIKTjYLkcKlEyznsRk
	DsfK7wV+ZgwPXNdcPVOzge6k7qBvCMEL2et7kqQGP8/LtLe6imVi9GgOnw0p8ojMTN58PCx3E1J
	YM+ATbPPNEyrb5Uqsypl3BJDtAhsXxooCSrRV7/L088Eq/qum7ODfr6OiFKJjj30hDYd+O/USO0
	IdWzY1H+VzawARLTMQyY42uK7FewARSBVhTqIbrCZTu3THBAKSieG8KUnFcYTCI4+dc8hVPArA=
	=
X-Google-Smtp-Source: AGHT+IHRVfCv/5qSqPq6nRipxmD8ISPVwxiLwWlw2YJtHLydGP/7Jh+mD2ZME4hA4LfJmiwsYr5F/A==
X-Received: by 2002:a17:907:9714:b0:ac8:1cf7:7aa7 with SMTP id a640c23a62f3a-ace572362f5mr210001266b.15.1745487173897;
        Thu, 24 Apr 2025 02:32:53 -0700 (PDT)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace5989828csm79032166b.53.2025.04.24.02.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 02:32:53 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 72DE2BE2DE0; Thu, 24 Apr 2025 11:32:52 +0200 (CEST)
Date: Thu, 24 Apr 2025 11:32:52 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, sashal@kernel.org,
	stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yukuai3@huawei.com,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 6.1 0/2] md: fix mddev uaf while iterating all_mddevs list
Message-ID: <aAoFRJ_RIq6pdyn9@eldamar.lan>
References: <20250419012303.85554-1-yukuai1@huaweicloud.com>
 <aAkt8WLN1Gb9snv-@eldamar.lan>
 <2025042418-come-vacant-ec55@gregkh>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025042418-come-vacant-ec55@gregkh>

Hi Greg,

On Thu, Apr 24, 2025 at 08:40:41AM +0200, Greg KH wrote:
> On Wed, Apr 23, 2025 at 08:14:09PM +0200, Salvatore Bonaccorso wrote:
> > Hi Greg, Sasha, Yu,
> > 
> > On Sat, Apr 19, 2025 at 09:23:01AM +0800, Yu Kuai wrote:
> > > From: Yu Kuai <yukuai3@huawei.com>
> > > 
> > > Hi, Greg
> > > 
> > > This is the manual adaptation version for 6.1, for 6.6/6.12 commit
> > > 8542870237c3 ("md: fix mddev uaf while iterating all_mddevs list") can
> > > be applied cleanly, can you queue them as well?
> > > 
> > > Thanks!
> > > 
> > > Yu Kuai (2):
> > >   md: factor out a helper from mddev_put()
> > >   md: fix mddev uaf while iterating all_mddevs list
> > > 
> > >  drivers/md/md.c | 50 +++++++++++++++++++++++++++++--------------------
> > >  1 file changed, 30 insertions(+), 20 deletions(-)
> > 
> > I noticed that the change 8542870237c3 was queued for 6.6.y and 6.12.y
> > and is in the review now, but wonder should we do something more with
> > 6.1.y as this requires this series/manual adaption?
> > 
> > Or will it make for the next round of stable updates in 6.1.y? 
> > 
> > (or did it just felt through the cracks and it is actually fine that I
> > ping the thread on this question).
> 
> This fell through the cracks and yes, it is great that you pinged it.
> I'll queue it up for the next release, thanks!

Thank you! Very much appreciated! (People installing Debian will be
happy as it affects kernel under certiain circumstances, cf.
https://bugs.debian.org/1086175, https://bugs.debian.org/1089158, but
was longstanding already).

Thank you,
Regards,
Salvatore
