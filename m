Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337026;
	b=435QrG4F7cCKcm7JGz25vmMJL2EXUpNNh2DqkmMpYI8Hxs08sPriWDCV1D1a6E1SKsWG
	 UlqNsQxg4jnsZD5/jRUA0CtOwxCsEBuMZGHGzl9mnXAv/twZesFmMdwfBEf9/A2d2LwD7
	 mT/NML7OJy1N2t52DiGu1CU5VNq51qHDHj5fExD5RqPUIRblBJe2V/RinqI89B9d7+xHv
	 /ncp6zd3SmjMUaBScdQGRr1DbxVsmOdwLQL1tF9ymB5+ZWXHaL2rVy5o9zrNCjmHhUWHj
	 wOw2tSrhucnRdRVC3RP9pquVpMkmIRiwDU+NgWAEKHPGkjXey8NhRoJ3ZefDp2oyZxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337026;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=nWuN97z/rAeWtI3ymy8fMfPn0ig5oClj8CEhioF55og=;
	b=4rtE6g33yr5LXBLlP21304bpyz2VxoDWeLL8lZqZdZWt2Uw2/V2R8Zcl4DyRvqRzGV+K
	 RYPiy/uCmhgv29z/xWQntFzqRDyxJyzAe/9rj0UGkIZIA0CZARlfbPDsLgipt2belm9Az
	 2fQh3oyUmHH80hGXKVaralQTDtT9JeP9pKlEImT24gUcOmxOU1TeQfYhZ/VoaqE4gExxP
	 3P26hDS1VtFLalYVbZaGofesXTd7XM3rkmrTp9z06ORBRIZdkkxeuYeC9F2tmDYEXygMo
	 Hs3lcsTvvo+i6czOwbpNGkpq9D5VqEGmUf2cunozpBfLpR+GISoEa6prSy9i01nEWjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=iY9GDZMD;
	arc=none smtp.remote-ip=79.135.106.25
Received: from mail-10625.protonmail.ch (mail-10625.protonmail.ch [79.135.106.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FE5606A326
	for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 18:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1FE5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=iY9GDZMD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794337022; x=1794596222;
	bh=nWuN97z/rAeWtI3ymy8fMfPn0ig5oClj8CEhioF55og=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=iY9GDZMDlvmY5masj8bx3X+Ld6NNdoJq5kcghN9W14UU8bVZnkeimM6fs7LQh0s3p
	 +FHFYJb1AMXOzBzTNxASY5Yscnm+oJYqYgkH3THSZ8D8ag5REk1OMqex5o9deNdVQY
	 xH6BeUCUn8W1Qfk/vgrk2wE7IanFhTyFsCEq2zoaBKai2vMenIsuxatszsu7xjCo2w
	 RfmLfmQMzwgwtCpAFantQkG15uKY7hLzJabEhYJwA0xkKMKbWAxpo8L+HRvttrm6/X
	 ZKYcaRLSqzRK0WCSOD5WOby4Z6/dkybOaQ4rt9Y3vqZ7orrmbFtH/0XiRKhU6396Cz
	 XGAa/eakQ9euw==
Date: Tue, 10 Nov 2026 18:57:00 +0000
To: Anton Gavriliuk <antosha20xx@gmail.com>
From: Miroslav Cimerman <mc@raidlab.org>
Cc: linux-raid@vger.kernel.org
Subject: Re: xor_gen() md-raid6 performance improvement
Message-ID: <kfOYfiSxBhKPP6AfAT4Ldakxz9XoxYWIb9PwaaFPdwSLSlyH4xLMQ8RZcGyJ9tcVNa4Dsn_ImlZSec_JEEDS5BCE8SZW3d1qhl7XDl_7pNA=@raidlab.org>
In-Reply-To: <CAAiJnjqRNYW-GzabJfGkbnei6x7fbkvhuOijqx+_Z4MWxua_Uw@mail.gmail.com>
References: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com> <20261110133756.63676-1-mc@raidlab.org> <CAAiJnjqRNYW-GzabJfGkbnei6x7fbkvhuOijqx+_Z4MWxua_Uw@mail.gmail.com>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 9da981ab6cb9cf1fd12d1cbbab5ebd872ca05b5c
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Anton,

Anton Gavriliuk wrote:

> I'm very interested in a high performance md-raid subsystem, to be
> aligned with current PCIe 5.0 and coming 6.0 NVMe SSDs.
> So I'm ready to assist you as much as required.

Thank you, your setup is great.

> But which chunk size should I select, default 512K ?

The default 512K chunk is fine.

> Which kernel should I select ?,
> [...]
> Or 7.4-rc2 ?

7.4-rc2 for both runs, once as it is and once with the patch

I sent you detailed instructions off-list, as they are quite long.

Thanks,
Miroslav
