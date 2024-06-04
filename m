Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E6838396
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717518010; cv=none; b=gHPCqyvejG+gbaZCmo6FHXFbvLWcFaGITuvCwaaxOZSqP0QaMCHUi8tDQwEQCyo3zxUP/mFX7w0tchg8g6mRSjLP7m9zhmjdEfttyRdWWGQnI9KzK0C+shQmjgTZ0d5w5239aAE88hog4VTi20IdJhRYkXezG/M19ksvt1ITI6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717518010; c=relaxed/simple;
	bh=8ra0QbTJNmqe7/46/aWaFBhK8CdYaRPaLQUzbh64Z0c=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=HIynV6XNfSYJ9xifMO9YdvS+0gbQpf/Fb1xgQmahZPbCky7Sj7otuqVLjwBd6E1x6q9kuU7L2701C/3I9QMjpLCmNsMSnxATZLwpyelChNSmaM7Rp8odPAYJDGZ5WHxPC32ZcmlmsDQ0Ju6Z1VlgLTbWRzi+Csu4ggAq1msN6qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=VzLXvFNW; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="VzLXvFNW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=FAqDynOTu6A9eGfqSO5dnU3xNYdCWEKR33O0vbm5kRI=; b=VzLXvFNWAJpkRrwNLXdXTtyLJO
	ltb67FTq63H6BjoGEIHTF8wJ9WsT2lVyLdXCvTIxCU9U0wyf6rGjKX99+bbwXnGacNiKlluWmNrBf
	KQ66m2b2eXnrCzSEG9ZrnTbry3B4qeYt/thdZuH9t/iw/Hh9CNCr6cYJXi0gWgTPnDIJiXrUPc8lc
	eMwixTZL/RNd6swY08K5QfOnGT+a8IwF8IPXfS3pW5E9/oq7wl+vu1bMwSUlU4xJqbyHp8izVz4U8
	cDqCe3WVplerQ00adQBEsfTTwCFYNdT9aSvV6U0MG1zBEhBxzZK8JQiYVAUDOhj47cQqk7k4qJP/x
	p2kT+XfQ==;
Received: from [172.16.1.162]
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1sEWtE-000fkB-0p;
	Tue, 04 Jun 2024 10:20:00 -0600
Message-ID: <70ae9c73-ae48-4cc9-9118-e4e74102f090@deltatee.com>
Date: Tue, 4 Jun 2024 10:19:59 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Xiao Ni <xni@redhat.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org
References: <20240528143305.18374-1-mariusz.tkaczyk@linux.intel.com>
 <CALTww28s44pewrDH-w+djGVnUXi97bZD1upESixCZmUDPNKHKQ@mail.gmail.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww28s44pewrDH-w+djGVnUXi97bZD1upESixCZmUDPNKHKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: xni@redhat.com, mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: [RFC PATCH] mdadm: add --fast-initialize
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)



On 2024-06-04 06:46, Xiao Ni wrote:
> Hi Mariusz
> 
> The discard can't promise to write zero to nvme disks, right? If so,
> we can't use it for resync, because it can't make sure the raid is in
> sync state.

Yes, discard requests are a best effort and the drive is free to ignore
some or all of the request. See [1] for more information from Martin
Peterson.

I think if we have a device that has a fast zero operation that we know
guarantees zeroing then the kernel's write-zeros operation should be
changed to use it. We shouldn't make fast-but-dangerous options in mdadm.

Thanks,

Logan


[1] https://lore.kernel.org/all/yq1fsgwbijv.fsf@ca-mkp.ca.oracle.com/T/#u
