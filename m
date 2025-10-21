Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2B323EA85
	for <linux-raid@vger.kernel.org>; Tue, 21 Oct 2025 12:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761048548; cv=none; b=Csc0PNA5Vvo4TXVYp/0/tlMvmM04un1vvY5LgRF6ivya1OM3HX+a0nmNxqwrIzIdgNpyzjpEnNoCFdl24Yi+dneISM7DlHy7AsYkjtxigSWuRZvHZN/8BOQrJh7agk4+qOvgtULqqrOWjAjFjvZFhC5+h/TbJjlpPCFr9BvcGrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761048548; c=relaxed/simple;
	bh=wgkOfvlqSNdBuPu/1WmNPh+eaU8BrrhZDKrLFBVcgj0=;
	h=Cc:Date:In-Reply-To:Content-Type:To:Subject:Message-Id:From:
	 Mime-Version:References; b=FxGcQUoyNRFVyL6MOWO65MFq/GztFHHb5Ubh3/+qCFzQ+z4XgE01TG73Awtm17MoNDWT7aqjK5xUcBVdz530qL9yDRpEdXMWEq0vWxtOeTBnCNp/8vyB0kDItGtSuLjCmTgxsN+tE7bC9e6pf363XLj7Xsuas/+HvjusLwwFqkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AcTFyKDC; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AcTFyKDC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761048495;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1g1r/N1c+lkRWJdlqy/BPelfKGoo8jx3BLf+YblwvIU=;
 b=AcTFyKDChbuMGdGUZstrd6SMoj8gqH2bp68Sr60gWPzSdEsyefyQitk2Btio2j5i494MPr
 KvxVrZYP20uzQggpSxc+KO8ZC3AP3fpkROkFqXR5SKl6vZmYF/NOS5TGQRouyZTQUMaA9c
 X5nf5DY4WgPtIAAP0DsWylqsikXnZrfaL0FZamcYRNzKdq2+rHnaELGtmg+Sj+RLGMxC/y
 3YAUr3MdvRl22r43JTkbfrPjvqbeq8+/341Gb/4TC9QYqle/EGet4zN89TZEy5GMKK0fpK
 /euYroLag04hOTpQjpl++x861g0cp8bbm5Y4ljPRBU4uurv9IHsbCwRdvtAQfQ==
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2025 20:08:11 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251015083227.1079009-1-yun.zhou@windriver.com>
Organization: fnnas
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.169]) by smtp.feishu.cn with ESMTPS; Tue, 21 Oct 2025 20:08:12 +0800
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+268f777ad+e166b9+vger.kernel.org+yukuai@fnnas.com>
To: "Yun Zhou" <yun.zhou@windriver.com>, <song@kernel.org>
Subject: Re: [PATCH] [v2] md: fix rcu protection in md_wakeup_thread
Message-Id: <1f8046dd-289d-488e-af86-5eee3b90e63e@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251015083227.1079009-1-yun.zhou@windriver.com>

Hi,

=E5=9C=A8 2025/10/15 16:32, Yun Zhou =E5=86=99=E9=81=93:
> We attempted to use RCU to protect the pointer 'thread', but directly
> passed the value when calling md_wakeup_thread(). This means that the
> RCU pointer has been acquired before rcu_read_lock(), which renders
> rcu_read_lock() ineffective and could lead to a use-after-free.
>
> Fixes: 446931543982 ("md: protect md_thread with rcu")
> Signed-off-by: Yun Zhou<yun.zhou@windriver.com>
> ---
>   drivers/md/md.c | 14 ++++++--------
>   drivers/md/md.h |  8 +++++++-
>   2 files changed, 13 insertions(+), 9 deletions(-)

Sorry for the delay.
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
