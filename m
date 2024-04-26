Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857E71482EA
	for <linux-raid@vger.kernel.org>; Fri, 26 Apr 2024 10:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714126579; cv=none; b=cj3oA6vXp+u4YwSGDviQ3kyhiNtSa5ZCfphyC1Rbg4V4EFSZUFBI3S+5RLQ2fpn+kMlWJVQSNEaav+9+5w37kNGyxE056BnyRQ0lS1ApVInRQ07Fz/Z+8YiCrqgOjq+dmukRDvTiAjeS0SUVVgv+DWUwRhiUO1/OhPAWaW69s/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714126579; c=relaxed/simple;
	bh=iLbFo0uYMNYu2ycBK2wjRvUmXyeUAom67XT78psjBEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ts3/BEVRMMlSOEVdApAgRjP07ZsWTxyCaSyUFTiUBYtwfvGDfAtcbOe1+sl+smRMhwoAGkC7giHH5/L/Xtjns5ZuM/GlrfH7FPR3aiUCNjMX5gARtjBAj4W8d1BxBMxDUsKmrS8g/6nfa33FKjdQEprE5iFX/7tV1SsIzUbPXRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=pass smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=youngman.org.uk
Received: from host31-49-121-21.range31-49.btcentralplus.com ([31.49.121.21] helo=[192.168.1.99])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1s0Fzm-00000000A6w-2N1v;
	Fri, 26 Apr 2024 08:27:46 +0100
Message-ID: <3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
Date: Fri, 26 Apr 2024 08:27:44 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Move mdadm development to Github
To: Paul E Luse <paul.e.luse@linux.intel.com>, John Stoffel <john@stoffel.org>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 linux-raid@vger.kernel.org
References: <20240424084116.000030f3@linux.intel.com>
 <26154.50516.791849.109848@quad.stoffel.home>
 <20240424052711.2ee0efd3@peluse-desk5>
Content-Language: en-GB
From: Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20240424052711.2ee0efd3@peluse-desk5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/04/2024 13:27, Paul E Luse wrote:
> * Instead of using the mailing list to propose patches, use GitHub Pull
>    Requests. Mariusz is setting up GitHub to send an email to the mailing
>    list so that everyone can still be made aware of new patches in the
>    same manner as before.  Just use GitHub moving forward for actual
>    code reviews.

Does that mean contributors now need a github account? That won't go 
down well with some people I expect ...

Cheers,
Wol
