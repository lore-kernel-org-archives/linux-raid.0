Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCB272606
	for <linux-raid@vger.kernel.org>; Fri, 28 Nov 2025 02:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764298043; cv=none; b=l3z+fzwcfyTzuEc+OXE9R0YRf5NjUg4+SWLxZ1+cOyOhfcF10e3i0zNAoC5vz5fZz6/14n+7T4pEudvMLDxi1Zx88t2bwJscmd7JonvLEZPXxMCLsUAv8bl0p1ICCa1Pye3DAYx0Xy+1MdC1H91LEjOcawsdh/RS1984vOYs+Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764298043; c=relaxed/simple;
	bh=Ew7jR1uW8GVDxRs9H4KkbJLTCJcJB2XVBTBmG25yjq4=;
	h=To:From:Date:Mime-Version:References:Content-Type:In-Reply-To:Cc:
	 Subject:Message-Id; b=WiXYlPXUaWNlbfSG2LQ3UeGjE/xEKUi82JGpwHfUhxJa82knQ0dMXnmwqkW4+t83FObWE+JoOJFyOPF6DXdWCMuz31N0nC4r0HAU65aDqH7v9WmLj6RbBTYTIrGK2ZebKAZ4yl6jtPJaqL6SgibbitzJkUptQGmrphTbj85QD1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=A2cIKIvk; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="A2cIKIvk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764298029;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ew7jR1uW8GVDxRs9H4KkbJLTCJcJB2XVBTBmG25yjq4=;
 b=A2cIKIvkm4K3TguwLb4Gag+FjREikjYlTagQ8DzUsFCB5t8ii7lxrSvKE6ly+5RRaD3His
 4m2GDB9m/2lirKZnL2iTF9n0vnko2fGmn5smmxiBF8X0rH2Mq1ZRzzMBHuMwJNhRKE7X/a
 Ybnzvh/kXyqkG5lXfYb2PjsK/9VlGMyTlSkpNkPtqDKGYYOfnGBHvIxYGoxuFIJCysxRN+
 Do01r+fahujDS4MFzE79CIJ8r/CsBsQUgbzqyWatUlsM8wha6yuZhGXOsMcQJtFjYkCAcv
 d7XnQ/wqbFb56PN/7nHf2k4drChD9QxysbeYNplzrLoDDANs7vHwL/2kqEbKWw==
To: "Li Nan" <linan666@huaweicloud.com>, <song@kernel.org>, 
	<neil@brown.name>, <namhyung@gmail.com>, "Yu Kuai" <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Fri, 28 Nov 2025 10:47:06 +0800
Organization: fnnas
Content-Language: en-US
X-Lms-Return-Path: <lba+269290d2b+1f5778+vger.kernel.org+yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Fri, 28 Nov 2025 10:47:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com> <20251106115935.2148714-7-linan666@huaweicloud.com> <c4b15e44-bb02-415e-8f7f-75db2ae2edca@fnnas.com> <f2822f91-d48f-a99e-02dc-36c0b4c4b633@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <f2822f91-d48f-a99e-02dc-36c0b4c4b633@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <k@mgml.me>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>
Subject: Re: [PATCH v2 06/11] md: remove MD_RECOVERY_ERROR handling and simplify resync_offset update
Message-Id: <e27da7ea-f800-4fdc-9149-18981c414e2b@fnnas.com>

Hi,

=E5=9C=A8 2025/11/10 20:17, Li Nan =E5=86=99=E9=81=93:
>
> Since the logic behind this change is complex, should I separate it=20
> into a
> new commit?=20

Please separate.

--=20
Thanks,
Kuai
