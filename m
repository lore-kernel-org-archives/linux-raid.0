Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B2022F0C
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709666174; cv=none; b=k9Mh3hXWZmeTX8tmJE44CO8it0GWcDz/8gMnjs3Xw6R3XDa/F8DdE94gXIdc2iwmZNdpCwhaP/Oo5kMQwJ8VCtnZNgvy1Q3Q5WTIUvpXu3DDWsYKS7I1WpHl18scCJzF49BVYYH8ifS3OCF3oCZQZ27kUI/GdFMOL5AphoYn5Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709666174; c=relaxed/simple;
	bh=oG8ZzpcnX77hmopTqVFecVNH8qHE11eP1MFgLsxgoyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxuiYCOXCIJg4uaR/OZ5OooT2itKXTzhH17PYxJzH71ZCRkkhB69RAxobHJzFE/3EMUyi9mOI9eKPNRJe1tauVrFDKXn8TYRikJvdJL0+FMult20XjFKPB4UW+dhs29hFlTPd9YQDqe3X5459ZQbK1rSXpIbuNiu9EFLIlC1kH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-68f5cdca7a3so637776d6.1
        for <linux-raid@vger.kernel.org>; Tue, 05 Mar 2024 11:16:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709666172; x=1710270972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FIdcTmA+GbjII2/0pif/GDtFSocWhsyjRQ59DjG6JI=;
        b=mQZHjg7k2sG7+4U2vTcFRUKnInq+UhKI1TlFikNYW4hC3EpnM/iHAX9MKnlVQbyxFF
         nykR0kN3ELAlqEmZx/fcV4ISmtSP6s4Z17DbtrDFgJulDYW5gMiw1GndLvyiMgRkDxzf
         eKDjuDZ3uPJJkVZHOY2ZwxX257qB5A13JuaK5CDk17aFPIct2kddHhBnDmX/VnT9lcSV
         fgKXwgOKAasYcxxHLlKiQrx7uKOfehAGuwJrjC9+tSiLfVEakfva4K8OpPShxPl1WjSa
         c9luVu/TZYiKi6EnKjwoErOUl2R8MDabVCaEMa3ciSQiBInySt1IR53iHxOfaOKrsk7e
         npIA==
X-Gm-Message-State: AOJu0YwEwW6nKfRp/Sa06HmQL0X+3LYfhgBm0+Ah+1IilHas1/1/CsxE
	FoxHXeN7guJ5PHwIQ4DGnGo1S6DRLwns7dmUni3x8HD2bznEOd+lnEaAtuXSxmVjIoSC56whzBI
	=
X-Google-Smtp-Source: AGHT+IEL+3tWSSmMgjjhlQqRSkh94vstTZRuMUA9188eeJ1xHRXP20UJ7IcU7d4VlKX8TvEEOREG6Q==
X-Received: by 2002:ad4:4045:0:b0:690:4e40:76f3 with SMTP id r5-20020ad44045000000b006904e4076f3mr4993697qvp.25.1709666171980;
        Tue, 05 Mar 2024 11:16:11 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ej19-20020ad45a53000000b0068f65b22b0fsm6540392qvb.82.2024.03.05.11.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 11:16:11 -0800 (PST)
Date: Tue, 5 Mar 2024 14:16:10 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Song Liu <songliubraving@meta.com>
Cc: linux-raid <linux-raid@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai1@huaweicloud.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Junxiao Bi <junxiao.bi@oracle.com>, Dan Moulding <dan@danm.net>,
	Song Liu <song@kernel.org>
Subject: Re: [GIT PULL] md-6.8 20240305
Message-ID: <Zedveg1t6VK-vNiO@redhat.com>
References: <2FCF4E06-B33B-44A8-95D7-8BA481313BB8@fb.com>
 <cbd5ed5f-f4f6-455f-aedd-98e41be70d92@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbd5ed5f-f4f6-455f-aedd-98e41be70d92@kernel.dk>

On Tue, Mar 05 2024 at  1:49P -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 3/5/24 11:47 AM, Song Liu wrote:
> > Hi Jens, 
> > 
> > Please consider pulling the following fixes for md-6.8 on top of your 
> > block-6.8 branch. This set fixes two issues:
> > 
> > 1. dmraid regression since 6.7 kernels. This issue was initially 
> >    reported in [1]. This set of fix has been reviewed and tested by
> >    md and dm folks. 
> > 
> > 2. raid5 hang since 6.7 kernel, reported in [2]. We haven't got a 
> >    better fix for this issue yet. This revert is a workaround. It has
> >    been applied to 6.7 stable kernels [3], and proved to be affective.
> >    We will look more into this issue for a better fix. 
> > 
> > We understand this is really last minute for the 6.8 release. But based 
> > on the data we have, these changes are safe and fix issues in the 6.8 
> > kernel. 
> 
> There's just no way we're doing this much at this late in the process,
> particularly when these are a) not introduced in the 6.8 cycle, and b)
> we're not even a week away from the merge window. Doing them now for 6.8
> would just further risk stability there, no matter how well it's tested,
> and it won't really reduce the time to stable anyway. Hence no, please
> add these to the 6.9 queue.

I agree.

Song, please revisit each commit's header to make sure they are
flagged for stable@ if appropriate (e.g. either add a Fixes: tag or
explicitly Cc: stable@).

Thanks,
Mike
