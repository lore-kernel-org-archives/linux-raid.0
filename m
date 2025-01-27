Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ABF126BEE
	for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 09:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737969263; cv=none; b=b/9CuPY08Vq/mEAiBuKDgd2ZkbvjcYzh5JNmZotcBv0eY9bMakhKZaAZTuFKO6erq9UIFNZWDVDfofLIGaA2939idfyB9nSb2pSWw9aMO2BTi3woVEsYjSE1osHCZdXWe/2HRS8ndz870a6rqmr0Pg62drb5d1CGVEgtCiT4PF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737969263; c=relaxed/simple;
	bh=2GlFZCHvGxGmVyF2v30dRvuVuUFeEACPjeoo4W70kfM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZBhVG6JuCPulmdETHczN56yanUYyKGsXZxo5zNyHxaIn4FmR0bzOLHh9vadFXLIQRSEwQ2rxl33Db3C7tCgXrAXdR6tezhRnTGK4CNgoXlQgy3mBVZJIjxb/5z5g1RSNS/xt65dBzCSGpbbNZcZxpIRik0O+P5EsC+1RBfAblo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 9202DC4CED2;
	Mon, 27 Jan 2025 09:14:21 +0000 (UTC)
Date: Mon, 27 Jan 2025 10:14:17 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v3]  mdopen: add sbin path to env PATH when call
 system("modprobe md_mod")
Message-ID: <20250127101344.215b2aff@mtkaczyk-private-dev>
In-Reply-To: <20250122151859.254365-1-colyli@suse.de>
References: <20250122151859.254365-1-colyli@suse.de>
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

On Wed, 22 Jan 2025 23:18:59 +0800
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
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
> Changelog,
> v3, check return value of getenv().
> v2: set buf[PATH_MAX] to 0 in stack variable announcement.
> v1: the original version.
> 

Applied!
Thanks,
Mariusz
