Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCF01991A0
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717774979; cv=none; b=UmQWi792Rlcxu5hG3PMlEFKn5L6o/FhXD7/4rH2yhTjBy0Fedsg3SFrKZftbGGPS8/0kmGnMCYvm8rSAgSyczxqznsnruwgMPPBj6tLR5xyX3Vcd7QF0vHL/20FKDy2reaBEvMH4e5uqAwy7V0hjehfuoL5qFLRlNL1ZXJgVEr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717774979; c=relaxed/simple;
	bh=VLKCBiqDO1b7IDOT96XGtlch+dI1HdxS4qV5hpgYjzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E84kCM0UGQkM7Z+LrK5Cns9aNFkL169yZZuz3kt9VGWMCXrQ9xkTjkZVyiXbDnlH1gxf+8GmGcSNhXGzochgvV7wDYZuXyU8K8lBX80A5HRf+5NwYcNDSCyyecU5O+b3TIp7jw7CLSiifOKYPRhtGZZxBL8Vn+fE9Tgd08s1GBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-795413e26deso48932485a.3
        for <linux-raid@vger.kernel.org>; Fri, 07 Jun 2024 08:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717774976; x=1718379776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RasJ+NShJomVG3pgYjIfDAmcUiePNRF7Ig+7YHU5+mw=;
        b=YRpzH9NJv4V85vOeqDxf+cAtzGVMZ4eOMtxDzH/mEAzUJzBe/3yrYqmFpVO+v6Y9pV
         R7Z0G29Q0us4DKDxO0GaYYVVkl/rwOXEJ6g4/ezgBe+2p+4seXDP8joB9FWW6xqbYO9W
         E6bzjK6IzpAd+tXkfOPRuI9ZwoVsQgm8GdfXndWZFQaqUu4vnFnw3eDK27L6Edzjs0aj
         ZrYQ87GXQijrCi+/gheTSDbtZf4yFEI3YS9FNM1vXUNXFQXGGisE9YoX/rP94v9jsU6c
         kWtTWTVHvp6/CP3UwJl6oEDw+SFeTRextjhR6ZUusvyyOLFAg6S8XRSUNicTpEdBvKPE
         VJBA==
X-Forwarded-Encrypted: i=1; AJvYcCWum1XBsVACSEqOHbH4/JYMJbh7yOArjZLbcNmSeujGtzHnPK2nzm8qy5nXPDriwIwxHbWzVwchzGhNT7PKeiAzbPSb8nk4U/xEpA==
X-Gm-Message-State: AOJu0YxY8jz1txWU7hnlFYrSJOwuNBzphPK2SV+Q6CdclNV6RopVRuie
	DO4hDXlSSaObVWl9js3dXzNu1Mj0fP8Jz9TA4aR4uQiopiANEt88gauvAv7dgng=
X-Google-Smtp-Source: AGHT+IG83ZaoB4BbDgVdJbtiLnyWwBlppIWmQo0F3w7UfScT22lWYphwl0x6Lo1gXNyzaZaeoZjrHA==
X-Received: by 2002:a05:620a:99d:b0:795:3927:a801 with SMTP id af79cd13be357-7953c31ef03mr261564985a.31.1717774976345;
        Fri, 07 Jun 2024 08:42:56 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-44042fe10aasm6814211cf.15.2024.06.07.08.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 08:42:55 -0700 (PDT)
Date: Fri, 7 Jun 2024 11:42:54 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: move integrity settings to queue_limits v2
Message-ID: <ZmMqfj3T9Ft680j6@kernel.org>
References: <20240607055912.3586772-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607055912.3586772-1-hch@lst.de>

On Fri, Jun 07, 2024 at 07:58:54AM +0200, Christoph Hellwig wrote:
> Hi Jens, hi Martin,
> 
> this series converts the blk-integrity settings to sit in the queue
> limits and be updated through the atomic queue limits API.
> 
> I've mostly tested this with nvme, scsi is only covered by simple
> scsi_debug based tests.
> 
> For MD I found an pre-existing error handling bug when combining PI
> capable devices with not PI capable devices.  The fix was posted here
> (and is included in the git branch below):
> 
>    https://lore.kernel.org/linux-raid/20240604172607.3185916-1-hch@lst.de/
> 
> For dm-integrity my testing showed that even the baseline fails to create
> the luks-based dm-crypto with dm-integrity backing for the authentication
> data.  As the failure is non-fatal I've not addressed it here.

Setup is complicated. Did you test in terms of cryptsetup's testsuite?
Or something else?

Would really like to see these changes verified to work, with no
cryptsetup regressions, before they go in.
 
> Note that the support for native metadata in dm-crypt by Mikulas will
> need a rebase on top of this, but as it already requires another
> block layer patch and the changes in this series will simplify it a bit
> I hope that is ok.

Should be fine, Mikulas can you verify this series to pass
cryptsetup's testsuite before you rebase?

Thanks,
Mike
