Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F1A175A5
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 15:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716479334; cv=none; b=V8pLY9BhOJJL3IJypCS+39V8yHIfxOic+PAistkrX1neuh3fhuBiiPLLGhqlMF1ubGa6n9OUVsDYKhyt1gIVCcCN5QJrX/n91T2C12QjsaX4/tFlu01kTW7PVmDpMEGAyQIN236KRG/UrdUxjoUj+3nPrAAFLUbH0CcDqy5f10A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716479334; c=relaxed/simple;
	bh=jC0aG3EkzcKZdjr+fP2C64RYCMwKnxXtn8lfl+S1K9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mh9vMFdQgE1ql65SD3Xi5ZFbx/HKqA6YXRz2LTieOIg5rviN1ccGz8wIHLOMmpmalndcGlJ7SPqCGwYYYElQNOitlzAVTw8+YMwDDrnbi+eaX28h3TyYX0kQsy9wyS9w4L+cGDh3sBGkgZ5tva+bHA8pKJIVd5A4RLRCi1wy8Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7f8df927790so803491241.3
        for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 08:48:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716479332; x=1717084132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5+s+v+Kaz3Sa2swWlssFa+au8LNzsklBiXuB2DuE8Y=;
        b=wUspasaNF8MZnzF2M0r+U8srcfLhyfxto100fxsTX1aHXI1LQ6NHuzKZL6wl0CIsvO
         KSxDlTtdNO1mRHwKMODLuk13dzL9ytIDS2QGqeABRora2EEU3skP+mJfldAFriKDIWD0
         sCAjGEeU2++SNNRb/508m1NY8QUXdjaQ3BM7Wxs2UdAUk81kkWaEi9zl5UQ8i8gsiU5z
         btOKSOAcLknCU/X8VE8GFpYqsGkQMiDwg74krNFzrsPX+mLNsNsS5y3fbpq1h38smCol
         q74GAorf6JV7MTxf0+tVEW4HJEtafvUXrOhoXOSRdM+0U2KQE3tuqdEPLiJsV471HMOY
         wrug==
X-Forwarded-Encrypted: i=1; AJvYcCWr07b6CkLVbPLd3yOEC9dYV9qfE9WG7mvWv1mut6AI0SYgHQrqxh5+IDDgAFMIlvQtsHeGoGz/384Vc8NJWUF/WNhPRKZgpIUAAg==
X-Gm-Message-State: AOJu0YysiAyawiHV3l8xGurBxmk/pnb9qA2RqPJwWHeqhjaVGU3ojWtE
	3o4K6lJJAZnYj7ClsG07tn3xz/FsET7WHOmMGfLLsof6f8aSLfa7khwo9BWvpU0=
X-Google-Smtp-Source: AGHT+IFnQTuSDpB+iXcIQzp9C6VddK7XK5I10n5kKiU1npfJRVtTmmVFoX2dLZUvEHgiCelrQmnMHg==
X-Received: by 2002:a05:6122:1684:b0:4da:9aa1:dd5e with SMTP id 71dfb90a1353d-4e2185b2452mr5729898e0c.10.1716479332059;
        Thu, 23 May 2024 08:48:52 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ab84cd6d93sm15947186d6.127.2024.05.23.08.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 08:48:51 -0700 (PDT)
Date: Thu, 23 May 2024 11:48:50 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH for-6.10-rc1] block: fix blk_validate_limits() to
 properly handle stacked devices
Message-ID: <Zk9lYpthswuegMhn@kernel.org>
References: <20240522025117.75568-1-snitzer@kernel.org>
 <20240522142458.GB7502@lst.de>
 <Zk4h-6f2M0XmraJV@kernel.org>
 <Zk6haNVa5JXxlOf1@fedora>
 <Zk9i7V2GRoHxBPRu@kernel.org>
 <20240523154435.GA1783@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523154435.GA1783@lst.de>

On Thu, May 23, 2024 at 05:44:35PM +0200, Christoph Hellwig wrote:
> On Thu, May 23, 2024 at 11:38:21AM -0400, Mike Snitzer wrote:
> > Sure, we could elevate it to blk_validate_limits (and callers) but
> > adding a 'stacking' parameter is more intrusive on an API level.
> > 
> > Best to just update blk_set_stacking_limits() to set a new 'stacking'
> > flag in struct queue_limits, and update blk_stack_limits() to stack
> > that flag up.
> > 
> > I've verified this commit to work and have staged it in linux-next via
> > linux-dm.git's 'for-next', see:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=cedc03d697ff255dd5b600146521434e2e921815
> > 
> > Jens (and obviously: Christoph, Ming and others), I'm happy to send
> > this to Linus tomorrow morning if you could please provide your
> > Reviewed-by or Acked-by.  I'd prefer to keep the intermediate DM fix
> > just to "show the work and testing".
> 
> A stacking flag in the limits is fundamentally wrong, please don't
> do this.

Um, how so?  It serves as a hint to how the limits were constructed.

Reality is, we have stacking block devices that regularly are _not_
accounted for when people make changes to block core queue_limits
code.  That is a serious problem.

Happy to see the need for the 'stacking' flag to go away in time but I
fail to see why it is "fundamentally wrong".

Mike
