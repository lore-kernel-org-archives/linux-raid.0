Received: from hermes.turmel.org (hermes.turmel.org [192.73.239.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB4D143891
	for <linux-raid@vger.kernel.org>; Wed, 24 Apr 2024 13:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.73.239.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713963872; cv=none; b=Bq8sfMP+EQ4tcrZ5U0w7DDihN0x7sGjnLWySTRHbNZjEwjkwOwhUbrlcAdqpsxCHvGxVDiFvxpr5pB3LljwoIw9cGIpr1cQVE3McHrgORqSiKIOTOUO30keuhvPIRN/0D8b9RfTvcQ61Px6XTutkHyy7Qhb9V8vMvYRnbht6E5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713963872; c=relaxed/simple;
	bh=ptw37vnT2qNQiQWLqH19E0tYUSd7itg4Q4BQULaDnqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UMTwhobFOMJRQ7INwU65QH8qo5zXBb00aa2bmV/0FLaLnO2mnav84a87aCbC8J3ivvk+bIrSrfMez/ps/7Ul9M8gS12iI456GVFNVYR7Jn6C2cErLH2BSyPsDnLDh/RZ17grlKMl79QNvFuBYkjM93L2wzg2rhroqRSpui3DVS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=turmel.org; spf=pass smtp.mailfrom=turmel.org; dkim=pass (2048-bit key) header.d=turmel.org header.i=@turmel.org header.b=K+wt0S/5; arc=none smtp.client-ip=192.73.239.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=turmel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=turmel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=turmel.org header.i=@turmel.org header.b="K+wt0S/5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
	 s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:To
	:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9fwarCDGQZVgEGX6Khuip5IXPbVqilgPk4loJ6kE6ME=; b=K+wt0S/5pTXwqA54+qBkcp1pRU
	+/I1u9COf4ioCJMOqkuZrJHyug0p4OsAdOyfsHeKzIRS9E0/8B/3bIhk1MyCIQpeSuXnOF7XWG7bD
	J+cR0ZI8201rFJzaZK2eQWkReAEwLyd4bjkHX7A54UT+W0Au5+XES6X31PuhS4w8QM/0tdQL8kjYL
	IMQFTvYsnaiJHYIF9KNZPdWxf4s2ISfJxTH/YjRqlupEo32H7yjPYvqWWHQwZkwWnk1sA3eXR/V2T
	gWbKZYj0DQRG7W4JCd8aY35zBGjIBIJ+yGqNpeVs1oIuVEMD40vNMFvCUqbTc/RFeaM/rgAGOTV/X
	GO6/Ffbg==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
	by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.90_1)
	(envelope-from <philip@turmel.org>)
	id 1rzbs6-0006Gs-Qv; Wed, 24 Apr 2024 12:37:10 +0000
Message-ID: <6b5f7b91-71d0-4151-9d27-dc0a3a8ecdce@turmel.org>
Date: Wed, 24 Apr 2024 08:37:10 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Move mdadm development to Github
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 linux-raid@vger.kernel.org
References: <20240424084116.000030f3@linux.intel.com>
Content-Language: en-US
From: Phil Turmel <philip@turmel.org>
In-Reply-To: <20240424084116.000030f3@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Seems reasonable to me.  Likely to make it easier for new contributors.

On 4/24/24 02:41, Mariusz Tkaczyk wrote:
> Hello,
> In case you didn't notice the patchset:
> https://lore.kernel.org/linux-raid/20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com/T/#t
> 
> For now, I didn't receive any feedback. I would love to hear you before
> making it real.
> 
> Thanks,
> Mariusz
> 

