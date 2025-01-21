Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FE41F76D8
	for <linux-raid@vger.kernel.org>; Tue, 21 Jan 2025 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482978; cv=none; b=ZdAukUMOCDe0gqetw7tXGjaiZsSqfeBiuESPK1C1Bjmim4dyC0++ta6LacwR+L+yWa8vup9bR67vUyDDs/EaiBvdEaj2LCbv03zCR26cJAH5yCs0vTr9WqpGCRXzO2OLgM+udaalzAqJew7io4gN94VbLmjsoz37K6E/teXiwos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482978; c=relaxed/simple;
	bh=LgCALw6hGZpr2nGD7Dyj58u2pQ5beZpBmekQKiWtLRU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C66Mn3Nzk02DCmO9OVlJ2tlotF2iprk8Ve+agQ9/Y0T/Mmk0r+gcgE4MbmqvQBmiQe9vLKBEzEbNeT5ZiEWZuAzc3FNpQlJF+OzDhKaWtLGOn/oO3Jgvhn/nhAPXBEUrSGHQ2tJhQKzo2qDfegvIU6KD+Fvm3EH6TBpbB2HR7VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id A5C5BC4CEE1;
	Tue, 21 Jan 2025 18:09:36 +0000 (UTC)
Date: Tue, 21 Jan 2025 19:09:25 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] mdopen: add sbin path to env PATH when call
 system("modprobe md_mod")
Message-ID: <20250121190925.0700621b@mtkaczyk-private-dev>
In-Reply-To: <20250121151603.235606-1-colyli@suse.de>
References: <20250121151603.235606-1-colyli@suse.de>
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

On Tue, 21 Jan 2025 23:16:03 +0800
Coly Li <colyli@suse.de> wrote:

> During the boot process if mdadm is called in udev context, sbin paths
> like /sbin, /usr/sbin, /usr/local/sbin normally not defined in PATH
> env variable, calling system("modprobe md_mod") in
> create_named_array() may fail with 'sh: modprobe: command not found'
> error message.
> 
> We don't want to move modprobe binary into udev private directory, so
> setting the PATH env is a more proper method to avoid the above issue.
> 
> This patch sets PATH env variable with
> "/sbin:/usr/sbin:/usr/local/sbin" before calling system("modprobe
> md_mod"). The change only takes effect within the udev worker
> context, not seen by global udev environment.

Hi Coly,
Nice explanation, thanks!

> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  mdopen.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mdopen.c b/mdopen.c
> index 26f0c716..30cf781b 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -39,6 +39,18 @@ int create_named_array(char *devnm)
>  
>  	fd = open(new_array_file, O_WRONLY);
>  	if (fd < 0 && errno == ENOENT) {
> +		char buf[PATH_MAX];
> +
> +		/*
> +		 * When called by udev worker context, path of
> modprobe
> +		 * might not be in env PATH. Set sbin paths into PATH
> +		 * env to avoid potential failure when run modprobe
> here.
> +		 */
> +		memset(buf, 0, PATH_MAX);

just:
char buf[PATH_MAX] = {0};

> +		snprintf(buf, PATH_MAX - 1, "%s:%s", getenv("PATH"),
> +			 "/sbin:/usr/sbin:/usr/local/sbin");
> +		setenv("PATH", buf, 1);

Isn't it over-complicated? Why not simply:
system("/sbin/modprobe md_mod");

If modprobe is not always in /sbin (checked on my opensuse only)
we can make in configured during compilation, simple call `which
modprobe` should do the job.
What do you think?

Thanks,
Mariusz
