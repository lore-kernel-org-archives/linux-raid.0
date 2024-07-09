Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FF3139CEF
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 06:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720507761; cv=none; b=ckvI1p4faLOHP+9OlZwfXi1fnG0TYKfyLo6TYMzu+btxRGHNt+da4538823al3QBfkPm+rpW+FOdLMSXiCgoXf+6ccMbTRov9YkGVL0TexCbtee58eT0uIEpyIFNMT8XYj9cG4qgGB0Lz16neZlAdPnxdN0lO83QmoP+e9Vg20E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720507761; c=relaxed/simple;
	bh=UZHSs1c5oAPgeJ2/aoIwxszwuwaZMaVPK1S+q8FC+pE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GY7SIn7jY9EWrWxduMVZGDWJIAIr2Z6geDmScpn6igJ9Mc+1xwa7Om/ZzvN/d2DGC6WDbzeppdO+RxanUH9xKlqtbscIh7MLVF8m/AScJtydMCq+8jbScJfcujhrkvIPekeDtxwevVOghGnG/z3CY187y6YRTPwB+qVJXryActM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JpGQlRJy; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JpGQlRJy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720507760; x=1752043760;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UZHSs1c5oAPgeJ2/aoIwxszwuwaZMaVPK1S+q8FC+pE=;
  b=JpGQlRJyuVMGC+Gv5EgTXS136G6YCSkGzFnp319WGRmIwci63sZODlXJ
   aZ+W+rl4qrB91J5ztnjB6Si61VqqJteVvWQeF3lkI2fJ+nI88aLGEwXqd
   RUWZUR32DWK/UiG/G3Rk3L9164GEQDbt3wxatzDoeodMkwMoFxnWqLgJn
   QiJ862hWSZYIpcCGRwWXXcFYPVaXZMni9DpGqIhwKexU2Db61GqiWoOZw
   zKTDO3dFKDCyNMHFer4D9DDSNiI34BkdxeK3t84B42Vqoh0uA/h7IVluX
   FaQ2OSm0BLGcS9JzNkeuVEMj56DulT78T7ui1AqFiNS5sphfrWz9z8c7D
   g==;
X-CSE-ConnectionGUID: APBmfib+T++T5255Z3KLdA==
X-CSE-MsgGUID: Oxwv2mn+RsqaP6ig5s85Bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="28344978"
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="28344978"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 23:49:19 -0700
X-CSE-ConnectionGUID: 4xJfBVUtT0iJIlzHxyYwww==
X-CSE-MsgGUID: cGfh0ycvSgayQg5qQ23BQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="47724623"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 23:49:18 -0700
Date: Tue, 9 Jul 2024 08:49:13 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz =?UTF-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc: linux-raid@vger.kernel.org
Subject: Re: [REGRESSION] Cannot start degraded RAID1 array with device with
 write-mostly flag
Message-ID: <20240709084913.000020d8@linux.intel.com>
In-Reply-To: <e6c48984-01ee-411f-a013-7e5068641363@o2.pl>
References: <20240706143038.7253-1-mat.jonczyk@o2.pl>
	<a703ec45-6cd5-4970-db22-fb9e7469332a@huawei.com>
	<e6c48984-01ee-411f-a013-7e5068641363@o2.pl>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Jul 2024 22:09:51 +0200
Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl> wrote:
> > This looks correct, can you give it a test and cook a patch?
> >
> > Thanks,
> > Kuai =20
> Hello,
>=20
> Yes, I'm working on it. Patch description is nearly done.
> Kernel with this patch works well with normal usage and
> fsstress, except when modifying the array, as I have written
> in my previous email. Will test some more.
>=20
> I'm feeling nervous working on such sensitive code as md, though.
> I'm not an experienced kernel dev.
>=20
> Greetings,
>=20
> Mateusz
>=20
>=20

Hi Mateusz,
If there is something I can help with, fell free to ask (even in Polish).
You can reach me by the mail I sent it or mariusz.tkaczyk@intel.com

I cannot answer you directly (this is the first problem you have to solve):
The following message to <mat.jonczyk@o2.pl> was undeliverable.
The reason for the problem:
5.1.0 - Unknown address error 554-'sorry, refused mailfrom because return MX
does not exist'

Please consider using different mail provider (so far I know, gmail works w=
ell).

Thanks,
Mariusz
