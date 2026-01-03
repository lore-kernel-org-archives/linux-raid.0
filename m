Received: from sg-1-39.ptr.blmpb.com (sg-1-39.ptr.blmpb.com [118.26.132.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D5A2FDC40
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 11:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767438827; cv=none; b=Y6Dukg00LLiZx5kkM6fEfd/1qST3d+8AzZFJvi9dbRIBUcufZMKF3KCnPiLOhuCBC3IZ7KpCo1sl8slXBF4F/FzWjVXPfdD7VHSjqsdh4FrC7KGFE3sMQzOhj6uvMbi5IpCbdmHanq4O+4vFWfHRzKgVY+/1/LjWFilOJw/90CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767438827; c=relaxed/simple;
	bh=cCI+kOn447njNKYv21b7uqTvlbL4IxjvXDQFYvfPzDk=;
	h=Cc:Mime-Version:Content-Type:References:In-Reply-To:To:Message-Id:
	 Subject:From:Date; b=enAPjsdNPgE5l2JI2plxMZqbbDcR43JVuYCW4rlnddZ4R3QPXEDiCbkgKITz97TNUK6dYHPIuBHX8ZF+qqwvoSQ+WpA5hRF9P0sp9LFG/inZGT0/52E7y+xXPUEOhkp+7Sl8eoPryxpmucPs7eTnntbHPELLVtC9mdVijlWKvds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=DGiYP+rW; arc=none smtp.client-ip=118.26.132.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="DGiYP+rW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767438822;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=cCI+kOn447njNKYv21b7uqTvlbL4IxjvXDQFYvfPzDk=;
 b=DGiYP+rW4Xqe7pMbc+MYqqneMQz5Wx8kQGWdPVWp8PFNw8KUl7NgihZ0sh317or4ZddOwi
 xVbTor2G5oz8+Pim+531u46lPK9foiajCW6469lKEIJiUa/JfpKHQMqLnILmf3DYCnDSZp
 VcLLRuJaU8J/0RLcPOTcEAGhYr9RbqCUHOdJUF+paUAqb+JnQv5XuuWUZYYnBMsyIDL45V
 kXK+I1D8AH5KileisGdflhm/Yq6lxZHcihTtxgj+V1pvElZ6jtjFmgmIALXH+fxEHW2kbg
 UR9laSP+3jaRcNqNftaYy7xH3ShDSq6nJ+Zb+Ya+s/MZXRk9m6Kp67ARbmLtDw==
Cc: <linux-kernel@vger.kernel.org>, <filippo@debian.org>, <colyli@fnnas.com>, 
	<yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20251124063203.1692144-1-yukuai@fnnas.com> <20251124063203.1692144-5-yukuai@fnnas.com> <30ae98d1-7947-ff39-fde7-04f8fe94b433@huaweicloud.com>
In-Reply-To: <30ae98d1-7947-ff39-fde7-04f8fe94b433@huaweicloud.com>
To: "Li Nan" <linan666@huaweicloud.com>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>
Message-Id: <9205d0f0-3dcf-4459-a23a-3c595ce99eec@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26958f9e4+4d2bdc+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH v2 04/11] md/raid5: use mempool to allocate stripe_request_ctx
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Sat, 3 Jan 2026 19:13:36 +0800
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 19:13:39 +0800
Reply-To: yukuai@fnnas.com
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Hi,

=E5=9C=A8 2025/12/30 17:38, Li Nan =E5=86=99=E9=81=93:
> In mempool_alloc_noprof():
> =C2=A0=C2=A0=C2=A0=C2=A0VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
>
> __GFP_ZERO should be removed and ensure init before accessing the members=
.

Looks correct, will fix it.

--=20
Thansk,
Kuai
