Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E7B13A86C
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271846; cv=none; b=E7mOdVLRUcgosV2SiC2Rus9cV1nQUJHiZROpmJUp5ApjATJj2uJ6h3RKX6347JkcDAH0V/VPGKOdUi8Yib3SyoSzooiUcnpZCaMdmARanhy5I1SU7FN+gSN53aMTUvFLN6BpoQZhtCFDTdCrcyf//NEhycPj8sFtal4dHN+60Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271846; c=relaxed/simple;
	bh=w/Ae/ucpdwsznjkjI9BbviBptdVhFyVaXQSLWmOHAfw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQKuu9auOLh1XcqPsPYNqpybjWYBDVjmWXnyhaVEmfOpq9r0dIh7HffojEAlkrSOSepB6m32zTYPNwWg1hxT0PD8FPjpn0MwISifCqofruY/Jvt67Zrc43Ywpwgr/YAq7HFcoAQIdF3+sd8TMabxQUQkQm+qWwBum9RRN4i6Vgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lTZoeYxy; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lTZoeYxy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725271844; x=1756807844;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w/Ae/ucpdwsznjkjI9BbviBptdVhFyVaXQSLWmOHAfw=;
  b=lTZoeYxyOKaBxwGyg+RTihct6rOc/mY4YFfDlKHuL5lRblBFFy5L+9/+
   0JSvOrpUsoLpFt3uOv/B7iMH1aYCF+yXmhlu90XOrw7klZJeTrrpFEDyd
   zxqhD4A+Omz7W2dBY4FzM9WrGM12r3wWtDrLWFe7OaHwP/InzqYM3zrTK
   JHaKOOAu10pDZit8CrTaR67+ZbgYWpqL2STxqdvRKRZYI7ekry0vsK8Tl
   cYeGmBn/TomKbJgKObc+cVUhePUjFxn0yMa/QsHcDwjKDVrDPk2s7rqx+
   bcKQ+bZIb3CKkWkfdXrCPmF4+yjKMpka+19GxgtLt0YJFLpT7g+s4WiVw
   Q==;
X-CSE-ConnectionGUID: XxYCEsUmSV2CqUZRYzg+Wg==
X-CSE-MsgGUID: sMiqkJatSlC9As4sDHAgEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="27603344"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="27603344"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:10:43 -0700
X-CSE-ConnectionGUID: SkaHh/3lS1yHnVieEP8W3Q==
X-CSE-MsgGUID: UeScp/1zQWqu5+SeYrPN2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="64529660"
Received: from unknown (HELO localhost) ([10.217.182.6])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 03:10:43 -0700
Date: Mon, 2 Sep 2024 12:10:37 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/10] mdadm/Grow: Update new level when starting
 reshape
Message-ID: <20240902121037.000066e9@linux.intel.com>
In-Reply-To: <20240902115013.00006343@linux.intel.com>
References: <20240828021150.63240-1-xni@redhat.com>
	<20240828021150.63240-2-xni@redhat.com>
	<20240902115013.00006343@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Sep 2024 11:50:13 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Hi Xiao,
> Thanks for patches.
> 
> On Wed, 28 Aug 2024 10:11:41 +0800
> Xiao Ni <xni@redhat.com> wrote:
> 
> > Reshape needs to specify a backup file when it can't update data offset
> > of member disks. For this situation, first, it starts reshape and then
> > it kicks off mdadm-grow-continue service which does backup job and
> > monitors the reshape process. The service is a new process, so it needs
> > to read superblock from member disks to get information.  
> 
> Looks like kernel is fine with reset the same level so I don't see a risk in
> this change for other scenarios but please mention that.
> 

Sorry, I didn't notice that it is new field. We should not update it if it
doesn't exist. Perhaps, we should print message that kernel patch is needed? 

> > 
> > But in the first step, it doesn't update new level in superblock. So
> > it can't change level after reshape finishes, because the new level is
> > not right. So records the new level in the first step.  
> 
> > 
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  Grow.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/Grow.c b/Grow.c
> > index 5810b128aa99..97e48d86a33f 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -2946,6 +2946,9 @@ static int impose_reshape(struct mdinfo *sra,
> >  		if (!err && sysfs_set_num(sra, NULL, "layout",
> >  					  reshape->after.layout) < 0)
> >  			err = errno;
> > +		if (!err && sysfs_set_num(sra, NULL, "new_level",
> > +					info->new_level) < 0)
> > +			err = errno;  
> 
> Please add empty line before and after and please merge if statement to one
> line (we support up to 100).
> 
> 
> >  		if (!err && subarray_set_num(container, sra, "raid_disks",
> >  					     reshape->after.data_disks +
> >  					     reshape->parity) < 0)  
> 
> 
> Thanks,
> Mariusz
> 

