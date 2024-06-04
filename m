Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6582484E1C
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 21:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717536936; cv=none; b=SVdA5gsEsS07wFXfKKE2/am5QYqHMxRZYnyuqtR0+v2LBaWfuOq0aXpwurMWAkt4j2UOrzRs4BXcCqvmiMmjTK54UIqUE+WxXG/fVAZ6K41b0o7eKtOLPuPFnyFORU3mdH/bfOKB6/CNmHeZmTsjl+uWXPan43WLr1Faqjg/AjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717536936; c=relaxed/simple;
	bh=U61zcApK/PZtBgFKVzlaOctxHOMRuoRdmrbu7Jb9gz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Msc98uiSFquFGLi1JqYS/+rgUzh1ipJgw9WoAW4oKQVirnEtZT36Ug7tl+qJG3M6kWbjdpk8u9BFk01W4qPsAaVmNonRipZAoLBt22g1hcdCQ+dRfm/d/Jshq3eitDi9vFGNgVouF+OejpmLHFa0f0akotq7utZQMWntbFNjPnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (ip5f5ae801.dynamic.kabel-deutschland.de [95.90.232.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id E9C3661E5FE01;
	Tue,  4 Jun 2024 23:34:40 +0200 (CEST)
Message-ID: <22735c2e-47f6-4fab-b6c7-fcaaf2a12502@molgen.mpg.de>
Date: Tue, 4 Jun 2024 23:34:37 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mdadm 1/2] mdadm: Fix hang race condition in
 wait_for_zero_forks()
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
 Xiao Ni <xni@redhat.com>, Guoqing Jiang <guoqing.jiang@linux.dev>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20240604163837.798219-1-logang@deltatee.com>
 <20240604163837.798219-2-logang@deltatee.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240604163837.798219-2-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Logan,


Thank you for the patch.


Am 04.06.24 um 18:38 schrieb Logan Gunthorpe:
> Running a create operation with --write-zeros can randomly hang
> forever waiting for child processes. This happens roughly on in
> ten runs with when running with small (20MB) loop devices.
> 
> The bug is caused by the fact that signals can be coallesced into
> one if they are not read by signalfd quick enough. So if two children
> finish at exactly the same time, only one SIGCHLD will be received
> by the parent.
> 
> To fix this, wait on all processes with WNOHANG every time a SIGCHLD
> is recieved and exit when all processes have been waited on.

received

> Reported-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>   Create.c | 28 +++++++++++++++-------------
>   1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/Create.c b/Create.c
> index d033eb68f30c..4f992a22b7c9 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -178,6 +178,7 @@ static int wait_for_zero_forks(int *zero_pids, int count)
>   	bool interrupted = false;
>   	sigset_t sigset;
>   	ssize_t s;
> +	pid_t pid;
>   
>   	for (i = 0; i < count; i++)
>   		if (zero_pids[i])
> @@ -196,7 +197,7 @@ static int wait_for_zero_forks(int *zero_pids, int count)
>   		return 1;
>   	}
>   
> -	while (1) {
> +	while (wait_count) {
>   		s = read(sfd, &fdsi, sizeof(fdsi));
>   		if (s != sizeof(fdsi)) {
>   			pr_err("Invalid signalfd read: %s\n", strerror(errno));
> @@ -209,23 +210,24 @@ static int wait_for_zero_forks(int *zero_pids, int count)
>   			pr_info("Interrupting zeroing processes, please wait...\n");
>   			interrupted = true;
>   		} else if (fdsi.ssi_signo == SIGCHLD) {
> -			if (!--wait_count)
> -				break;
> +			for (i = 0; i < count; i++) {
> +				if (!zero_pids[i])
> +					continue;
> +
> +				pid = waitpid(zero_pids[i], &wstatus, WNOHANG);
> +				if (pid <= 0)
> +					continue;
> +
> +				zero_pids[i] = 0;
> +				if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
> +					ret = 1;
> +				wait_count--;
> +			}
>   		}
>   	}
>   
>   	close(sfd);
>   
> -	for (i = 0; i < count; i++) {
> -		if (!zero_pids[i])
> -			continue;
> -
> -		waitpid(zero_pids[i], &wstatus, 0);
> -		zero_pids[i] = 0;
> -		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
> -			ret = 1;
> -	}
> -
>   	if (interrupted) {
>   		pr_err("zeroing interrupted!\n");
>   		return 1;

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
