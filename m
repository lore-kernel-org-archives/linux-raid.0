Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3979A17721
	for <linux-raid@vger.kernel.org>; Fri, 26 Apr 2024 06:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714114008; cv=none; b=pVnrbGME9Ohp28K3AL5rmLsFy7cheYdqdG9EZLUWA/lO0yNhDA02Nhtu01kzSMwag4inAujC1Z58iH/cwMfJyOs7Y0c3W03ix2ocxd0+s9ABZUWk9kQenYhSIoDmMpkmAizGUZ/ml0T0OfyPNG/FHXcKjPHNCdjgMdZ+6qiP1nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714114008; c=relaxed/simple;
	bh=I9f33rjzn8ij6lffEED7CmRXPdq2nSd1ZzHNDCsA1S8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GBFIDJ8FTIm66ABOpmR8BQmRLTyQHsfyRehE1U3DCSmKnrJfcqCuaR7XIz72rhjO8SAGNflVz1sMSRlYQ8FZ2HbvI1CRJvTx5vSFRDevSom+51kSIJzudAtPF94YdH36eNTWM6A+KKrIPAkujC7aDA/psQsc1F4/CpXyxSo2f1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (ip5f5aeb7e.dynamic.kabel-deutschland.de [95.90.235.126])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 34F8B61E5FE06;
	Fri, 26 Apr 2024 08:46:19 +0200 (CEST)
Message-ID: <f8044311-765d-4743-8b20-0d68a56044ec@molgen.mpg.de>
Date: Fri, 26 Apr 2024 08:46:18 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/1] Move mdadm development to Github
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, Song Liu <song@kernel.org>,
 Kinga Tanska <kinga.tanska@linux.intel.com>,
 Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
References: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Mariusz,


Thank for bringing this topic up for discussion. Unfortunately, I have 
to reply with negative comments.


Am 19.04.24 um 03:48 schrieb Mariusz Tkaczyk:
> Thanks to Song and Paul, we created organization for md-raid on Github.
> This is a perfect place to maintain mdadm. I would like announce moving
> mdadm development to Github.
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
> Note that Song and Paul are working on a per patch CI system using GitHub
> Actions and a dedicated rack of servers to enable fast container, VM and
> bare metal testing for both mdraid and mdadm. Having mdadm on GitHub will
> help with that integration.

Improved testing sounds good. Thank you. I do not think though, that 
using GitHub is a requirement for that, and there are a lot of bots on 
the Linux kernel mailing list doing this without GitHub.

> As a result of moving to GitHub, we will no longer be using mailing list
> to propose patches, we will be using GitHub Pull Requests (PRs). As the
> community adjusts to using PRs I will be setting up auto-notification
> for those who attempt to use email for patches to let them know that we
> now use PRs.  I will also setup GitHub to send email to the mailing list
> on each new PR so that everyone is still aware of pending patches via
> the mailing list.

In my experience, using GitHub for code review is far inferior to using 
mailing lists or Gerrit. First, you cannot comment on the commit 
message. As a result, projects using GitHub have a really low-quality 
git history. Also, you only cannot comment single parts of a line in the 
diff.

The “one thread” discussion model is also a pain, as most people using 
Web forms do not correctly cite and quote, and with more than three 
answers you loose the overview. For some reason people think more about 
their reply, using mailing lists than Web forms.

Using different forums for discussions should also not be allowed. 
People should just subscribe and monitor one forum.

So, I strongly oppose this move, but I am also aware, that I am not 
doing a lot of development contribution.


Kind regards,

Paul
