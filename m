Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E818EFD1
	for <linux-raid@vger.kernel.org>; Fri, 22 May 2026 04:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779423844; cv=none; b=JHd7FpkNDuMV6X7WlYnwKr+W9zwjIfENASgZzOLI88DkLPfgb3SuKB9T+bROT+YgE20zz3lXqkHR+1AXGjDHgqr79DzVs57nKAaddF/x9GBmgLt/w6qAEIiTHp0VByCX6X8pQx2FfmPSv5DiMfYssIpTnbZ+z0elIVx2G9J9tpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779423844; c=relaxed/simple;
	bh=41wQLllRkSTT07fDvVF6oznjhrkdXK+OV1JQH22iYg0=;
	h=To:Mime-Version:Content-Type:Message-Id:In-Reply-To:Subject:Date:
	 Cc:From:References; b=lcPMdvEx6iOsI6TyPo/HuNyGw5tNfXe8wi+lB4+gbmFnaCud5rajZbz8g7/t6Ok0AuGN1MWobXozXzMTlGPF/93sK83nafYSOIw41glgmtvPVkfUdrwiSlGC1tbwUOn1dx5uxB50QALZtcpk5oPbnY6XArJOzizXxLbDhkdqN8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=HQU464Gg; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="HQU464Gg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1779423837;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=41wQLllRkSTT07fDvVF6oznjhrkdXK+OV1JQH22iYg0=;
 b=HQU464GgJiJnktYX2iYT98JOIou7BnBnAJqO5kfcvRSBI279BfFDBjKLkfN44pYWkWIVqZ
 aEersChJdTJj9H+Un2ukwajZyiGozYHfauCsN7SuMTklZu9JC6bKfgjx9LF0Ticf6+fctT
 J9rVVAaTuwCcQxMGumxKDl0c8rDKo2ytrPr4BDNgnUWfDVOsFmE26rfH2h9JU0eMmiLI2V
 feCnipLR4s7ztCfKluYFN9wyELllEtVckRKQMJnc8gWo5IxXsSXzyghWfa0e/8Thx71FgM
 DaXajvgC0OrOfueslgP6I+htQZD4D5e76OZZGzX/SBYxHOahVR4LGrCjLeT8QQ==
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	"Xiao Ni" <xiao@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a0fda5c+735016+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Message-Id: <aab7e7ea-737a-4bc6-a50c-f6ed7b38c37d@fygo.io>
In-Reply-To: <m2pl2pkttv.fsf@gmail.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with md_cloned_bio()
Date: Fri, 22 May 2026 12:23:52 +0800
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.larksuite.com with ESMTPS; Fri, 22 May 2026 04:23:56 +0000
X-Original-From: Yu Kuai <yukuai@fygo.io>
Cc: <song@kernel.org>, <xni@redhat.com>, <neilb@suse.com>, <shli@fb.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
From: "Yu Kuai" <yukuai@fygo.io>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-3-abd.masalkhi@gmail.com> <71990de4-1113-4b7d-8a50-ca1d82802a03@fygo.io> <CAF-RUYVK34e4ShHLd4nYGBdB3yxX4BBkS-woxBnmCuj_6vUisg@mail.gmail.com> <4ff43e8f-6405-4ce8-8cdf-f71e0bce4d3f@fygo.io> <m2pl2pkttv.fsf@gmail.com>
Content-Language: en-US

Hi,

=E5=9C=A8 2026/5/21 17:14, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> The original bio resubmitted via bio_list is not executing in the raid1d
> thread context, so blocking on is_suspended() is correct and will not
> cause a deadlock. The suspension deadlock risk only exists for
> md_cloned_bio executing in the raid1d thread context in the error path.
> And in this case it is always true that if we are executing in the
> raid1d thread context the bio will already be a md_cloned_bio on entry
> to md_handle_request(), even if current->bio_list was set, because (and a=
s
> @Xiao has mentioned) every time we split a bio in the error path we are
> resubmitting the md_cloned_bio remainder, never the original bio.

I do understand this, if original bio or resubmitted bio only split at
raid1_read_request, there is no problem. What I feel is not safe is that
bio can split somewhere else.

This is possible for raid5, However, take a closer look at raid1/10, I
feel it's not possible for resubmitted io to split in bio_split_to_limits.
Even if it happens, it's probably someone else to blame.

--=20
Thansk,
Kuai
