Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795AA79CC
	for <linux-raid@vger.kernel.org>; Thu, 11 Jul 2024 00:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720656876; cv=none; b=YiyXBTDELuh2cIzBpoe1qYKidmVRXfXbgULAHHjWvGFWZvhfgzR9fIQMP6NUhu5Ld1rkFS0QtrKrv003AEGkTBuF+0ggIiz2Zf4wS+RMVOCgbGngrfYVyzDSK4WadRW+j0NGL9Cc3eva0Ys1NAdRmfym2Ijx8UViRqh0fx0C2iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720656876; c=relaxed/simple;
	bh=ugNvDOJuPmCbk1+Osy7vVE4kaG3/BCG4LFN1LNtHcS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vj2Zfzh9Qzn5vefLTaHcJGGoczGb1gvyxUZ1DaF1vQQ13VMzVvKy4dbh0xwdMwuvb4RBAReDlQmbOVbz2HvPrAoiV9Onarg3GUi/zkPaVMIcA6qgylWJTJmRvTaRxAA0gPwnX1Gryfe/3KLbyY00stxFFT5LVp/0vhb9p3Cx8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P+AQBUBK; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P+AQBUBK"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ee920b0781so2764151fa.1
        for <linux-raid@vger.kernel.org>; Wed, 10 Jul 2024 17:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720656872; x=1721261672; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yNg/K2icvH8fTjCFB43gV72tqVO86dOwjDvTifJA75Q=;
        b=P+AQBUBKctiVB2u9+nFtIt2HD2cjfJY65LuZtUn+8dkoLfB6pwg2O9Ex8WhxB2pmsd
         CPbPdeRU3PuIP01AvnsEedp1qHdh1AOi/OhpF/LGwCRDFtJEuuqbzPSmYHFcVI9bFVDX
         CjvRmwGBH7w1dFjfkQsiFJQlXNPZwE/zYKdFFmW6v/Y0P5I9ujKP+qUR9yjGmSU904zE
         08QxUXWTER0jMsD0DEA8PT9/iU5+JIgnwBvoLSkafZwD5nqddhecltBoR354GZ8kJ7r3
         3mbyTciJLtoAIeHrUz9UOr0NJN+51ATA1rD1bX1gnMzXvPeKTuF7HB9lw7kDAHJeYXCW
         L+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720656872; x=1721261672;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yNg/K2icvH8fTjCFB43gV72tqVO86dOwjDvTifJA75Q=;
        b=C2SgEga6tC8ama+Aj+2n7CB8nxchWKOIgUBxN7amRjt5LxTKoyt9FycXUQh+2ZaTg1
         SMqyBjU11QDoma/mxRMnl05FgMvzsQo3WbSElEqROtZcy/mraGn7uUOPG7Meas4cyyf/
         51eE3zkfwX8V7v2e3jglWXctfmf0WCySyt4UZfVd8nXf9caMVY9nlhsfBc1mcIhQwnop
         U2DnBbuc3nUe9fniIoerLaWoeZWww7mgWTu4dRV83z6rTGDY8MvN26+FK3QGREAYIQDb
         3+lzqveRswEFzj7PRHj+fWSzj8z++L3uSfoOATZ8wNPQcw0cSQcEcQ8+K6c2BW1W18LL
         hVFw==
X-Forwarded-Encrypted: i=1; AJvYcCVXZq3tl4FMtjSI4RmgNcwJFiD1yvdoJHmPJwEeaKf+Cy5AhFlzS5wqv4f/u+Paos/UbJEHOGpzl0iqW/AVTDXUfotBeSJZ/GTyyw==
X-Gm-Message-State: AOJu0YyAcQ2SD0D4hltvrGI3Ut8bmjKOV5JgoqVKoMgIiuRUUh4q9Pjy
	FnFlv6ixf4p0VTjygr7UkQC62d9d47PjLg+D1bwHby9xB45gXiJnsh+rW+SC3PpWDtc8F+6fwqu
	LWBIEMw==
X-Google-Smtp-Source: AGHT+IFiSxbDj2ZZCkh2bjHrJQsZtL6K25YRzf0FYGyIWNfu5mRVZbHRqQaZ/PqQokDygsb4Azjf4w==
X-Received: by 2002:a2e:8686:0:b0:2ee:893e:4ef9 with SMTP id 38308e7fff4ca-2eeb3190d69mr39787441fa.47.1720656872476;
        Wed, 10 Jul 2024 17:14:32 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a0fbf0sm39084645ad.21.2024.07.10.17.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jul 2024 17:14:31 -0700 (PDT)
Message-ID: <b4e76581-fff8-471d-83df-fa530cbc49b7@suse.com>
Date: Thu, 11 Jul 2024 08:14:27 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mdadm/clustermd_tests: add some APIs in func.sh to
 support running the tests without errors
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org, xni@redhat.com
References: <20240709120452.25398-1-heming.zhao@suse.com>
 <20240710161000.000018f5@linux.intel.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240710161000.000018f5@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/10/24 22:10, Mariusz Tkaczyk wrote:
> On Tue,  9 Jul 2024 20:04:51 +0800
> Heming Zhao <heming.zhao@suse.com> wrote:
> 
>> clustermd_tests/func.sh lacks some APIs to run, this patch makes
>> clustermd_tests runnable from the test suite.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
> Applied both but please use cover-letter next time.
> 
> Thanks,
> Mariusz

Got it.

Thanks,
Heming
