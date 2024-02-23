Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A838713A86D
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709814; cv=none; b=sfFFp2FGOV+c3Y2D3A/IGhxXCSLjUZFwg6wcqUgdesKB6o9tZBtA+wPnHKoQ7liWwdyOuuXursSlBU/LwuWH/bvR1aUW+hBsvyJmvLjY8M04rM1QrV5vs1RMtkHt08nLFvoRqvEsQ3ktJRLR/gB6HiPJCIMqSrF2Wu333kAHKAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709814; c=relaxed/simple;
	bh=SEK03gUgsAHVyBKTF0SeCekKr9R3NEdzFcCnlWlT1bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byQPSSAm2s51DANU7Rx6zvWWRKElPw9UM2Q70C/ubbDaG7JyUC1zMLvjWDsvFtqy1hX8Ylk17abbXcaYD3ZNGzmCzgso0uT7sye/asQUC5HThxbo27g+zNAj6hJiCQ5Mz1fJBwNaTpMt2rU1I6NLcmVXJcL5Fo3T8NfX//5U3uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c18190000aso891111b6e.0
        for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 09:36:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708709812; x=1709314612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBgb3133dWWVi2hhB7h7NHIAti/ExYEzD/m6pD+d9CI=;
        b=DamyTo8LqYtAXkewiLgepS6LEaPyT5QC/1BSiQMm7mwBPozjDwpjbD9M9SeVzfWXXP
         9z+lyY3gkG5HWlJIcmfBTjjWsQciCx4wCBBM8e8CynAJlroVW5LtuGMLWi6OsjdkaBp8
         OIJIK/lGYuCGVs4YfK1YCYkFHu+VV+leSR9cjYn12tAmbcXjrX/z13t5cGgl6i2itRL7
         qlmC8XfxblZ9RyDrXQWCA4SNxZa6n5yEDcz1rRPFG9mUPyeQqV1gSSeCX6A1qPyACWzd
         QkYpSblS3rD1MclPzt08sKUScpCA4FFkEBMdfZA1muWHwVij2kbOyQGtFzPDMXzLRHO4
         iHZw==
X-Forwarded-Encrypted: i=1; AJvYcCUzIWy8AwJbmjqLx4LEKr+HrYP3Y0Dudx7RSXrfD5TOTeFzyu5MBZ818D9/REXQIVCmwQzpv3ahLt6xlWZVcFwNqAxzTcTuZw2WSg==
X-Gm-Message-State: AOJu0Yzcq2bt+eFYaPjM1BzLHVOXT8Sw4LqUUFD5kZ9QmRsG8kAnbyxg
	1XYskyCnAKP2+ww/4jbnhL3nQy1YrPI+ThX1zYPyuA44lmxwfccNshoT+ynnlQ==
X-Google-Smtp-Source: AGHT+IGbYpIhPAaa+76bZP9NfoGjlH58apihqp1Jeh57mXakscWDl1A1EkXzjkZJgYEtNoSB+kRJHw==
X-Received: by 2002:a05:6808:15a0:b0:3c1:4b06:7ac2 with SMTP id t32-20020a05680815a000b003c14b067ac2mr637798oiw.12.1708709811740;
        Fri, 23 Feb 2024 09:36:51 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id qj9-20020a056214320900b0068f914ac80bsm4751610qvb.50.2024.02.23.09.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 09:36:51 -0800 (PST)
Date: Fri, 23 Feb 2024 12:36:50 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <ZdjXsm9jwQlKpM87@redhat.com>
References: <20240223161247.3998821-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223161247.3998821-1-hch@lst.de>

On Fri, Feb 23 2024 at 11:12P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Hi all,
> 
> this series adds new helpers for the atomic queue limit update
> functionality and then switches dm and md over to it.  The dm switch is
> pretty trivial as it was basically implementing the model by hand
> already, md is a bit more work.
> 
> I've run the mdadm testsuite, and it has the same (rather large) number
> of failures as the baseline.  I've still not managed to get the dm
> testuite running unfortunately, but it survives xfstests which exercises
> quite a few dm targets and blktests.

Which DM testsuite are you trying?  There is the old ruby-based
"device-mapper-test-suite", and a newer one written in python which
should hopefully be less hassle to setup and run, see:
https://github.com/jthornber/dmtest-python

Mike
