Received: from sender-op-o19.zoho.eu (sender-op-e19.zoho.eu [136.143.169.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF2AF9CD
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 03:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714446511; cv=pass; b=Lhy7X9GZRZW2VQNxykO2zEq3C3GiEauIUBcKJsguAYawRzwBFbg+6jWTH3LaMH6JIQMskYDbsDvdVJhnl9GsraEF0mfIRFgy5h/mrLf4tiINBEunInr4Ak/RmZCi/oBNU2YIff+xnmG8Fktgr8Wk0QKZ3vXjc3hs5TMW5/uCLEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714446511; c=relaxed/simple;
	bh=Uy59SpVMYhp+fYyeJHIX9D3Go5lEWoN8k3TJ+AoU4fs=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=naiMFz06JcyeukebFkgzUcIvUZ0Sq5Ct0uFqWoZJe6Sghn1i41iOzMq2JK3BnLP5xOaiotCt0eDVFN423ufbjeaidn44Vw6ByoaqzXsxoSjEBl9x5gHbthH6ddN7QhaFy8kmWUCoZG+n5RA75qkBVqFsaK4Jyl8zC6dYKm1cmPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trained-monkey.org; spf=pass smtp.mailfrom=trained-monkey.org; arc=pass smtp.client-ip=136.143.169.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trained-monkey.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trained-monkey.org
ARC-Seal: i=1; a=rsa-sha256; t=1714445575; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=JsjbfupU9ufWCbntRvINb8p1uQuBlxMgf0qX9jzCg/TXzLtTOq0JCn+ITXIlar5WTIg5hFiSNBzZRVMxgkJRq2VAxcJfjU1ngdla8zbcd94ofRRSEQPJLMdYZOtXGFKl4SnK62kfzzvdEKhpKxAJ7rB2q0nR+A1IlCsLcDu2iHI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1714445575; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=eZFmOvoAAeJjrOkUYjdsoJDx6L4GrfqGm9mtOQzFjvo=; 
	b=dzA8pKOZZmqD4fcpHMyiS9dz9MtFRXrgbiPcS2jvn2+bqpbYLlVsgY86DXn6AnkRvwjlNajmo1V9glZxaE8ogx7JWfMbwJXljGjsieBOjxX286oI/cD+SsH548S4R4oiL9hKrBRRWyMAW1gNGIJejqxEmikRFD7HGFGfIuqdTdc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	spf=pass  smtp.mailfrom=jes@trained-monkey.org;
	dmarc=pass header.from=<jes@trained-monkey.org>
Received: by mx.zoho.eu with SMTPS id 1714445572263865.7717727219591;
	Tue, 30 Apr 2024 04:52:52 +0200 (CEST)
Date: Mon, 29 Apr 2024 22:52:46 -0400
From: Jes Sorensen <jes@trained-monkey.org>
To: linux-raid@vger.kernel.org,Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,Paul E Luse <paul.e.luse@linux.intel.com>,Song Liu <song@kernel.org>,Kinga Tanska <kinga.tanska@linux.intel.com>
Message-ID: <96eee057-941f-48dc-8aad-c74039c0b1fe.maildroid@localhost>
In-Reply-To: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
Subject: Re: [PATCH 0/1] Move mdadm development to Github
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: MailDroid/5.21 (Android 14)
User-Agent: MailDroid/5.21 (Android 14)
X-ZohoMailClient: External

Disappointed to see this :(

The github interface is not a favorite. Mailing lists are the way open source projects work.

I haven't had much time to contribute for quite a while now and probably won't in the near future. Given this decision was made without my involvement, I'll sign off.

Jes 


-----Original Message-----
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Paul E Luse <paul.e.luse@linux.intel.com>, Song Liu <song@kernel.org>, Kinga Tanska <kinga.tanska@linux.intel.com>, Jes Sorensen <jes@trained-monkey.org>
Sent: Fri, 19 Apr 2024 5:39
Subject: [PATCH 0/1] Move mdadm development to Github

Thanks to Song and Paul, we created organization for md-raid on Github.
This is a perfect place to maintain mdadm. I would like announce moving
mdadm development to Github.

It is already forked, feel free to explore:
https://github.com/md-raid-utilities/mdadm

Github is powerful and it has well integrated CI. On the repo, you can
already find a pull request which will add compilation and code style
tests (Thanks to Kinga!).
This is MORE than we have now so I believe that with the change mdadm
stability and code quality will be increased. The participating method
will be simplified, it is really easy to create pull request. Also,
anyone can fork repo with base tests included and properly configured.

Note that Song and Paul are working on a per patch CI system using GitHub
Actions and a dedicated rack of servers to enable fast container, VM and
bare metal testing for both mdraid and mdadm. Having mdadm on GitHub will
help with that integration.

As a result of moving to GitHub, we will no longer be using mailing list
to propose patches, we will be using GitHub Pull Requests (PRs). As the
community adjusts to using PRs I will be setting up auto-notification
for those who attempt to use email for patches to let them know that we
now use PRs.  I will also setup GitHub to send email to the mailing list
on each new PR so that everyone is still aware of pending patches via
the mailing list.

Please let me know if you have questions of other suggestions.

As a kernel.org mdadm maintainer, I will keep kernel.org repo and Github
in-sync for both master/main branches. Although they will be kept
in sync, developers should consider GitHub/main effective immediately
after merging this patchset.

I will wait at least one week with merge to gather feedback and resolve
objections. Feel free to ask.

Cc: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: Song Liu <song@kernel.org>
Cc: Kinga Tanska <kinga.tanska@linux.intel.com>
Cc: Jes Sorensen <jes@trained-monkey.org>

Mariusz Tkaczyk (1):
  mdadm: Change main repository to Github

 MAINTAINERS.md | 41 +++++++++++----------------------
 README.md      | 61 ++++++++++++++++++++------------------------------
 2 files changed, 37 insertions(+), 65 deletions(-)

-- 
2.35.3

