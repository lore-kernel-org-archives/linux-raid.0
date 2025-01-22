Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105461BD9DD
	for <linux-raid@vger.kernel.org>; Wed, 22 Jan 2025 12:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737547303; cv=none; b=s3NjrlwdfDePmnpUGyy1J9LH1hwiHPkbzcqDw8v04fb4fgCXw+P6duCFBCWhdYZyQ4mVC4Vva3WoVmdKNsvH2gbjSqEHwsX2mSQAZjmY3ZGStHJbqbOy31FNjcIeFr1lflp29YHFLyFevc2Pekbens3mkCrjV63mhGiA2t3yTKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737547303; c=relaxed/simple;
	bh=llA0CAg3JmjAMK7eva2v8LehnU+gi+/cD2F4uPM7ZQg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N/N27ex5MuYFUNQPCQXdBqUDuejkstmgZHmCtr9eVV8eZTbTlVV93zxBhWme9o4JZRlkl35hKNQJW+R3Uv6JwUjwFP6mG4CMZQablzBbppr4l22/4cPeypI+FVEKtVeDgxwKPqdNI+hCWy88J9tTRmM9Hqe/nJgK2Tm63SOrCWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id E106FC4CED6;
	Wed, 22 Jan 2025 12:01:40 +0000 (UTC)
Date: Wed, 22 Jan 2025 13:01:36 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2]  mdopen: add sbin path to env PATH when call
 system("modprobe md_mod")
Message-ID: <20250122130136.04011312@mtkaczyk-private-dev>
In-Reply-To: <20250122035359.251194-1-colyli@suse.de>
References: <20250122035359.251194-1-colyli@suse.de>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Coly,
I read that once again and I have more comments. Even if it
looks simple, we are calling many env commands in mdadm, that is why I'm
trying to be careful.

On Wed, 22 Jan 2025 11:53:59 +0800
Coly Li <colyli@suse.de> wrote:

> During the boot process if mdadm is called in udev context, sbin paths
> like /sbin, /usr/sbin, /usr/local/sbin normally not defined in PATH

normally defined? Please remove "not".

> env variable, calling system("modprobe md_mod") in
> create_named_array() may fail with 'sh: modprobe: command not found'
> error message.
> 
> We don't want to move modprobe binary into udev private directory, so
> setting the PATH env is a more proper method to avoid the above issue.

Curios, did you verified what is happening to our "systemctl" calls?

mdmon and grow-continue are started this way, they are later followed by
"WANTS=" in udev rule so the issue there is probably hidden, maybe we
should fix these calls too?
 
> 
> This patch sets PATH env variable with
> "/sbin:/usr/sbin:/usr/local/sbin" before calling system("modprobe
> md_mod"). The change only takes effect within the udev worker
> context, not seen by global udev environment.

If we are running app from terminal (i.e mdadm -I, or ./mdadm -I) this
change should not affect the terminal environment. I verified it to be
sure. Could you please mention that in description?

> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
> Changelog,
> v2: set buf[PATH_MAX] to 0 in stack variable announcement.
> v1: the original version.
> 
> 
>  mdopen.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mdopen.c b/mdopen.c
> index 26f0c716..65bd8a1b 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -39,6 +39,17 @@ int create_named_array(char *devnm)
>  
>  	fd = open(new_array_file, O_WRONLY);
>  	if (fd < 0 && errno == ENOENT) {
> +		char buf[PATH_MAX] = {0};
> +
> +		/*
> +		 * When called by udev worker context, path of
> modprobe
> +		 * might not be in env PATH. Set sbin paths into PATH
> +		 * env to avoid potential failure when run modprobe
> here.
> +		 */
> +		snprintf(buf, PATH_MAX - 1, "%s:%s", getenv("PATH"),
> +			 "/sbin:/usr/sbin:/usr/local/sbin");

We can get NULL returned by getenv("PATH"), should we handle it? We
probably rely on compiler behavior here.

I did simple test. I tried: printf("%s\n", getenv("NOT_EXISTING")); 
I got segmentation fault.

> +		setenv("PATH", buf, 1);

I see here portability issues. We, assume that these binaries must be
in locations we added here. We may even double them, if they are
already defined.
Even if I know that probably no one is enough brave to
not have base binaries there, we should not force our PATH. I think it
is not our task and responsibility to deal with binaries location
issues. We should take what system provided.

I still think that we should pass locations during compilation. Here
example with EXTRAVERSION, of course it may require some adjustments
but it is generally the way it can be achieved:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=03ab9763f51ddf2030f60f83e76cf9c1b50b726c

I'm not strong convinced to the option I proposed, I just need
argument because more or less code is not an argument. What we will
choose today will stay here for years, we need to choose the best
possible way we see.

> +
>  		if (system("modprobe md_mod") == 0)
>  			fd = open(new_array_file, O_WRONLY);

>  	}

The change will affect code executed later, probably we don't want
that. Shouldn't we restore old PATH here to minimize risk?

Thanks,
Mariusz
