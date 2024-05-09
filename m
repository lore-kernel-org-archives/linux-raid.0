Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8AF14901B
	for <linux-raid@vger.kernel.org>; Thu,  9 May 2024 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715268805; cv=none; b=kdRcFFaTq9rPZiOw8a4fGy8BbpTVZOBFi5UU3xVPN1FOBDbgxnBGralBtr1QeMpAAheY7yFTeqX89a2tiqaKtbrGcjSPYeCy6iHQPzTUH++6eGkBLl+oLXPHbxrk6X8WI2U/An1A+lKouTBTGB4C0mmN/D9uET3hmXQ6q2+B0pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715268805; c=relaxed/simple;
	bh=vAVVj8xO3oYV6cPQm+ReJ+Kf/Hsw4WhgdQvRw/HwXMI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8LPD34kwtPUO/Nwolj6SCcxWrEKokUI6aMBPfFi1k3Wx+k9meDGr78TsaEdk3N2IAxmQlcHrLlHxrT6srbMygYmrY3xChyOFsOySxNjjBag93AYoPQaI3NdXqLC+LkOzOk3ncBorJQ+hypf2JlxSEHsx+WxM6NCQvLFf+tJHjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wyi3aIqU; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wyi3aIqU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715268804; x=1746804804;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vAVVj8xO3oYV6cPQm+ReJ+Kf/Hsw4WhgdQvRw/HwXMI=;
  b=Wyi3aIqU1Xl9gd8uD3ah4ocCB6/aJnERXkg8xyXTnl8QouuPyMCYZTHD
   PBtllmDmiQIeRM7XdIIitdd7gP7d08NSOfPQxm9YuPeYumRm7cusQ/WjB
   DriT3r/4+UEAKYHCJG6DjbIP88tVEA1GmoakiQYt/l3Wya+WCdxcr+LGA
   rnI3OafAcVuBwloy1ww/jGSPWA4b835IwUPEgDhdB6lP/7mSIi2TtvptK
   RcOriGWaswR3bJwfmBwWbj7XwaiOhjW5iQ/h3nPJ4+xE6uKMlacHKhuOx
   znommWyqxwN+ZreiBl/eXFF25BZ2qBvaKJ1ZGDmOtw1+OoiNNmG3ufL5u
   w==;
X-CSE-ConnectionGUID: Qp3OK3VKSvm++zXwyMhUAg==
X-CSE-MsgGUID: yVnb/CCEStuDfhWc26shjw==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11134890"
X-IronPort-AV: E=Sophos;i="6.08,148,1712646000"; 
   d="scan'208";a="11134890"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 08:33:23 -0700
X-CSE-ConnectionGUID: USj++KSvRJOep/pnyLScTQ==
X-CSE-MsgGUID: pXxcJ4W7QemSzImZ7IVvAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,148,1712646000"; 
   d="scan'208";a="29237538"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2024 08:33:21 -0700
Date: Thu, 9 May 2024 17:33:16 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Kinga Stefaniuk <kinga.stefaniuk@intel.com>, linux-raid@vger.kernel.org,
 song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v4] md: generate CHANGE uevents for md device
Message-ID: <20240509173316.0000067b@linux.intel.com>
In-Reply-To: <680e7843-db81-0dae-3e6e-5274fdb78f4f@huaweicloud.com>
References: <20240509122026.30015-1-kinga.stefaniuk@intel.com>
	<680e7843-db81-0dae-3e6e-5274fdb78f4f@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 9 May 2024 21:09:12 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> >   static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
> >   static atomic_t md_event_count;
> > -void md_new_event(void)
> > +void md_new_event(struct mddev *mddev)
> >   {
> >   	atomic_inc(&md_event_count);
> >   	wake_up(&md_event_waiters);
> > +	schedule_work(&mddev->uevent_work);  
> 
> This doesn't look correct, if uevent_work is queued already and not
> running yet, this will do nothing, which means uevent will be missing.
> Looks like you want to generate as much uevent as md_new_event() is
> called, or you maybe don't care about this?

I think we don't need to care. I meant that we don't need perfect mechanism.
If there will be two events queued then probably userspace will be busy
handling first one so the second one will be unnoticed anyway. Perhaps, we
should left comment?

> 
> By the way, since we're here, will it be better to add some uevent
> description in detail as well? for example:
> 
> After add a new disk by mdadm, use kobject_uevent_env() and pass in
> additional string like "add <disk> to array/conf".
> 
> And many other events.
> 

Could you please elaborate more? I don't understand why this comment is
connected to new disk, potentially CHANGE uevent can be generated in more
scenarios, like rebuild/resync/reshape end, level change, starting raid array,
stopping raid array (I just briefly looked where md_new_event() is called). I
think that it is correct because those changes are real CHANGE of mddevice
state. Also, there is a comment below md_new_event():

 * Events are:
 *  start array, stop array, error, add device, remove device,
 *  start build, activate spare

Thanks,
Mariusz
