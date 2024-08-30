Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409613C3D5
	for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 11:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725017486; cv=none; b=YNQvzh+MsxmNSH4LGD0UUa9WOBdN1Kq0uc9h1oJckHiju7V5NewDhS9qf44sv8LKQskd2w6gSWYwZMXfR0ycLgwaQmLc41iesVaFIQh1OUsFeVZBKRJ8qpg98cGM8nq3pwcxj9iRgdZL+3X6TMp+AU69b9YAC09B7l4Q834IGTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725017486; c=relaxed/simple;
	bh=lNItZKI/zeGregKkCBlucA4/+L3ax7NRii/HfaRRwX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdJS83N1pKDTZCELXRSx47soBSXUnUJc4/TcOxeE8xs3x6p3Z1s8Io0pwnj2qw3BaP/mQvUnR/T0swjLTtNzd2VnNXjltzfKSII970L+bXspvJR3Fkvj8tdiAn+nrSlVEFft0wpLIWfk9X3rvm+ZdZ1T4U/uRxebRpE5A6WfKB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O5z0C1H7; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O5z0C1H7"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-371941bbfb0so1024483f8f.0
        for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 04:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725017483; x=1725622283; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2GvO8k4+n+cL0s8zcxKvXKY7jMfYBe3D7bGlijy6H5Q=;
        b=O5z0C1H7/i0MQ2mc40x8AQYYZMrHlH413SjB/qawMRD02M8S+pJUYUtDqJAjwUGVQV
         zpWnOQaInHm8EJ3kTVDdIkTX4+Tz6G8xu3Lj6D9rqlwD4ybyvh5+65B9Dsoc2RmCSmk/
         /p5rWCJvb2g41Z4RF4e1y10gWCS0WJe9RJOIof8YiWoUTbjJi9CWpn95ESBZihiqCNOg
         3iPBCR4ht4vHJXLlQBldhJOeohdMdNq2Vu50NqlAhirom83y141yBQX/HB7F768drTXQ
         b8AzlOt79H/toTktA1w9w0oR3Ot2lbyjRfG8+SjItNf8alz83lCMK1Pv2ug182SMmaBs
         6sJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725017483; x=1725622283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GvO8k4+n+cL0s8zcxKvXKY7jMfYBe3D7bGlijy6H5Q=;
        b=tPQVdwvoZ8mVJTzgrJDsw7qy6NMoyudzUK4+ZOsOX5vW2vu37KwCT9fQVPmEMYtUpq
         /TVgWKfyNGYmad2IK0GUPs152j/Zxy/E2HHSmvA0drCpvq8fjqPAGpUCOaY69oFJ6mUA
         5yLtjwaGO8tJoKPz7ij43GHpSAeq6aaTh/6uEPX+3ZtQy1qu8ffh+6n+C9y6PcNCi6V/
         bMQrz4scfUwgILsAzsvx+wEUWzzB07eloB1edHC/2/Gf6apmvta9FTPKfcwAw6DZlQgL
         NDaDAGxREYgdr8hWDytTFV8eOv/s7tTmapzJQE3JlYr5y0XIt9KQIaP8BfudQQOyS0eP
         5D3A==
X-Forwarded-Encrypted: i=1; AJvYcCW/I5+jkcJGDo4BIVMY1mOJ0cIzrtEMRAaMEHiZ4ztGmAvnetADsmrZx8/3wWB9VUH9uKb79tgd08Fn@vger.kernel.org
X-Gm-Message-State: AOJu0YxyYS90KsDRwYs1xetm8nxAKQCPHxUNkeoxsh9Biu77wDv2VsyB
	QfN5vG5gfz6gIz10PPZjXY/0lSewLpxCdnI7sZfeBGhwqx5HdTx56hJAbDze26M=
X-Google-Smtp-Source: AGHT+IEHcTx6s6ZCYzaUr324OCbDcX6kfN1Z1CjdW/1CU42SuDvxvPzn6Bbu8/rlY+qzkqdTtoW9PA==
X-Received: by 2002:a05:6000:4388:b0:374:b9d0:f2c3 with SMTP id ffacd0b85a97d-374b9d0f45dmr219127f8f.17.1725017483248;
        Fri, 30 Aug 2024 04:31:23 -0700 (PDT)
Received: from localhost (109-81-82-19.rct.o2.cz. [109.81.82.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4981asm3768156f8f.24.2024.08.30.04.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 04:31:22 -0700 (PDT)
Date: Fri, 30 Aug 2024 13:31:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs: drop GFP_NOFAIL mode from alloc_page_buffers
Message-ID: <ZtGtiZF4p340nrDf@tiehlicka>
References: <20240829130640.1397970-1-mhocko@kernel.org>
 <20240829191746.tsrojxj3kntt4jhp@quack3>
 <4dfed593-5b0c-4565-a6dd-108f1b1fe961@suse.de>
 <ZtGTEOEgf4XuUu7F@tiehlicka>
 <20240830-formel-abklopfen-fa1249f5904d@brauner>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830-formel-abklopfen-fa1249f5904d@brauner>

On Fri 30-08-24 13:01:29, Christian Brauner wrote:
> On Fri, Aug 30, 2024 at 11:38:24AM GMT, Michal Hocko wrote:
> > On Fri 30-08-24 08:11:00, Hannes Reinecke wrote:
> > > On 8/29/24 21:17, Jan Kara wrote:
> > > > On Thu 29-08-24 15:06:40, Michal Hocko wrote:
> > > > > From: Michal Hocko <mhocko@suse.com>
> > > > > 
> > > > > There is only one called of alloc_page_buffers and it doesn't require
> > > > > __GFP_NOFAIL so drop this allocation mode.
> > > > > 
> > > > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > > > 
> > > > Looks good. Feel free to add:
> > > > 
> > > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > > 
> > > > Although even better fix would be to convert the last remaining caller of
> > > > alloc_page_buffers() to folio_alloc_buffers()... But that may be more
> > > > difficult.
> > > > 
> > > Already done by Pankajs large-block patchset, currently staged in vfs.git.
> > 
> > Which branch should I be looking at?
> 
> Hi Michal, Hannes should be referring to:
> https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs.blocksize

OK, but that branch seems to still have alloc_page_buffers user.
Maybe I am just misunderstanding what am I supposed to do here.
Anyway, I won't have much time to spend refactoring this so if there are
more changes required then I will likely not get to that. Sorry.
-- 
Michal Hocko
SUSE Labs
