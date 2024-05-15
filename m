Received: from sender-op-o19.zoho.eu (sender-op-e19.zoho.eu [136.143.169.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FBD15624D
	for <linux-raid@vger.kernel.org>; Wed, 15 May 2024 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715789415; cv=pass; b=iPeAo4qkazk9aBU4x3Z8jvohDxuS/k8rqPeMd5Yd0J3bXy+o/NasHb3VtvZQBSNBhYZzFiJszzaVDczc2TQ294TfcS4LtJUxk+QbA6oGrFQ4s2hf1CFd9Kx3PA+MP7OSXOAV+EPkyKiPOOomY3+fYInygPkQKEyO0hqZb7mPYGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715789415; c=relaxed/simple;
	bh=wavYV8xpL7gT4A+cLkTFnKr54aNOioF1qMbTWs/qa6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QHomHfWDyZiiriVygjhdH5GKUvDPRl+u1qRWzMpLz02fTAtEIhvQCOtd6DpvJp7LIVQ27q+6gBjFKMMvrt2dL8FwNC7/ADrJTdC5yYDSrNviJ6e0So0vu36jcCwmvBESZh14UG/vg7uS6eBAEd4Q+mcktS4kXA66qEWxZDRNzn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trained-monkey.org; spf=pass smtp.mailfrom=trained-monkey.org; arc=pass smtp.client-ip=136.143.169.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trained-monkey.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trained-monkey.org
ARC-Seal: i=1; a=rsa-sha256; t=1715786643; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=YQloRwJdvF1n8ekMl2rs/COiaG+wnMEdW9Opz6poMnqr+bR5H7KseensYuBNvS2MLbAlAtL/BDfCu/NsS7O3wVU7sF444a0rhrLCiYhqb85e1Q4DYEoFIVx0naQt08snzYFicoBSYpBqWGHY52v/WwoOMrP3QIJVn21vmW+55c4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1715786643; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=1qI+4an+mw/is/Qk3yvPTppgVfZz1Y5IvXwon7+oSUM=; 
	b=E/GXdnKvtLnEhsUjHx+XazqEsJ2xHIsHoNZtV6nNjJDUrR4g5C2/lmC+KGpwZBq0MO55B9k5j6TKE+hmUxEcy8dd/CnJzp3cUbwiOOWFWfXSy7i+D663nXdu4Lu9EU/uhgIBiKtHWLdqE/7IxCMhUse0gX7bd98QUd/TpCc5K54=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	spf=pass  smtp.mailfrom=jes@trained-monkey.org;
	dmarc=pass header.from=<jes@trained-monkey.org>
Received: by mx.zoho.eu with SMTPS id 1715786640562975.3096067184111;
	Wed, 15 May 2024 17:24:00 +0200 (CEST)
Message-ID: <893d1c14-74a2-4813-95d6-cec54b376961@trained-monkey.org>
Date: Wed, 15 May 2024 11:23:58 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/1] mdadm: Change main repository to Github
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 linux-raid@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Paul E Luse
 <paul.e.luse@linux.intel.com>, Paul Menzel <pmenzel@molgen.mpg.de>,
 Song Liu <song@kernel.org>, Kinga Tanska <kinga.tanska@linux.intel.com>
References: <20240507153509.23451-1-mariusz.tkaczyk@linux.intel.com>
 <20240515112356.00002dfe@linux.intel.com>
Content-Language: en-US
From: Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20240515112356.00002dfe@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 5/15/24 05:23, Mariusz Tkaczyk wrote:
> I'm scared that I'm doing it but I need to finish what I started.
> 
> I know that I'm pushing some of you to make it happen. I don't feel comfortable
> with this but changes like this requires some self-confidence. I believe that it
> is right thing to do.
> 
> This is not one way ticket, we can always take step back if after the time we
> will realize that my decision was wrong or review flow is awful. There will be
> adjustments for sure.
> 
> Thanks you all for helping me to make this happen. I will not push you to use
> Github but I encourage you to try if you can.

I still think this is a huge mistake, and it will only hurt the project.
There has been plenty of feedback on the list supporting my view.

However you own it now, if you wish to burn down the house, you are free
to do so.

> Applied!

:(

Yes I think I have a github account somewhere, however, it's been years
since I last logged into it. Moving mdadm to github will not change
this, I am simply not planning to make anymore contributions to this
project.

Good luck!

Jes

