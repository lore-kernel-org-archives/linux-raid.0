Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC5C79C8
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 09:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709373373; cv=pass; b=FxeUE5oEXamQwngBaa3ZhPhSX5CeQR5RoRPwcUOTcqnohT27QCo7ikO/D3y+3OrRezwlH1eaWzPMGvdZDTF9WPH4419WNq1Nw65/HTJ/5cLvtOyz/uNdG2TWTV+mzZDqwy9+hGmRZ7m29FQCjmFKP2VCKPyVM5exe1rijWU7ABo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709373373; c=relaxed/simple;
	bh=b2krFcTyJwgTcH3arFV+KCrRoeK4z+IzLa54PN8jc8M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=StPjxRkfNTg9Pz4un039+JAXivkDd0QNd8aHXio0hcYFMNtKbeS9TpFQgLZjqJoaogKDxXQKFdaxJBEOUIgXl2F5KQBZj2KOSGCsoILFjayarEDvkIBm8fPGPq0PkXfve0pYiNuoBUuzbuZu0+bbglWjkBJIsME0DhJ3ZAZSR8M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=qhetmXqk; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="qhetmXqk"
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: tovi)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4Tn0hg39p1zyxR
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 11:56:03 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1709373363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUWE/Yv0eh9d5ggUebmcSev4eHfDalEv6rgCG9lMf1o=;
	b=qhetmXqkIva6vKpE0OF5xpeRsL6OGzYCb2FbcNOxL4VzhCBIv6Eelirwek1fkTVMpXB0MI
	S5qbFzmKDqtpFGexaqFsjadUWuOtnzGjcoV0Xf90/KOaDvPoLkIcF/mYm/uG1KK5uYM187
	GMGD9Dd4y5CXJnq6cY++UsarLZDPZvQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1709373363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUWE/Yv0eh9d5ggUebmcSev4eHfDalEv6rgCG9lMf1o=;
	b=Uk/yHX1LD82QfiIjK8cRp0rExnzEckEXZYvwIIx5/kYusfPLjTIHGEaMZkDbw/5oAEGJE+
	Tx6R88oPqiM/2/BgSXnG9vTchBkCEr1wn2ZVDAWEwctuFrP+hzfYBa+cIlGdoJff1X6mUQ
	I1Y6pFmMDYM5LwBXpYc5AOWPhGKOPCM=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=tovi smtp.mailfrom=tovi@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1709373363; a=rsa-sha256; cv=none;
	b=Ehf92rElhIMjAG9B8YRJmq2p88UyxGqa6fP3pE3JA2tOW+6VZvGJfKtvtq/V6HXVD2HWdT
	lyb+dC+sfXfB1raR26QsbG5s9yvF8Lj1gqpopcsIhWCLMjmLDJL+QolltaBSiKuqSKYq/d
	IazncCD87k3mVdMrYWpdE0CdHNgcAZw=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5ce942efda5so2398535a12.2
        for <linux-raid@vger.kernel.org>; Sat, 02 Mar 2024 01:56:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW67qMtdXtIX11j+xDuIh/MphjfeVTWb/bUhja7zvfSEuDazygisLlGYAqWI0XwZQzgWYyS/b1m0oPBOaIYVKsWgM/u/F0dHIEZLA==
X-Gm-Message-State: AOJu0Yy+lBsa5FOZ3YcYfqYCRjFO8L5BDeA9I6bemc0NgVeB0oJ+n0Q7
	nylR5AtLOECoz4vmNJheOjiVA/6FixrDOugDGjdB90f8RwmMWSwUXbHxCV6eEvXU6TtleE5WaUw
	HMRFININGCblnbRrq1zsgd1J2vB0=
