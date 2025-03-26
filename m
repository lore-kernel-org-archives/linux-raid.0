Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0731E51D
	for <linux-raid@vger.kernel.org>; Wed, 26 Mar 2025 12:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742993317; cv=none; b=TUfcUmi2cC96hibB+5MiG6tyuvAdJO8S9I59X+9TS1VdOmktF641DDVvrFQNlnHvTKevdAcROaEzfnWxjImYbcQSctaFFtbR5/MH8c20xT34eawAS1+H7HGWTos5s7qxrV5NgioYGOie1TilXaIui8EYY4sXMl75z/YMbyb/RrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742993317; c=relaxed/simple;
	bh=8M3Q4c92T5BEhje3n/12MhA8tfI8pEANLNhdCKis0Ak=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KJspw2OVihzcst3BO6+9bNeYLDQOObXSQ3kT3SOQnoU0UwHYPxEfblSU5VADsnBD5jzmRNqJU1YaGAqtRrjoaO0a2JMbwFKi+dwdsWanpnIyv8dOYkBeGTq0NsC8BQHpePQELjxKuX3peRzdoZF3znXyLQlz7JTSufHsDOokr10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 0ACC5C4CEE2;
	Wed, 26 Mar 2025 12:48:34 +0000 (UTC)
Date: Wed, 26 Mar 2025 13:48:21 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Nigel Croxon <ncroxon@redhat.com>
Cc: linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com, Xiao Ni
 <xni@redhat.com>
Subject: Re: [PATCH] mdadm: Incremental mode creates file for udev rules
Message-ID: <20250326134821.305ab2d8@mtkaczyk-private-dev>
In-Reply-To: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
References: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
Organization: Linux development
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Mar 2025 15:18:00 -0400
Nigel Croxon <ncroxon@redhat.com> wrote:

> Mounting an md device may fail during boot from mdadm's claim
> on the device not being released before systemd attempts to mount.
> 
> While mdadm is still constructing the array (mdadm --incremental
> that is called from within
> /usr/lib/udev/rules.d/64-md-raid-assembly.rules), there is an attempt
> to mount the md device, but there is not a creation of
> "/run/mdadm/creating-xxx" file when in incremental mode that the rule
> is looking for.  Therefore the device is not marked as
> SYSTEMD_READY=0  in "/usr/lib/udev/rules.d/01-md-raid-creating.rules"
> and missing synchronization using the "/run/mdadm/creating-xxx" file.
> 
> Enable creating the "/run/mdadm/creating-xxx" file during
> incremental mode.

Hi Nigel,
The code is rather simple but the change is big. Before I will consider
it is safe to merge please describe the particular scenario you are
fixing.
It is known, persistent issue? Is is sporadic issue?

In the commit message please add why you think it is safe change.

This will affect every environment. We need to be certain that it will
not bring regression in booting flow. It might be hard to debug and
have big impact on users.

Thanks,
Mariusz

> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   Incremental.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
