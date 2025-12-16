Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2282E7161
	for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 08:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765874526; cv=none; b=PWYNRO+JbHQxRBIHwWoVvJZMlMRT1uNW/WMU+BiQYMha5P55rNnRXhHbD6N1zztByrCTLp42xwSRFBIjBP1GkNyra0prK8HmYBz2VxdYlJAzhaNqrXs1neGGNfUsNKorwcHxyAfx48eJT2E8Euk4rHLiASgZ8G2KJR6QHd9qj3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765874526; c=relaxed/simple;
	bh=LeSPLdw8CyUvLD+Wsks/a84DYfWD8ihFZCgPW/k/oKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alwJ1m3FtlhMwMbaZ3DEfkTwAdT64YPqtneca26cuc1ugEVKbcOu8iFh46uSy/RgFZj3GgkXsX6wkPi2Pd8Z1wN08zBvI5uqMe2M9nkfbDQgd7Qo4jM2WDa6C6dzxvMZ1vSXNSBLI3nybRIiK/ei+4aqN+sybwx0Unt7cy+z3EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H7TLAJ3C; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bQx2whWG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H7TLAJ3C";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bQx2whWG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765874523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bedoI72M4dzcfCaw0bozxUr5koxef0u+N35NgEwFoMY=;
	b=H7TLAJ3CEpseqHx+NV8WMzYuHgvKJVbD//eZtyLLOZE9ZAT2vEvMgC799tmdZr03ghn+cD
	tcOQPTCKqLd2AG3scEurdrqWYMe6G2K9n/wgG8sqxVAbZx8kJagnoiBMrFWTAJiQkbBIXx
	cVZJm7i5iC4oq2HT2BeyhU6Z77GnmX8=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-Tx6Hj8I4NuibFASDbr5Yzw-1; Tue, 16 Dec 2025 03:42:01 -0500
X-MC-Unique: Tx6Hj8I4NuibFASDbr5Yzw-1
X-Mimecast-MFC-AGG-ID: Tx6Hj8I4NuibFASDbr5Yzw_1765874521
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78e778d774cso25613887b3.2
        for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 00:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765874521; x=1766479321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bedoI72M4dzcfCaw0bozxUr5koxef0u+N35NgEwFoMY=;
        b=bQx2whWGC7/zTs/T2taZQ2SwQ3sakREVj/mczAXJf6or4kz4UIjWV/oNhg0zGhWj3v
         KypdbgOP2xq1nMAKubDDT1siuotr2dc8rusCHUa7yS8PGPBDd995LZvMQQObPaKmLB/Q
         nQBJBE+FN8Wd0fJuYhOw1E1eWJcmCIdlKnCir5FbILdQt3KTi452ES1minrzUioHQfYA
         RVUEKq8n4ei11Vts3aI2jnWql8uqcI9SlwrTZC4gb5SqFu4n818CNXv5Ziljxrnpwfo5
         9RI5S/wmuHmLvtfO04JzEEKdgiHfei0mZKzQQiVmOhhkmudtm+a1SQW/M6BvojVOwIaQ
         AlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765874521; x=1766479321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bedoI72M4dzcfCaw0bozxUr5koxef0u+N35NgEwFoMY=;
        b=tx4FQ3rYrewVQRBqjf0YXHcXFJ7gFFAKxQbkn4lytc7sUtoqGobrauTHoCwZwata8R
         X/YV1pqyfu1yYbJxPzAdYBUrBMdnmVGuYC/MPGBWZFYsQQALrTQRyEq24CrOhLCJc7ho
         6mYkemurqi3kPuPnpMOuXxHdmMHGK1CZZWOwDSLGC4+5glKdHGfdiA9V8BwmPz+XIPf+
         Il7kDiGCpOMVWCxCz27umGGYouNDni1wcx8CnMY2bdbqncRkNRgnSpLjby1cj5OlOByI
         oQR9LNBMdTkgJrcjMffpQJf2hs2IUWAYv8nsqTxzH2QKvuFCuhrqvv2vBMWYd827QGBf
         oAxw==
X-Forwarded-Encrypted: i=1; AJvYcCX66ICHRCLsY6wTxxjv5jMAh74EYLIbk4bk2tPo1C9fd9zIwPrDID37MS65flkH0HXaMQqyB/IacxOs@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8nf/6ssasQOl1iemwHCXjFlxPkWC4uSZRVuFUYG+JALvTGl4z
	1Odp2rNBXvGQIwhiOQG7L0x2FVXfktbtzhduCFk+IaR7S1w0TQIRUp9Wwqes3IfOdOzZwNvPBaK
	Qlf6u6Wc9nb8zFuhbqbhrPturxtSEXxU2nxRa4GyVWm/OhHM/gPzrlapir0VrUxpLs4XQyVT1YP
	d27X/NVm1w4iB+cmJ688CSPlsFaSQsjZE3YOtGDw==
X-Gm-Gg: AY/fxX627dzVI4epn6sAad1vuvqnDLIPBKOvatza49GGGzURWEVHzh2KFAeIqAjnSsL
	DMBP5to5nnDh261K5Tj0Osr9CJ0ig45g4Uk0VaCT38x+ffntz5VeBlJMK5Pr1iaBe3GIEm3d+FK
	Gx8clMG5tQdqGFnkjF9xaAijTvNrV6B+dyEGvmnVv+kI1pbsrkzqcieBXIOA0b9+nP
X-Received: by 2002:a05:690e:130c:b0:641:f5bc:699c with SMTP id 956f58d0204a3-64555664965mr11300524d50.74.1765874520969;
        Tue, 16 Dec 2025 00:42:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsdXWnoFL9I7pAq/MaIAVAy9awQVMPdeIdCZyZ8gA28f/XjQGXPGkhfCfGI1rJgvn170eyS00H/OkJzbKACvU=
X-Received: by 2002:a05:690e:130c:b0:641:f5bc:699c with SMTP id
 956f58d0204a3-64555664965mr11300511d50.74.1765874520647; Tue, 16 Dec 2025
 00:42:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251208121020.1780402-1-agruenba@redhat.com> <20251208121020.1780402-7-agruenba@redhat.com>
 <aUERRp7S1A5YXCm4@infradead.org>
In-Reply-To: <aUERRp7S1A5YXCm4@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 16 Dec 2025 09:41:49 +0100
X-Gm-Features: AQt7F2oWOgXF4BWLyQhRHkpji9S9Pl-ufTycpWlGBJkrm01TM2UaID084bN-gCY
Message-ID: <CAHc6FU6QCfqTM9zCREdp3o0UzFX99q2QqXgOiNkN8OtnhWYZVQ@mail.gmail.com>
Subject: Re: [RFC 06/12] bio: don't check target->bi_status on error
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 8:59=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
> On Mon, Dec 08, 2025 at 12:10:13PM +0000, Andreas Gruenbacher wrote:
> > In a few places, target->bi_status is set to source->bi_status only if
> > source->bi_status is not 0 and target->bi_status is (still) 0.  Here,
> > checking the value of target->bi_status before setting it is an
> > unnecessary micro optimization because we are already on an error path.
>
> What is source and target here?  I have a hard time trying to follow
> what this is trying to do.

Not sure, what would you suggest instead?

Thanks,
Andreas