X-Google-Smtp-Source: AGHT+IEILOnktMuW6sO0Uwxm4WLz+xnhrLEoVYxYnkvz/EPjFvmjZfCqfhcGsw3ZKLukR0fKYTb3SgKlvXRfaSPanGA=
X-Received: by 2002:a05:6a20:d908:b0:19e:bca3:213f with SMTP id
 jd8-20020a056a20d90800b0019ebca3213fmr4167392pzb.52.1709373361480; Sat, 02
 Mar 2024 01:56:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
 <59dc6165-38f7-407b-b57b-730ac9d4c267@plouf.fr.eu.org> <CADC_b1fJGMSsYjzh8nTnSi2ZgoGmzY_wube2MzgAtr5QwtRzGw@mail.gmail.com>
 <bc3475bd-cdf7-4698-b21a-236e4d055537@plouf.fr.eu.org>
In-Reply-To: <bc3475bd-cdf7-4698-b21a-236e4d055537@plouf.fr.eu.org>
From: Topi Viljanen <tovi@iki.fi>
Date: Sat, 2 Mar 2024 11:55:50 +0200
X-Gmail-Original-Message-ID: <CADC_b1fhFm61QcQd_xud+fS=_068cnf=Hv99SGAeSms-Z-9igg@mail.gmail.com>
Message-ID: <CADC_b1fhFm61QcQd_xud+fS=_068cnf=Hv99SGAeSms-Z-9igg@mail.gmail.com>
Subject: Re: Requesting help with raid6 that stays inactive
To: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

syslog entries before any problems:

Feb 18 19:52:53 NAS-server kernel: [    5.755150] md/raid:md0: device
sde operational as raid disk 5
Feb 18 19:52:53 NAS-server kernel: [    5.755158] md/raid:md0: device
sdb operational as raid disk 0
Feb 18 19:52:53 NAS-server kernel: [    5.755160] md/raid:md0: device
sdf operational as raid disk 3
Feb 18 19:52:53 NAS-server kernel: [    5.755162] md/raid:md0: device
sdg operational as raid disk 1
Feb 18 19:52:53 NAS-server kernel: [    5.755164] md/raid:md0: device
sdd operational as raid disk 2
Feb 18 19:52:53 NAS-server kernel: [    5.755166] md/raid:md0: device
sdc operational as raid disk 4
Feb 18 19:52:53 NAS-server kernel: [    5.757272] md/raid:md0: raid
level 6 active with 6 out of 6 devices, algorithm 2
[...]
Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdc [SAT],
ST4000DM004-2CV104, S/N:WFN14WVT, WWN:5-000c50-0bee83a77, FW:0001,
4.00 TB
Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdd [SAT],
ST4000DM000-1F2168, S/N:Z305RJAR, WWN:5-000c50-087ccf402, FW:CC54,
4.00 TB
Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdb [SAT],
ST4000DM000-1F2168, S/N:Z305RFDP, WWN:5-000c50-087cd03a5, FW:CC54,
4.00 TB
Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sde [SAT], WDC
WD40EZRX-00SPEB0, S/N:WD-WCC4E7TULA48, WWN:5-0014ee-2b5d93dd9,
FW:80.00A80, 4.00 TB
Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sdf [SAT],
ST4000DM000-1F2168, S/N:Z305RVDW, WWN:5-000c50-087cc5e98, FW:CC54,
4.00 TB
Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sdg [SAT],
ST4000DM000-1F2168, S/N:Z305RTB8, WWN:5-000c50-087cc9d0b, FW:CC54,
4.00 TB

Isn't that quite clear how the order should be? I have added those
disks to the create array in that order 0,1,2,3,4,5
Should I try something else?

I was wondering if the problem is unused space? The only disk having
it partition table have this:
Unused Space : before=254896 sectors, after=7856 sectors

So if creating a new array starts from the wrong place? Can that be
somehow inspected?

Topi

On Sat, 2 Mar 2024 at 11:46, Pascal Hambourg <pascal@plouf.fr.eu.org> wrote:
>
> On 02/03/2024 at 09:50, Topi Viljanen wrote:
> >
> > I was able to get the order of the devices from old syslog file
> > (smartd) and then created the array again:
> (...)
> > Running fsck caused so many errors that the mounted ext4 was empty.
> > I reset the overlay array and now I'm running analyze with testdisk.
>
> Then I am afraid that the order was wrong and testdisk will not be able
> to retrieve much.
>
