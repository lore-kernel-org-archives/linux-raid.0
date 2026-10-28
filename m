Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793196054;
	b=inZfCCTlvaWLq4Z/AfgVVUxJQAbWrmkzvu7MLvNckTQ42ew0vbxmEsL11TDzCn8icVbH
	 mhl0ypmkkNNKbODGTTKwsEZxUUe+h3YDWlWOFBQalR0BZH3rHks1HS+ufDYnhvHTHISx8
	 hr1bH2EcJAfE2GsSgijOKRSsELlUkvDHP88RDffL0V5BpMS5EEFzoz0XyYNnen5AEZIiU
	 Ls8L/ecDH59yl1ZJJm/6mrXz+YRgHCwWPUUYUarmXo1Yx5y8itrMjbX/6BuZbvWv2jskj
	 MNYmLkUUyynVRpW6FDJ5LkxZ3C3zjPYhu26MZ2/sJ8fi2ch85BwZhkO19AGnkwG266Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793196054;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:Organization:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=7+8OzeElXOyZSKo9X6RoqssnxLoRveWxh9jJViIAeZs=;
	b=P21q48krQvNymlO1roS1K8ygXIvkZRa4QNkpONfoxe+41XaRhqy+QRI25HPy/WylwfsN
	 w+/ZlukpF2K3GW0Kb7aCKbittLWW8QBaVKUWx58mWFxHiaiFcK92v5EGJ3Fns/XGF5wmo
	 FafreoHCWmK7A/GLN7TEdsIPu7LzNiFLayEVDw2p2UKPZ6X2586oohzMPVwfcbFavIceK
	 H9d/FQdBS6CQaU3IUyLhwgrugwRhk3Nv5+CoyDTQeEpqFhzbafGDmdEnWg7R/z2UbtabP
	 Ed8rL+kpKkD41OVH76fE26f3Ej3S5/az8g9eGmP17iKbp2F58gjFePRL1i+fBIAlB2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G0dzzEbp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41323606A31A
	for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2026 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G0dzzEbp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A2F1F01825;
	Wed, 28 Oct 2026 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196053;
	bh=7+8OzeElXOyZSKo9X6RoqssnxLoRveWxh9jJViIAeZs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=G0dzzEbpMV/vlegZSYJ5iDxX6PfR67Wi4G8SiBNSoaYSzYBUoMQYECUIJWJl7c4gS
	 GdxyfOZE3YqnKHTAD1tDnLjqouRJ6+XNgrBowi2Do0QsefEnT3p2JRPX90oTHqK+6r
	 jssPz4xm8HHcrgGJxHnxm6w8c2jHC7qbhEF2Vv212Uyzvy9DZeCcEen874y3DwLEfd
	 RAu3PcEBPUoHkraXdg3FLyj726hHffTjWQPFNzGaaysq9gRTiPXp8+l5wfWmgjUH70
	 9toxg7PkNr9W01K9M90tgOjIhf5wrVO21JehLt/HRVtpIoCUSg+sQnbF54rDOZ8ZmS
	 uR5B+Z26JkP+Q==
Date: Wed, 28 Oct 2026 15:00:47 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu>
Cc: "blazej.kucman@graidtech.com" <blazej.kucman@graidtech.com>,
 "ncroxon@redhat.com" <ncroxon@redhat.com>, "xni@redhat.com"
 <xni@redhat.com>, "song@kernel.org" <song@kernel.org>, "yukuai@kernel.org"
 <yukuai@kernel.org>, "linux-raid@vger.kernel.org"
 <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] mdadm: Deprecate the obsolete --auto-detect option
Message-ID: <20261028150047.688d2120@kernel.org>
In-Reply-To: <m25wym2diq.fsf@gmail.com>
References: <20261015130326.442915-1-abd.masalkhi@gatech.edu>
	<20261028100317.3b964788@kernel.org>
	<m25wym2diq.fsf@gmail.com>
Organization: Linux Development
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.50; x86_64-suse-linux-gnu)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Oct 2026 12:52:30 +0000
"Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu> wrote:

> Hi Mariusz,
> 
> On Wed, Oct 28, 2026 at 10:03 +0100, Mariusz Tkaczyk wrote:
> > On Thu, 15 Oct 2026 13:03:59 +0000
> > "Masalkhi, Abd Alrhman" <abd.masalkhi@gatech.edu> wrote:
> >  
> >> From: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>
> >> 
> >> --auto-detect opened md0 (9:0) and issued the RAID_AUTORUN ioctl to
> >> ask the kernel to start the arrays it had auto-detected. The kernel
> >> removed this ioctl in commit d82fa81c2364 ("md: replace the
> >> RAID_AUTORUN ioctl with a direct function call"). Before that, it
> >> worked only when md was built into the kernel. Since then,
> >> md_ioctl()  
> >
> > Redhat still builds-in md into kernel so there is chance that
> > someone is using it.
> >
> >  
> >> has rejected it with ENOTTY, making --auto-detect ineffective on
> >> current kernels.  
> >
> >
> > Hello,
> > Do you mind to submit github PRs for mdadm patches?
> > https://github.com/md-raid-utilities/mdadm
> >  
> 
> Sure, I will submit the next version as a GitHub pull request.
> 
> One question, should I also send the RFC patches for updating mdadm to
> use the new UAPI to the mailing list, or is submitting GitHub PRs
> sufficient?


In this particular case there is nothing interesting we are going to do
with kernel or any problem that needs to be coordinated with kernel.
Just take new UAPI and use it once is available so I don't think kernel
list messaging is needed.

I forgot to say, the problem you are challenging is very legacy. With
proposed change, we will not need to open the device and generate
unnecessary events (and problems) anymore! I'm glad to see someone
working on it.

Mariusz
