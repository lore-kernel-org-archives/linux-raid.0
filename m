Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A7318412A
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 20:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714508571; cv=none; b=oCTllR9vyfhfQalqA0lpUpUtjR8LG00xl1xYqQpyV32lLR5dCXTxFh7hh71lWcEq3SQjMK83Sma6j4VEkSJoH3daR+Dj0S7cA8dVeWmFZAxuc/2HuabiJO4rNf5tuasoMxX70XNzUZDzY85A1jDNaWyl2WdBiZmEqbWi7B2XJI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714508571; c=relaxed/simple;
	bh=cNHplpz7P2xVzVPhet7fIlFHKSZpbP+RurvXyQHannU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uHPvz84mUQn0fpC+c6XCPc09SsNi/lfo2THgdAhQdUXKbEl/i+4pwnLIxSegnsS4X35NZTWv8WIPaUlFmoxrh0EGeeUtt2bL0/90Lccgp6bcifVKWbYm8oDIgjSiAp4Rw6hV+moQYt+K2jO4w3WFWZ+zZfWwkxjgp2ZKTm/sYWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=pass smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=youngman.org.uk
Received: from host31-49-121-21.range31-49.btcentralplus.com ([31.49.121.21] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1s1tzr-00000000A0F-3Xs0;
	Tue, 30 Apr 2024 21:22:39 +0100
Message-ID: <50ac2d38-8d32-414f-a17a-b61a085b5894@youngman.org.uk>
Date: Tue, 30 Apr 2024 21:22:37 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Move mdadm development to Github
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, John Stoffel
 <john@stoffel.org>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240424084116.000030f3@linux.intel.com>
 <26154.50516.791849.109848@quad.stoffel.home>
 <20240424052711.2ee0efd3@peluse-desk5>
 <3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
 <20240426102239.00006eba@linux.intel.com>
 <38770f23-92da-09a6-227f-11f1176294e2@huaweicloud.com>
 <85f74f83-bd1b-439d-874c-b3a38bdd2d71@suse.de>
Content-Language: en-GB
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <85f74f83-bd1b-439d-874c-b3a38bdd2d71@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/04/2024 12:15, Hannes Reinecke wrote:
> We really should keep the mailing list alive, and enable people
> to choose which interface suits them best.
> I don't have a problem in switching to github as the primary
> tree, but we should keep the original location intact as a
> mirror and continue to allow people to use the mailing list
> to send patches.
> 
> This is especially important for low-volume mailing lists,
> where we have quite a few occasional contributors, and we
> should strive to make it as easy (and convenient) as possible
> for them.

Well they're planning to keep the mailing list - it isn't an mdadm list 
anyway. So long as they keep an eye on the list for list responses.

A lot of people (like me) go near github maybe once in a blue moon. 
Expecting non-dedicated developers to check regularly is a very big ask. 
Expecting reviewers to know what to do on github is a big ask!

I use github for a project, and really don't know my way around it.

Cheers,
Wol
