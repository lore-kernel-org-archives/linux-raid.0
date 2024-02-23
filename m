Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E50813B79A
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709931; cv=none; b=TFPYmic4pOrDYp9z0a0FUFBtyWOpJD/PvzefGCMwnbanFvJLGKw6RcGcl7QXFpJSHsLX338n2m9MIRtVPyFoYO94awFhq9hYi5A+WVDEE6PAAXdobr45/dmRm6UBGV4u2dGseDpH+F0cB+ER5RARK7PVN2TWw7XH+xnb4jw8jm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709931; c=relaxed/simple;
	bh=Z/tdiaswOuMsSTRlFl5mttaDTcPlAJAfMp9lCRul4/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0WrpRdYYaAznvD7YMvGpz49sXyi9Nn9Wst5kd5quqOPYN7uQJk96i3IyXXd0zvONX28OG1YzMhKpK5lhcmtvp0FXNevCQYasCrmK8V6v7krkEwhqg1FppVBJE5UQ18d4PIgCLeLj2ZI1mRzrLRkYX6wfKq1TXMW5McozAeN8aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-68fb71fc886so2229016d6.3
        for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 09:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708709928; x=1709314728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCNe9P9R3KM2Wz7dyxOARVXFpXUPwCv2nJ79gu715Oo=;
        b=EKNzpGhuWPzpRtl6feLKwAqUEPmLTmFCttrNFC8ByTxSdWGR4bVKHvEVmeB+K3YKQo
         9rCJ0qd3BH2McJ5XjY/Lec83wiDRyWd8hmxSw0OTZKgJRvevPb3MmEObi+5QvEp2fLUY
         j8wGVfw+EBacQJFyFDkobpIchaIJQC+umls36nSQ4QOhWAennwUvqkZdlH8IKV96sXhs
         bHxDVHdmabGt1iZ+XPdAQkjA82NLOSeQuIGCdvLHIiJ0gF1AwTaKSW6yX2GM73XwMsp7
         Chx8IU1EocJvEAj18Rfb5XHN87uBZsbZI6iJ6dC2YZhCcxXCKrcWMJmOvi6Td30+2UW0
         r5iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrGdoiOxze9sA1gj9f1tvBYe/HTFBVggThFX6tFOAvUlSRKiiGrcH5f761avNURpncJazmsRspNZT0syI3N/1uMc1A80XFy4AzPg==
X-Gm-Message-State: AOJu0Yw00e0TessmQDwtCZHhohRRanurrhZI1Db2DRBQglfFrQgcwvke
	+sgxvCe9nC4z4wp8Y/kFZLuVQTE3PJhsjPMPA0QfVShQ+jWtjpCQpiWu+11XEw==
X-Google-Smtp-Source: AGHT+IGF+Ro5/2nuXSC4XxQgxIIQm9FF6ynywuJ5yuC7Xd0v9EMLQoNBpeBIKcvB3nktkuYP8GeMBg==
X-Received: by 2002:a0c:b699:0:b0:68f:d215:2e16 with SMTP id u25-20020a0cb699000000b0068fd2152e16mr416761qvd.43.1708709928288;
        Fri, 23 Feb 2024 09:38:48 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ng9-20020a0562143bc900b0068f455083fbsm8119452qvb.63.2024.02.23.09.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 09:38:47 -0800 (PST)
Date: Fri, 23 Feb 2024 12:38:46 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <ZdjYJrKCLBF8Gw8D@redhat.com>
References: <20240223161247.3998821-1-hch@lst.de>
 <ZdjXsm9jwQlKpM87@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdjXsm9jwQlKpM87@redhat.com>

On Fri, Feb 23 2024 at 12:36P -0500,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Fri, Feb 23 2024 at 11:12P -0500,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Hi all,
> > 
> > this series adds new helpers for the atomic queue limit update
> > functionality and then switches dm and md over to it.  The dm switch is
> > pretty trivial as it was basically implementing the model by hand
> > already, md is a bit more work.
> > 
> > I've run the mdadm testsuite, and it has the same (rather large) number
> > of failures as the baseline.  I've still not managed to get the dm
> > testuite running unfortunately, but it survives xfstests which exercises
> > quite a few dm targets and blktests.
> 
> Which DM testsuite are you trying?  There is the old ruby-based
> "device-mapper-test-suite", and a newer one written in python which
> should hopefully be less hassle to setup and run, see:
> https://github.com/jthornber/dmtest-python

Also, you can use the lvm2 source code's testsuite to get really solid
DM test coverge (particularly for changes in this patchset which is
dealing with setting limits at device creation).

Mike
