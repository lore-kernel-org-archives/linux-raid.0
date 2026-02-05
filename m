Received: from sg-1-40.ptr.blmpb.com (sg-1-40.ptr.blmpb.com [118.26.132.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D312149C6F
	for <linux-raid@vger.kernel.org>; Thu,  5 Feb 2026 01:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770255868; cv=none; b=BzzNZq1KbsT2A7Q+UxUjawOwukn3yv2SIAJWLfjnlN85roDXb4+/gZFylk0mkaiXHsGp1UXdp3b8IVfjWyeW0vUY5mYVE4Q9YKibkKOzsQ1b2EDll8ZgXsXHKEZShtq/zI9PJ9dkjvQbOTQvIUMImBF5E7LR1oxIHQCu4giqFJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770255868; c=relaxed/simple;
	bh=IektFtC4gTvjy+Rs7CPa7BexqJB0GmLqvFLhsf2i7wc=;
	h=From:Mime-Version:References:Content-Type:Cc:In-Reply-To:Subject:
	 Message-Id:Date:To; b=Qp5oS4vyJPsPkdzQcsIRU/dNUlxDkVbqp8ITr2p2ozz+qjzl/m1Ua4hpOzObOeionEm+HJu7C/ELEWfuJHNEBc4CeY2pFls6GnZvvRdq0R9wLy/2MHvf88YqW1UTnaE24oaXqrqObg8Aq6wRdgfzPqgxpkXIEijiO/Qu6VtnqkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=U8SzQ0+/; arc=none smtp.client-ip=118.26.132.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="U8SzQ0+/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770255855;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IektFtC4gTvjy+Rs7CPa7BexqJB0GmLqvFLhsf2i7wc=;
 b=U8SzQ0+/BIGSPCgvAenJ5CGa46uOM7fhmouIPTXLHUnxX+u+pU0wBb0+1CbLu/iS8k3YgG
 nFLsNGX26rWmYtTSKWinpmvLRe+NiA6eYgqXcvbi4rLBwwEp9xSOG5BqtHZVgfBjmzkGV1
 ZSEdMxDjkoKnJYqGp5r+njgcXMVltg4+r+mu4VPaYiP1aEol7VGgWYQWUhMuzs9+LHVlo9
 EF46tOJrZZ7bqagMnV3832HLSnua/cnHMnN7KZ33tS+bOhjibYeglURUVI51pgQPg5Kx6j
 V44jK3850jGqzZAcynqL9ELAgADV7SZq9hmggRuktu4JQsyKqIoNt++jYtFk1g==
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260204145912.9463-1-xni@redhat.com> <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com> <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-raid@vger.kernel.org>, "Guoqing Jiang" <guoqing.jiang@linux.dev>, 
	<yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] md/raid1: data corruption with serialization
Message-Id: <744a8650-ac7d-485e-bc65-cde38e2507a0@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 09:44:12 +0800
Reply-To: yukuai@fnnas.com
Date: Thu, 5 Feb 2026 09:44:11 +0800
X-Lms-Return-Path: <lba+26983f5ed+024ea5+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "Xiao Ni" <xni@redhat.com>

=E5=9C=A8 2026/2/5 8:34, Xiao Ni =E5=86=99=E9=81=93:
> I know the reason why it needs serialization for writemostly case. At
> first, I asked the same question if we need to handle overlap if a
> filesystem is on raid. I got the answer from AI, filesystem can submit
> overlap bios simultaneously, maybe it's the reason why
> serialize_policy was introduced? And database is another case which
> can write to raid1 directly without a filesystem. So I started this
> job. If we don't need to consider overlap, why do we need
> serialize_policy? cc guoqing who is the author of serialize_policy
> also.

Please don't just trust answer from AI, filesystem can't submit overlap
bios concurrently. And I already said serialize_policy is for writemostly
case.

And I also said we don't need to consider user manage data on raw disk
and write to same area concurrently, database will not do this.

The reason is not complicated, if you write to the same LBA concurrent,
it's pointless because you don't know what you'll read after that.

--=20
Thansk,
Kuai
