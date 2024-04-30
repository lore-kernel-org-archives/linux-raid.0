Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B52A12C7FA
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474249; cv=pass; b=OHj4u6m+M0KNs+yoFk9gwG1Lkj0FsEbxqEst65ufFWaU/RJpcxM/omGWEMcJHCXX64oIloH9MN1MT1CJSD9DgWIriBFSPj7rsea0Ybp/TVCb+B19JWgSLmgSoo3k6n38/K/Oqawe0yv+UiS1yGiKIVHiSWZE713PFg+Nq/27r/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474249; c=relaxed/simple;
	bh=pDFJG+pyAI4P+SYMRAeyqrybGY7MyfaXkaxOBsJNFds=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=C3DeDyQD4wylcUT+difYMR9ENT7lMbh+Vh/pGMAMi3LuqH50PWKf7WFtgat4z1BbNKnjxjnErPY99cnpZs193TyF13+v15Ro1Ntk2/vSaMAIQGT/iAOdMyIXezTyeK8kmlMBzy6EBXhWlUaL0KQI/yCR+wF1R9L9/L2H+OQRgeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trained-monkey.org; spf=pass smtp.mailfrom=trained-monkey.org; arc=pass smtp.client-ip=136.143.169.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trained-monkey.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trained-monkey.org
ARC-Seal: i=1; a=rsa-sha256; t=1714474215; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=izBZJiCTiRz0lp37BxUZWyOLJp8Al53pocETkquCPJKF3Akls/1Wn/Ll5wKPT7xVfxw5n9EzL+rHHk0+W2zbzONWip8ipMeGWXCMFUI2gZRrUl4jvCLNuPzw9WpbFTFQq4Bbh/lmk1y498SPH+LEmk8Ebd5HhIwWE/qWZk+YPMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1714474215; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=V6Ubs9biXvNTvOUavOpXJ1FY823weETiIrQ5I/udeXI=; 
	b=IDFxyzR9GNN1ivsJUiIMOHm9zk9pnz9r32GkK5xTs1KF7pH6kwLgVb9Y/1dBfL6H1p7KgU0G2Smxp9duYHFDmsX0k0N/YYF3V4b5rCgE0qYdaKi0jJS3EfrxKeZQoJBvQQa3mG2GOq8AENAWZjzFToTp76xjNuJwixl9oCorKos=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	spf=pass  smtp.mailfrom=jes@trained-monkey.org;
	dmarc=pass header.from=<jes@trained-monkey.org>
Received: by mx.zoho.eu with SMTPS id 1714474213253341.1084052814888;
	Tue, 30 Apr 2024 12:50:13 +0200 (CEST)
Date: Tue, 30 Apr 2024 06:50:07 -0400
From: Jes Sorensen <jes@trained-monkey.org>
To: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: linux-raid@vger.kernel.org,Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,Song Liu <song@kernel.org>,Kinga Tanska <kinga.tanska@linux.intel.com>
Message-ID: <1adb4478-9d07-4e66-b956-5448950cb667.maildroid@localhost>
In-Reply-To: <20240428194743.2704462f@peluse-desk5>
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
 <96eee057-941f-48dc-8aad-c74039c0b1fe.maildroid@localhost>
 <20240428194743.2704462f@peluse-desk5>
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

Sorry for the obnoxious top posting, not near a computer right now. 

This was not meant as a signed-off-by, but rather I'm signing off the project. 

Good luck 

Sent from MailDroid

-----Original Message-----
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Jes Sorensen <jes@trained-monkey.org>
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Song Liu <song@kernel.org>, Kinga Tanska <kinga.tanska@linux.intel.com>
Sent: Mon, 29 Apr 2024 23:40
Subject: Re: [PATCH 0/1] Move mdadm development to Github

On Mon, 29 Apr 2024 22:52:46 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> Disappointed to see this :(
> 
> The github interface is not a favorite. Mailing lists are the way
> open source projects work.
> 
> I haven't had much time to contribute for quite a while now and
> probably won't in the near future. Given this decision was made
> without my involvement, I'll sign off.
> 
> Jes 
> 

Applaud the decision to 'sign off' despite personal preferences. I am
confident if things start going in the wrong direction that Mariusz
will course correct accordingly.

Thanks Jes :)

-Paul

> 
> -----Original Message-----
> From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> To: linux-raid@vger.kernel.org
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Paul E Luse
> <paul.e.luse@linux.intel.com>, Song Liu <song@kernel.org>, Kinga
> Tanska <kinga.tanska@linux.intel.com>, Jes Sorensen
> <jes@trained-monkey.org> Sent: Fri, 19 Apr 2024 5:39 Subject: [PATCH
> 0/1] Move mdadm development to Github
> 
> Thanks to Song and Paul, we created organization for md-raid on
> Github. This is a perfect place to maintain mdadm. I would like
> announce moving mdadm development to Github.
> 
> It is already forked, feel free to explore:
> https://github.com/md-raid-utilities/mdadm
> 
> Github is powerful and it has well integrated CI. On the repo, you can
> already find a pull request which will add compilation and code style
> tests (Thanks to Kinga!).
> This is MORE than we have now so I believe that with the change mdadm
> stability and code quality will be increased. The participating method
> will be simplified, it is really easy to create pull request. Also,
> anyone can fork repo with base tests included and properly configured.
> 
> Note that Song and Paul are working on a per patch CI system using
> GitHub Actions and a dedicated rack of servers to enable fast
> container, VM and bare metal testing for both mdraid and mdadm.
> Having mdadm on GitHub will help with that integration.
> 
> As a result of moving to GitHub, we will no longer be using mailing
> list to propose patches, we will be using GitHub Pull Requests (PRs).
> As the community adjusts to using PRs I will be setting up
> auto-notification for those who attempt to use email for patches to
> let them know that we now use PRs.  I will also setup GitHub to send
> email to the mailing list on each new PR so that everyone is still
> aware of pending patches via the mailing list.
> 
> Please let me know if you have questions of other suggestions.
> 
> As a kernel.org mdadm maintainer, I will keep kernel.org repo and
> Github in-sync for both master/main branches. Although they will be
> kept in sync, developers should consider GitHub/main effective
> immediately after merging this patchset.
> 
> I will wait at least one week with merge to gather feedback and
> resolve objections. Feel free to ask.
> 
> Cc: Paul E Luse <paul.e.luse@linux.intel.com>
> Cc: Song Liu <song@kernel.org>
> Cc: Kinga Tanska <kinga.tanska@linux.intel.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> 
> Mariusz Tkaczyk (1):
>   mdadm: Change main repository to Github
> 
>  MAINTAINERS.md | 41 +++++++++++----------------------
>  README.md      | 61
> ++++++++++++++++++++------------------------------ 2 files changed,
> 37 insertions(+), 65 deletions(-)
> 


