Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C4310F1
	for <linux-raid@vger.kernel.org>; Tue, 31 Dec 2024 08:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735635006; cv=none; b=IsNpkIM9PTJi2r8m55wFMfnKctMsPrBQVYkOa9GcjvKjZEcXJxy7EUw4ucbLDxrhXJIKtdDDKqWFNWdbQcUbHQzWByomKSblp+VNEj2dq8Z6FrpzY4Pkg+PRDexfkW6ZNo+fVO0CAPtpLaNmU7dpvxwGXPPKLmtU8yWBEjnI4Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735635006; c=relaxed/simple;
	bh=d1BYAL5whq49GGX0KmDTnbSXMfgUVBhRsO9LfTjJ9xc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gmm97aze5fqcsPruUQXIELECU+q+jcAtiKl38OvWdWAzez8OxLVC53jwn4tdXd6p5/bqDFZpvqV/jTZ8JczrQsrjl9UEmgrGpfqjryUD+WthxjuRbpDb4k8bVX9D9DSBpYnu2HjsGdRztmBYKs2uCVEbL45pEnoJv7gfWFGMLN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id C9BF5C4CED6;
	Tue, 31 Dec 2024 08:50:03 +0000 (UTC)
Date: Tue, 31 Dec 2024 09:49:52 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, yukuai3@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH] mdadm: fix --grow with --add for linear
Message-ID: <20241231094952.1fad40bb@mtkaczyk-private-dev>
In-Reply-To: <20241227060702.730184-1-yukuai1@huaweicloud.com>
References: <20241227060702.730184-1-yukuai1@huaweicloud.com>
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

On Fri, 27 Dec 2024 14:07:02 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> For the case mdadm --grow with --add, the s.btype should not be
> initialized yet, hence BitmapUnknown should be checked instead of
> BitmapNone.

Hi Kuai,

For commit extra clarity it would be nice to include command you are
executing.

What if someone will do (not tested):
#mdadm --grow /dev/md0 --add /dev/sdx --bitmap=none

I think that it is perfectly valid, now it may work but I expect your
change to broke it.

I would say we need:

bool is_bitmap_set(struct shape *s) {
	if (s.layout)
		return true;
	if (s.btype == BitmapNone || s.btype != BitmapUnknown)
		return false;

	return true;
}

And respect both cases. Setting property to default should never be a
mistake.

Has it some sense? If no, I miss some explanation in commit message (or
better comment).

> 
> Noted that this behaviour should only support by md-linear, which is
> removed from kernel, howerver, it turns out md-linear is used widely
> in home NAS and we're planning to reintroduce it soon.

Wow. We get a lesson.

For the code, LGTM.

Thanks,
Mariusz
