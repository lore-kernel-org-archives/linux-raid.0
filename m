Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07987175D3A
	for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 09:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725010709; cv=none; b=uBnRpN3AvSo5EQ8zfytFH5Isl59cVqFGwAEexl5cMinz9+eZ3IFHpD64CfhU7rANSnkteii1vR2oeNUDeN0sT745h+pLYmpyGYYVktCRpVed9WOJ2g+EbDD9mn/4VKjQ98Xf4yphJRYuyZMnVSLgcnPpLfrhc5AEIES+KsOZ+yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725010709; c=relaxed/simple;
	bh=dmdcE6HTs3hIVg4cWA6ZSlOKbEP0rSqlPsifCq4s7ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZ9t2o9oLn+rB9w3QjgAi6d8ckHJB9MI/vA0HSRriNREOU6lHzxPrqWkXm8cxtinxiGjl/vEZmBq4z0XuQNStE2EAOmeAJPhREtkNitKioDhd8X1KsMzmvj+f9mB60KVECtKIAbQpKUAIHxDN9vXiZl5YVV57tAmM1KU8P1lgxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D6ulb7a+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D6ulb7a+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42bbe809b06so1699285e9.1
        for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 02:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725010705; x=1725615505; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rIQZXNI8v9oIEq0epq0G0hg4nnpkW0rgRNsQtdPWSgc=;
        b=D6ulb7a+Yf9yYNWtYorprTaD6zFS/hSvBYW84LMQHdCwVMqZoxDIxEV4tmySgJid04
         zbHtpdrhBCKGbsnNXm7zZ8ty5UQl1V5d8eX9vnk8HesloAdYY12wTPeuSMOD9ybkEkgy
         9XHjU5GAXAkSENL4sGBu0kk9E9kxWEvw/bjkpcIanxXftEusmFa4wvQVW+62TVyRIIPI
         eV/aTkUK5WGf0KPe5mFm8RRzglcS/y2FiNhFxos7JQHw1VRr7oDgkGFDuhkjL71Fdvr9
         pyYSSPras6C3hX5l7jiUaXUbyBCQhIZgYrENyygtUv5qDZnlfBPwxUKg1iWtAP0s+MW+
         pfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725010705; x=1725615505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIQZXNI8v9oIEq0epq0G0hg4nnpkW0rgRNsQtdPWSgc=;
        b=Rijn1JVG+723GQAKPR7jJN5nAfWgOX7bX0E0IbLLtLd3gVFUYgiUjWiZ+pgq+pGPWv
         BUaSviF0WbEzNTlU4H7XQsnKH222VuzPMSAKiu+fL2KiMzq922MxDcoDrwCFenSb62Ht
         ix64tWT2Q+W+yKEmbtKFYpFD1yRELF+MdWgZBTPud2YQ86rebzIcJ2EDjHCx+LOiP/mc
         Ru7E7IbRiKWQXXpm0DPeMCz9PEMnMriIc3+TZKZAxpvTj6pbZM/ohNEf4WOT0Vz8VatH
         xkfp38nECizpDFcrP4zdMIOfpyJcQOGgTjQ+jwgUPbTDuK+MDduvM9L2QeQE3KWdyzBM
         JGbg==
X-Forwarded-Encrypted: i=1; AJvYcCXiZCW83bwXXb0gvgUEi1vGoiPE+LQDzrwZ6FRQees86ar1hmxgoAZzZp46ACEmsm0+5QMFpOcXGVwR@vger.kernel.org
X-Gm-Message-State: AOJu0YwsBJLJZVteFVJ0i5UMbOb95NSCrl09NN9Id2TQg4EgsV9iaEKU
	0vgzRdqDYb7YpDDj45WOgE+y6OxOSS7kBsdfPDH7QK0gtvzMZsbLBQAT/3Cv0vI=
X-Google-Smtp-Source: AGHT+IFRTNDcWXmR6MrM+i4Xbs7qwR9Gvq+QeJw+qBe4H2nleLX5ECks5nDBN2qGUDhWWOpOfTA0ng==
X-Received: by 2002:a05:600c:3ba7:b0:425:7c5f:1bac with SMTP id 5b1f17b1804b1-42bb0306f94mr48820525e9.21.1725010705243;
        Fri, 30 Aug 2024 02:38:25 -0700 (PDT)
Received: from localhost (109-81-82-19.rct.o2.cz. [109.81.82.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb01d300csm49914635e9.15.2024.08.30.02.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 02:38:25 -0700 (PDT)
Date: Fri, 30 Aug 2024 11:38:24 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] fs: drop GFP_NOFAIL mode from alloc_page_buffers
Message-ID: <ZtGTEOEgf4XuUu7F@tiehlicka>
References: <20240829130640.1397970-1-mhocko@kernel.org>
 <20240829191746.tsrojxj3kntt4jhp@quack3>
 <4dfed593-5b0c-4565-a6dd-108f1b1fe961@suse.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dfed593-5b0c-4565-a6dd-108f1b1fe961@suse.de>

On Fri 30-08-24 08:11:00, Hannes Reinecke wrote:
> On 8/29/24 21:17, Jan Kara wrote:
> > On Thu 29-08-24 15:06:40, Michal Hocko wrote:
> > > From: Michal Hocko <mhocko@suse.com>
> > > 
> > > There is only one called of alloc_page_buffers and it doesn't require
> > > __GFP_NOFAIL so drop this allocation mode.
> > > 
> > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > 
> > Looks good. Feel free to add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > Although even better fix would be to convert the last remaining caller of
> > alloc_page_buffers() to folio_alloc_buffers()... But that may be more
> > difficult.
> > 
> Already done by Pankajs large-block patchset, currently staged in vfs.git.

Which branch should I be looking at?
-- 
Michal Hocko
SUSE Labs
