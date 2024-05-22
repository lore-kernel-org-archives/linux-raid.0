Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AA26AD7
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716395621; cv=none; b=IHxWytpoHkR/eu+7KhPfdGv7QCZ92H1VYPNGWtJXWiKD+3Fa/osZ2zPB+Ap5HzQBSnInqi6o5mohLw9PrNBZtZR47XQlxnXb3+TCxGdf2LnUeq2L5+TRCF3nlxkvu+RDEM05RdaAQTRCClkHsUpPTF+yD6o/lLSE8gV8bp0ffEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716395621; c=relaxed/simple;
	bh=rLlB/9ygvlbECBLN9Gd9Q6AFI/OcKAuqD+O/CHAS5YI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=TG4z0+qe3cfl+f0Q4DEuLw7gWOHncHEYZODciMSYxvhUn90HZVqTaDYBw+H1kDh9c/H0gckszrsF9bMzuKdpetzw2sDgQ7jfaMNjWuJE8uK+MM0uffDKR81cgrPzsPFVNg+NWOLvauLnIVWp37TImC29d646xIdoZIf0PJqPHAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=GgBiQBdR; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="GgBiQBdR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=6tkCl5rATod80le2AYOgboFQ11GLwOo+SqaTyeDeMYc=; b=GgBiQBdR+NClJeFTZ65biz+p5V
	FgMJH104sp3mKPI6q/r63zAPipAb2TGhdg2VUpPluFyrtOAER0NwYHlawcHxU26kvJ/uphL6xsrkD
	+HzlALuKXKj2r+gnmKZSlwiV7XqddS+qC2ZeRi1oN+E5zXjxlE0IKELzDfqiNlguPC+zks5j9SxTW
	dGyzq34SEmOgKqPKlkzrlcjLEu6xMUj0f1gHiTBpbyWK8KJqvu0J5B1V/YO5hyf4zzxUimZ0skkFY
	U7luv6sIygL3oQVekHAC/+PMIm/4U2QpTgoFKPrGcDqAXPlNbmiP77mG+XIYrWGXlWMDq7gqowu8u
	RSt3e40g==;
Received: from d205-206-125-85.abhsia.telus.net ([205.206.125.85] helo=[192.168.11.155])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1s9ouI-0064EU-1J;
	Wed, 22 May 2024 10:33:39 -0600
Message-ID: <5c0a5fdc-a86c-424d-9f8e-ee881baf82be@deltatee.com>
Date: Wed, 22 May 2024 10:33:37 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
References: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
 <25ea3a8d-6331-476c-8fb4-8932185b3113@deltatee.com>
 <CALTww2-Rm=ORd0QtuWru6qz8VaTY3D-EnjJVQ48uf8gPTSG6Uw@mail.gmail.com>
Content-Language: en-US
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww2-Rm=ORd0QtuWru6qz8VaTY3D-EnjJVQ48uf8gPTSG6Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 205.206.125.85
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: mdadm/Create wait_for_zero_forks is stuck
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2024-05-22 02:46, Xiao Ni wrote:
> Hi Logan
> 
> Thanks for your suggestion. I tried to create signalfd before fork()
> but it still can't work. And I call sleep(2) before child exits, the
> problem still can happen sometimes. This is what I tried. If you have
> time to have a look, it's great. It's not a hurry thing.

Can you send sample prints from this patch? I'm very surprised that with
the delay on the child processes it can still happen.

What do you do to make it happen? How frequently does it occur?


> @@ -185,17 +186,6 @@ static int wait_for_zero_forks(int *zero_pids, int count)
>         if (!wait_count)
>                 return 0;
> 
> -       sigemptyset(&sigset);
> -       sigaddset(&sigset, SIGINT);
> -       sigaddset(&sigset, SIGCHLD);
> -       sigprocmask(SIG_BLOCK, &sigset, NULL);
> -
> -       sfd = signalfd(-1, &sigset, 0);
> -       if (sfd < 0) {
> -               pr_err("Unable to create signalfd: %s\n", strerror(errno));
> -               return 1;
> -       }

Strictly speaking, I don't think it's necessary to move the signalfd
initialization. Blocking the signals should be enough, then any signals
can be retrieved at a later time with signalfd. Though, I don't think it
should hurt to do it this way.

Logan
