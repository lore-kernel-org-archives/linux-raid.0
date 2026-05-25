Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC984317D
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 05:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779687177; cv=none; b=Aq+JnKhKAepZeLuwKSlOTatYVLjwOLFV8dogHTlCJ2hodMHtpD4mfMHnd+mvXVGB/beR/6rq6rgwxLSpVRZWIT8D5DG5jMBlFSi17jBVncKZNhwfacvEud+PQ9Rpgg+A847lC5k9DhzWTRI5ximDhJd7ePzgn35sNdP4qWWVmcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779687177; c=relaxed/simple;
	bh=v1PFkzF+cKDR8V3aKg3ZWHfNIcxmjEBuM8sn4fv+eJA=;
	h=Subject:Message-Id:Content-Type:Date:Mime-Version:In-Reply-To:
	 References:To:From; b=aBiuHrPgepoHj3ollJieNObrLoOBqMjwBhxD0kFDUPJEluUfsSUYLVUuj71ZoxdIU1OH/fs4zd7wXqAirNhJf3PVOHihEAeXmvQssKPTW/gRjmlQt7HjOvl+W05xpNMdZcMU65PVgKE4P2lzq006WTc9js1wEMl3P39SFj2hf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Jx69n6+G; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Jx69n6+G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779687162;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=v1PFkzF+cKDR8V3aKg3ZWHfNIcxmjEBuM8sn4fv+eJA=;
 b=Jx69n6+Gm/ngcBjlruITWVtlAN1VEZk0wD6Ke7q3JLh23askg282cEEhSzb56XuxyKKnUa
 LF9spi5GsB44bv7mbpSsx9sQSS3mLnz4rJth9BPLiO0j7xAZU+Sp/VL1if+ovgCJBH3wd9
 G39w8FSDvnO2hWscDgYUOYWCsVNnPH29D68Zfs702lOdLBYb90sWBnSuA5jIAegIwyzr+L
 9uabt/k+l5xZAoiXLkzHkWyZflOFFndPcM/C5F/qDRtJ5FQfCpu3infixZoVWJ082kApNP
 zn+bGVxWojPmu4MGp9D8qkPo/Zjn/D9n6LKgateapsktY2Ekq0ug53co8RbuQQ==
Reply-To: yukuai@fygo.io
Subject: Re: --bitmap=lockless across server reboot
Message-Id: <5d4b72d7-7e03-463c-82a1-63adcae20344@fygo.io>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 25 May 2026 13:32:38 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <CAAiJnjpPAur30W4FO2sTZcYWc24yFafKWGR=BZWZsh2JnbrRpQ@mail.gmail.com>
X-Original-From: Yu Kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <CAAiJnjpPAur30W4FO2sTZcYWc24yFafKWGR=BZWZsh2JnbrRpQ@mail.gmail.com>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Mon, 25 May 2026 13:32:39 +0800
X-Lms-Return-Path: <lba+26a13def8+771f46+vger.kernel.org+yukuai@fnnas.com>
To: "Anton Gavriliuk" <antosha20xx@gmail.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
From: "Yu Kuai" <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/5/20 1:28, Anton Gavriliuk =E5=86=99=E9=81=93:
> Hi
>
> Does md-raid lockless bitmap support server's reboot ?

Yes, of course it should support reboot.

>
> I don't see md-raid6 created with --bitmap=3Dlockless after reboot.

Do you check kernel log if there is any failure log? And do you try
mdadm -a manually?

BTW, pPlease report with your environment and test script in details,
especially kernel version and mdadm version.

>
> Anton
>
--=20
Thansk,
Kuai
