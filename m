Received: from sg-1-38.ptr.blmpb.com (sg-1-38.ptr.blmpb.com [118.26.132.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE550149C6F
	for <linux-raid@vger.kernel.org>; Thu,  5 Feb 2026 07:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770276817; cv=none; b=RCgPC5L0VNomx91a0cQ+GizAfmnUR3A6GeajBIwPjF/C247Q87zxNd19iT+SBjuKHvD5w3MLNh67xb+pCni+jJMo+JtNJnxpZXDc3PTskL68KNi/WBL7WbCD9nHqkOdobHoHZAW282jwNKjHkTA8EixNSHzukyOosPkARxZ95EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770276817; c=relaxed/simple;
	bh=//qptFBtUvBfaIJ6jiN9sT+fDRpO68Cd4QUl7W8mzVo=;
	h=References:To:Date:Message-Id:From:Subject:Mime-Version:Cc:
	 In-Reply-To:Content-Type; b=Q66Pvkffi0ZfybHZP0pGLcYnmqgDkBR6Vz33JyurGO0TG5wGxDVhjm8IA3oRiJypBKKBLUDNeR4A+PXmBSSKxz4YaOrRLhtrEdTw0Cjr0NI5t9RWYZ8FoYLOFOxcHEvQxlNWYtPKnJ5F0kgCPDVJ5OwkrQmNmX1PtIhXRkbKSrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Jg/MpS9N; arc=none smtp.client-ip=118.26.132.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Jg/MpS9N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770276809;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=//qptFBtUvBfaIJ6jiN9sT+fDRpO68Cd4QUl7W8mzVo=;
 b=Jg/MpS9NZXs9OYNgnFDEmFYRvHd2aZKbGxI0mnq8wWEij5C5PQ1KzJie5spLVvtr0VXj4K
 QVZkwEwLNLuhkZon7Yx1b0kV0t0fmRIcklGDjSqb19+/FJoQgMkVdQ/fFSBtWRHlyBBMeS
 GwsgghNg9bC28fJ+zAbpeeapeUIFj7NuzNNzmwkUh4UBeCkxd3hSH50A6fl9P2pYNKGr+c
 vkwXlayGXPwyvC7Gz8P/UAhQIW3SwzjQwLSoQ046xO0LbJz9EdYVoONWVxxJBbhuHYVWUJ
 ANat80sro8e7dqniQitfBgmiqmHJ8ybGmw5MWmf0GCUw2lTn2dSAH1RDCFErDA==
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-4-linan666@huaweicloud.com> <b19b6eb8-b5c1-4ca2-a80e-f177370085bf@fnnas.com> <4b57e9b4-e660-a7df-4655-93c2815ec758@huaweicloud.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2698447c8+ef0c9f+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
To: "Li Nan" <linan666@huaweicloud.com>, <song@kernel.org>
Date: Thu, 5 Feb 2026 15:33:24 +0800
Message-Id: <44521568-3ac0-4374-9c3b-756b8e18192f@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 15:33:27 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 03/14] md/raid1: use folio for tmppage
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
Content-Language: en-US
In-Reply-To: <4b57e9b4-e660-a7df-4655-93c2815ec758@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/2/5 15:23, Li Nan =E5=86=99=E9=81=93:
> Yeah, should we introduce safe_put_folio()? Or just check NULL here.

Yes, and don't copy implementation. Just convert safe_put_page(page) to
safe_put_folio(page_folio(page)) first.

--=20
Thansk,
Kuai
