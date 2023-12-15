Received: from hermes.turmel.org (hermes.turmel.org [192.73.239.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C243EA6F
	for <linux-raid@vger.kernel.org>; Fri, 15 Dec 2023 16:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=turmel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=turmel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=turmel.org header.i=@turmel.org header.b="BmgxeaXX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
	 s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
	:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uM3Zy/AOrEsl3JHnUTZqMT1OdXjwKo1g1lPDJzIpBCM=; b=BmgxeaXXKIU1qabilfAhQ05WqT
	pr6H1Waxi66QrilWN97MktdGdFS7y5/4POhItFIxo9fl8qshtg+1M/ohnFkZjnel8q7qinQf13tdA
	cO8KHeie82lWUvLYECqicuLITc/VVMNfWVE+lvxI8SOmVlNX0HpJEleMxFeIYEGO6/hBOYSIwaJK0
	XyQb1QRkhOXQz0eX9wlPy1vNah4tGaYRCtf4dA5y+xkw0Xj42EhHslcpsHytsRcr678oOTL3R0Z9p
	pFA8X2xkP8NJtCZL37vStI5Bco64JGVkvnkcHjB+qHtOQPITqj0uC2BBAA3M5Og0yz1PQODb/H6QV
	Y9lHJuGw==;
Received: from [98.97.179.140] (helo=[192.168.19.197])
	by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.90_1)
	(envelope-from <philip@turmel.org>)
	id 1rEAjf-00072B-Rl; Fri, 15 Dec 2023 16:08:23 +0000
Message-ID: <ce2f6d3c-6486-43bc-991a-897ebe20fd46@turmel.org>
Date: Fri, 15 Dec 2023 11:08:21 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Announcement: mdadm maintainer update
To: Jes Sorensen <jes@trained-monkey.org>,
 "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Song Liu <songliubraving@fb.com>, Coly Li <colyli@suse.de>,
 "Luse, Paul E" <paul.e.luse@intel.com>
References: <e5c7971f-a600-08ec-0f31-8f255bd99979@trained-monkey.org>
Content-Language: en-US
From: Phil Turmel <philip@turmel.org>
In-Reply-To: <e5c7971f-a600-08ec-0f31-8f255bd99979@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Congratulations Mariusz!  And *thank you* !!

On 12/14/23 09:18, Jes Sorensen wrote:
> Hi
> 
> I wanted to let everyone know that Mariusz Tkaczyk is joining as mdadm
> co-maintainer.
> 
> Anyone who has spent time on this list over the last couple of years
> knows Mariusz as a serious and thorough patch reviewer and I believe he
> will do a great job as co-maintainer. Most people will also have noticed
> I have been struggling keeping up due to lack of time, especially since
> mdadm is no longer directly linked to my daytime job. Having Mariusz
> onboard should help us progress faster.
> 
> Thanks for stepping up Mariusz!
> 
> Jes
> 

