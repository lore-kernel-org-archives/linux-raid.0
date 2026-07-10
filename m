Received: from mr4.vodafonemail.de (mr4.vodafonemail.de [145.253.228.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D93263F5E
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 16:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783701048; cv=none; b=WZjsvafT4eDr+LjwRXhWmUgsHQVV+CiUrbSK6YOLy+EZr9bXtDHEG6kk5SkGm/8h+GmavK4wg43HArnaG14BksOzWYJrOSp5gKj7u8qGWqp4PkGfRMp+ODTIooAdjcyQLRHnOJuDY8MVP07jY6DE54IDvt966UU/SCWn6OjjX5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783701048; c=relaxed/simple;
	bh=CQaI6iKjwAdpthRgr5w8NU1/C8Axme/1yLMkbkLE3pE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sl/lpq6t71/7CdXyJEeS+/I2dzkIR5DIXlt67IsKldZLoUSKRNEbDF3qDPbNo1v2sgemE2k7qYW6vTo3qhEsvk8tNRt81CADSbT2u4ngqug8nkEcHw7rI/dLK55NXLXWLCPtSQf6uoFzB+bWFTdQMhfYVVsgdo5J7LUvaQl80do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=hupMBLaX; arc=none smtp.client-ip=145.253.228.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="hupMBLaX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1783700462;
	bh=rMqY6B++xUxtE9n3rDHgl8MGkb38mNuPXNZTWrUJbFk=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 In-Reply-To:From;
	b=hupMBLaX0UfJ2YhBPPVwwaSu3B1qWkLBY06eVaDN2RO9LZyk5d3Wnz1wexk94zTHm
	 sEOh1D8gDT2bdbBlI5SpyGpHngw+lOBz8B+bBxXJGq/Ka4D3lgRnL6b9UNcEBM6ngD
	 t1TGyFv4mnyFoJOpu1cEt31L2MQU3wZXfbGiMnbM=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr4.vodafonemail.de (Postfix) with ESMTPS id 4gxcWy6Qwrz3sXYG
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 16:21:02 +0000 (UTC)
Received: from lazy.lzy (p579d7d31.dip0.t-ipconnect.de [87.157.125.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4gxcWv3srDz904x;
	Fri, 10 Jul 2026 16:20:56 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.2/8.14.5) with ESMTP id 66AGKtbT036006;
	Fri, 10 Jul 2026 18:20:55 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.2/8.18.2/Submit) id 66AGKtoI036005;
	Fri, 10 Jul 2026 18:20:55 +0200
Date: Fri, 10 Jul 2026 18:20:55 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: LBS setup
Message-ID: <alEb50Nmqt8IW2Nu@lazy.lzy>
References: <ahLSj1Ua5WJ0GTgY@lazy.lzy>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahLSj1Ua5WJ0GTgY@lazy.lzy>
X-purgate-server: smtpa03
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1239
X-purgate-ID: 155817::1783700462-624E85D1-75723228/0/0

Hi again,

not sure, but has anybody comments
on the topic?

Thanks,

bye,

pg

On Sun, May 24, 2026 at 12:27:27PM +0200, Piergiorgio Sartor wrote:
> Hi all,
> 
> I've some questions about some recent
> report from kernel.
> I assume from 7.x.y, from what I understood.
> Not sure about the <= 6.18 reported.
> 
> In the boot log there is:
> 
> md0: echo current LBS to md/logical_block_size to prevent data loss issues from LBS changes.
>       Note: After setting, array will not be assembled in old kernels (<= 6.18)
> 
> I found the docs stating:
> 
> logical_block_size
> 	... Write the value before starting array. ...
> 
> Now, should we really copy the value from:
> 
> /sys/class/block/md0/queue/logical_block_size
> 
> to:
> 
> /sys/class/block/md0/md/logical_block_size
> 
> ???
> 
> Note, the first in my system is 512, the
> second is 0.
> 
> Second, the docs says "before starting array".
> In case this is due (copy the value), how to do
> for a system array?
> I mean, the array where the whole OS lies.
> 
> If needed, is there any way to do this automatically?
> Using mdadm or something?
> 
> Thanks,
> 
> bye,
> 
> -- 
> 
> piergiorgio
> 

-- 

piergiorgio
