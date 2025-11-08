Received: from sg-1-38.ptr.blmpb.com (sg-1-38.ptr.blmpb.com [118.26.132.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0408F2F1FE3
	for <linux-raid@vger.kernel.org>; Sat,  8 Nov 2025 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762596941; cv=none; b=WEiRwyA944Z3B0tlyjS7E0y9ciKoNp8La/wgz85rxKCizAlpMvQvluMoU6/rPbPLhzNgTGkYdwR/jHzo5S8gBPSb0i3kc5hebGUTIDVSuSRMt9eRdZ1S4p+8val2E6DpoJJhdD5BG4JunbYudPkbRnQyxGbf6t/voBJSUniDiRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762596941; c=relaxed/simple;
	bh=rPsmZDBtSrQYnCqyB9bB/yRhQP0ToK5gwKnLevYboPk=;
	h=To:From:Date:Message-Id:Mime-Version:References:Content-Type:
	 In-Reply-To:Cc:Subject; b=R1cuqE4eOaAGn8OqPOORxaktKUc+kJRtwrnrsX+2+cp+pAVehR4ub2M8UJ51DfH0HoaZtSF1Inqu9QRxDjrKPadVASwLWsOWUlizNeXfFET/iyCydUAjLpMDFLxNhwWU+uD8tGoFCyxaepDarC4aWhzVXvIMnKIo03nuRi3e618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=aFXYgP/m; arc=none smtp.client-ip=118.26.132.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="aFXYgP/m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762596928;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JvQbHjMiHszpgpaiYGzCvvQIwfo7py2R6goJZ/RojEc=;
 b=aFXYgP/mOn1kd9e7N8Jew5GLX3WOauETXJXsS3i4iwR2q78yGoJsHdoBFJxpEQ8Vs7ZzMh
 JwI+QuLNkFoYomkivbO0VBBN/msxc/0p2Y8P5K8BNc4Q4TBRYW9el8Dg3xk4VMwOnoXpzD
 ifDHD3WPiYkQL77fAAQWJnuHsP+5cc0uLh7wRmfaqx2+uWIRLTfQr3iVnszCyqnGQEa5ah
 EedBxQogOZbHfC5R3RgpctqXdVXcrM5WXbpF6VsZQh/amjz9jcJDsw6VdiYReM/OrinbsW
 zhi8jcQZ0xVvnAbNryYld4yqRmbg/iD124Oytld3Xmx3awjdHHlSvaMJKID1EQ==
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Sat, 8 Nov 2025 18:15:24 +0800
Message-Id: <c608d2fd-15aa-4d61-92d8-1e9e79d10891@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251106115935.2148714-1-linan666@huaweicloud.com> <20251106115935.2148714-6-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20251106115935.2148714-6-linan666@huaweicloud.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Sat, 08 Nov 2025 18:15:26 +0800
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <k@mgml.me>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2690f183e+46a1d5+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH v2 05/11] md: mark rdev Faulty when badblocks setting fails
X-Original-From: Yu Kuai <yukuai@fnnas.com>

=E5=9C=A8 2025/11/6 19:59, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> Currently when sync read fails and badblocks set fails (exceeding
> 512 limit), rdev isn't immediately marked Faulty. Instead
> 'recovery_disabled' is set and non-In_sync rdevs are removed later.
> This preserves array availability if bad regions aren't read, but bad
> sectors might be read by users before rdev removal. This occurs due
> to incorrect resync/recovery_offset updates that include these bad
> sectors.
>
> When badblocks exceed 512, keeping the disk provides little benefit
> while adding complexity. Prompt disk replacement is more important.
> Therefore when badblocks set fails, directly call md_error to mark rdev
> Faulty immediately, preventing potential data access issues.
>
> After this change, cleanup of offset update logic and 'recovery_disabled'
> handling will follow.
>
> Fixes: 5e5702898e93 ("md/raid10: Handle read errors during recovery bette=
r.")
> Fixes: 3a9f28a5117e ("md/raid1: improve handling of read failure during r=
ecovery.")
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/md.c     |  8 +++++++-
>   drivers/md/raid1.c  | 20 +++++++++-----------
>   drivers/md/raid10.c | 35 +++++++++++++++--------------------
>   drivers/md/raid5.c  | 22 +++++++++-------------
>   4 files changed, 40 insertions(+), 45 deletions(-)

LGTM
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
