Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C251F32C85;
	Wed,  9 Oct 2024 08:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728463991; cv=none; b=SYQ42B6NVq3rAc2vFZUGRAYlPUGREpdQ4GCnvVVT03lye5+bNOi5ecoPYvZGJc1fKkMgabiPctsCCNI6Mrxj+PvPa5k32TfJv3O3sRX/sYAgmgismwBN8LHpnYPSPMix30BY6/WsOmc3QDQnz7WXbivPbLHRk++nc3AgVw23sWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728463991; c=relaxed/simple;
	bh=nxwR8qvR8A6md+C8GrL0KiaqDUVZZ90PZ9/uomwvitw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJIvgT+KnO3DWW/5wjHEdmhDtCkdOB/QxlP8QluCE5udx/5HEIcMiMdkwoMPmGZOD/E1xf3iEf290t9sI8FF6zwREWvzoMbxwkFKrZMTMDhZynrI9Eo/1LG+sznv5TtxSRBvIjPdfEQi5A11qjO0qaBjncow2CjzzK19WmJ+FB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (ip5f5ae834.dynamic.kabel-deutschland.de [95.90.232.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 022FE61DFA93D;
	Wed,  9 Oct 2024 10:52:17 +0200 (CEST)
Message-ID: <05afc661-9aef-415f-a429-eade6e6a72a4@molgen.mpg.de>
Date: Wed, 9 Oct 2024 10:52:16 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.12 0/7] md: enhance faulty chekcing for blocked
 handling
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Kuai,


Thank you for this patch series. Just a note about the typo in che*ck*ing.


Kind regards,

Paul
