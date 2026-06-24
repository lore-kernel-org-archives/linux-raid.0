Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7609638E8A6
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782288469; cv=none; b=JxmTiyFLwKYCiFYs9OaGH4T6TeU3xhFKeQ7WPqLUQC+csCoHc3r0LLU+dBf8vH9hRuW3dWXPADgXYDpJlUw0DoC98HOTsiZuk6rdrcRRcHnJgaabkfSzELe3ypaVHOVF/p5eSh9gEFCVw97Iko2IM+zxFZFdJePLwf5cr/h+Zqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782288469; c=relaxed/simple;
	bh=H/uiRK4DFgVrmzx9/oy4BmqlpiOITf+qW/INtAGh284=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p62Xn40lXb2JitZ/mjPvPj/rSzVniS6EzOx4lebhDVuayisVA6ySXCvpFd5MwhyNiGx39vfzLxN5A+MUBmpFqgUnozK+1BUjoWL4uqTIEnlKEVHu8dQZd0csqw04n6aKJtkXiaR4jp3wfWls9r3b+PLdUE6YK2Ly/ndzzpYfGaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OlC148gw; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OlC148gw"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69690062350so825525a12.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 01:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782288467; x=1782893267; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WTmHFwXKHWJsH9a/uyEYwOmNv8DNfdZVtbBq17LT/RE=;
        b=OlC148gwM5RyD/m1tUbU1+50xfQdfJvDWUZ5N3lmpAEg0kKUjYPKrb0hsUMI1NLE04
         /k6Yok1fjHaCYcr9WUq39798ArFF8EDlHrqYeVb0it27hooyuYRHM4dgPEr1ATgETm/4
         H4C+he/5e6KmM1D6BmMOihnzDCRzFPoLhhyIloXxWF9Y0iEBV8XLaWlpgtJvKn0C9mzi
         gKhDPzV2svB6wCtVrQEs7jnqCnfAxcprlivR5bfaNJzE9MWwbgORqzcFewIV+C4PmH0v
         S+ST87vmD4souY36UKGFSJVuPVZuRHOitRWuBjycvydIrJE3uci9ijhSzpO2eW0hyttX
         S9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782288467; x=1782893267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTmHFwXKHWJsH9a/uyEYwOmNv8DNfdZVtbBq17LT/RE=;
        b=B+nh82NsYNz9A0rrbH9+hWcFM4R/hE4ZG5pBNKSwrl9dOo5Noo2EjWYAIbdczaX4iP
         7PjEVcHiBaADYVNeXbFp/ZHF1MDJC4v7GeGHH3B0czO/YWb4i+XuVa2MyfKUywAeecIr
         +upir5RiqE1XwhfJmrff5n4JS9NkuLAcMGP+XhiGi42wAGb5FL/qqq/Ppam7M5xBlfw9
         EY7nTEVfX5bq5g99IRfwNIQ9/w9FASKrPW/evxMGtlsLPocsQidGNp5bboSD8hnohAxZ
         8Kol+OU4HikOQsY2T1E386tm1pSJBpMSoqLH0aqSmqduMpsSP5PGh0pVR36eK+mVVeuL
         yIPA==
X-Forwarded-Encrypted: i=1; AHgh+Rrr5OonCCgcF/GgeeiVNzUPZ6qtRRnzXzfBByu5QcLWj7bHknQ98K6XTGUMVuE3G4ZgiRHRq/ThqUQV@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ9vTwBfrsYSlM+flwtip881U3nnSu0shxeik1arHzafx8OUvE
	5zQV9IWMO46xRvMviqDiuhRvndpe3gZHoZjClJQGd2jkkHytGpxD9u5x
X-Gm-Gg: AfdE7cnbLUS6VBqLqXY1HBLOkP0n5u7MrTUyBH3ir8lpNUXi26/jiwBL/AoplGfgTDb
	uDICQk+YwhdYjs9uxswk0ZgSEbbPuhY/uTCXL583j0NZDhUIcbNWfJtM6wEUKC5nK5t/XrAOlb+
	SHBR87bRKTAYfWL7ifGTuRpvPUjH+h/P2VmXCbvR5Clej8RXliZg1Wm7Op+yGxzsg6Pe2h5UbXb
	bAYLLzuFni5DWCFlPm4EawjnX4SahV6NLrVjV6tjnoF8kDK1vRQDCHlXzy9cRFcRq7wD0IuxlxO
	9P9thGxdaOMiBpI95sJND/iQoDaEE00YWeNbSgmbsB9lA3dxb2fW0Iz2kbYmjQToxmqfiBjy8vR
	EriZVxOeyyFW+jofUh0LZNDrFYJd5fPMfH31PCvRpTWK17qOqidcEd791USocLDS0IjMe2QbeT5
	tQSoXjWEZA
X-Received: by 2002:a05:6402:1e8e:b0:697:f686:80c7 with SMTP id 4fb4d7f45d1cf-697f68683cbmr783796a12.26.1782288466773;
        Wed, 24 Jun 2026 01:07:46 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-697f49d73fdsm652987a12.22.2026.06.24.01.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 01:07:46 -0700 (PDT)
Date: Wed, 24 Jun 2026 11:07:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: Brigham Campbell <me@brighamcampbell.com>
Cc: Sajal Gupta <sajal2005gupta@gmail.com>, linux-raid@vger.kernel.org,
	song@kernel.org, yukuai3@huawei.com, tomasz.majchrzak@intel.com,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH v2] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Message-ID: <ajuQTrWQpQzgI_OV@stanley.mountain>
References: <20260622142146.56637-1-sajal2005gupta@gmail.com>
 <DJH0687PNY2P.1WOW0ATJ2KZA9@brighamcampbell.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJH0687PNY2P.1WOW0ATJ2KZA9@brighamcampbell.com>

On Tue, Jun 23, 2026 at 10:42:47PM -0600, Brigham Campbell wrote:
> On Mon Jun 22, 2026 at 8:06 AM MDT, Sajal Gupta wrote:
> > Compile tested only.
> 
> It looks like you're on the right track, but this could use some
> testing. My analysis here may be incorrect, but it looks like it should
> be pretty easy to test this patch by compiling and running on a system
> with a RAID5 array, PPL enabled, and no RAID journal. I expect the call
> stack would look something like the following (feel free to correct me,
> anyone...):

Heh...  That doesn't sound easy at all.  (0_0)

I just left this one because it's not really a big deal.  It probably
isn't even a real bug.  We call increment the refcount in a loop and
then decrement it in another loop.  It's not the right way.  Sajal's
first approach is the right direction this should go but *that* patch
would require testing.

Adding a break here doesn't require testing because it can't possibly
break anything which is not already broken.

regards,
dan carpenter
