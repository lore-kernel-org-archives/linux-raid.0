Received: from sg-1-12.ptr.blmpb.com (sg-1-12.ptr.blmpb.com [118.26.132.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A9EFBF0
	for <linux-raid@vger.kernel.org>; Sun, 30 Nov 2025 02:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764470300; cv=none; b=VKoWIjucVN5qGzhPZBlhRd8mNb4TP6YIDS1GSz3rGmxQNaNTxGCZJA9JEb496DrCYbwwPrEWb4EqqCoAAS17rPIRUHY1Jl5PzbwV7VF47JYKuIsBKWtqDKX4/JzhqadOlTJ/T3RFEtyl0Cizsp/onEG9twMlEfzc07vRTUEmbKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764470300; c=relaxed/simple;
	bh=W8LsCLK67dlNpsyF40683w99+jDqOch8ULlH1vlYSus=;
	h=Cc:In-Reply-To:Subject:Date:To:From:Message-Id:Mime-Version:
	 References:Content-Type; b=CsAAOUl3OysrlszDprGysEDBtvo/Si5fhwZmUACn9Gh7R+RUcWAoNInWe4DZUtuALw4F9p1cfpiBo7OA2LrbbpdmCMTEppk8T+kbWWoRzNBww8aVvWqlfMuvZ04RjFpyYZ92VMMyEP2pD1LHCnrMnkBqxWv8EE2o5/FQ3jVvzqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Z/iUh5TO; arc=none smtp.client-ip=118.26.132.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Z/iUh5TO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764470290;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Rkx7Ahdvf7rs487NDbvuC3W0RQRmgADzUQXM+7MHBog=;
 b=Z/iUh5TOgZ4vLAfd3CmitbWUgl0EGrEFhjNPCvS5gQ+JyL6wYIkL7c884kEXAmU1oye5Je
 X9t7eMK/Q9c4GUQrMU2ZATsTfKNHgaHz5TkTqddMeG76DCEaS/Ge7Dx6yDITk/0t1J8vbs
 n35sR2At8VG9aC+36BcEjPSKzBfmApv/UFgjHO71sdg8VoQmraReoTvEQjzxtKb0jCnAUM
 ET4P07iXNnPGBSBsoT4Lz6wTrkaJ1bhJQrjL1zMIol+kyg2Hof8r8l/Q58zvPDvd5TCd99
 ngp9kK8C2Hjz518A9ZW75KJQIRQZiyNAqvYB6QIeL3K+B6ha+VXr3KUf2m5kkw==
Reply-To: yukuai@fnnas.com
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Sun, 30 Nov 2025 10:38:07 +0800
Content-Transfer-Encoding: quoted-printable
Cc: <oe-kbuild-all@lists.linux.dev>, <linux-kernel@vger.kernel.org>, 
	<filippo@debian.org>, <colyli@fnnas.com>
In-Reply-To: <202511270809.hl08JR8y-lkp@intel.com>
X-Lms-Return-Path: <lba+2692bae10+a92908+vger.kernel.org+yukuai@fnnas.com>
Content-Language: en-US
Subject: Re: [PATCH v2 06/11] md: support to align bio to limits
Date: Sun, 30 Nov 2025 10:38:05 +0800
User-Agent: Mozilla Thunderbird
To: "kernel test robot" <lkp@intel.com>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <7830a957-1c8a-4971-b59a-7f01e69f39b7@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251124063203.1692144-7-yukuai@fnnas.com> <202511270809.hl08JR8y-lkp@intel.com>
Organization: fnnas
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2025/11/27 8:51, kernel test robot =E5=86=99=E9=81=93:
> Hi Yu,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on next-20251121]
> [also build test ERROR on v6.18-rc7]
> [cannot apply to linus/master song-md/md-next v6.18-rc7 v6.18-rc6 v6.18-r=
c5]
> [If your patch is applied to the wrong git tree, kindly drop us a note.

This set should be applied cleanly for the branch mdraid/md-6.19

Thanks,
Kuai

> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-merge-m=
ddev-has_superblock-into-mddev_flags/20251124-143826
> base:   next-20251121
> patch link:    https://lore.kernel.org/r/20251124063203.1692144-7-yukuai%=
40fnnas.com
> patch subject: [PATCH v2 06/11] md: support to align bio to limits
> config: sparc-randconfig-002-20251127 (https://download.01.org/0day-ci/ar=
chive/20251127/202511270809.hl08JR8y-lkp@intel.com/config)
> compiler: sparc-linux-gcc (GCC) 11.5.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251127/202511270809.hl08JR8y-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511270809.hl08JR8y-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>     sparc-linux-ld: drivers/md/md.o: in function `md_submit_bio':
>>> md.c:(.text+0x85d4): undefined reference to `__umoddi3'

--=20
Thanks,
Kuai
