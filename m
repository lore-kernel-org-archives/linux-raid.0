Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7091AAE2E
	for <linux-raid@vger.kernel.org>; Thu, 20 Jun 2024 11:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718883708; cv=none; b=gHbOQRQ6Bktz17wJ6LMS7XP3criONqvKoGagPPbKBBkzqAxD0ImtF/wCFfNQ87kxxL5KLCwqCnNwWesxfgcPYDpccktTm+1xA36mCbsEwEd4/NzDuzxjb+5kqz05r7wBzQnMxp5iz3IqhVN3ifLj4KUj9qLff5mC32a5EtRr+z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718883708; c=relaxed/simple;
	bh=BZcvucozcrG5PTgvDk1B8wKSOJzeNZC/8HZYRONIt5A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mTEAwCQAcLQGmQ4frJ8J+3e6MDzBQctdzuNtNKBQRdM0ATO/qOHRnx8F73dPjeB4hpwk9nU5Hz+3yJI3/IxIJDJR6ODhubwDB+6vIdI5x7eSsTg/tmYzPFhbHsvJmR1CwZJuQ8BGo2/Uo/t95SNZLqnYhUaJN1T6LPhUDfbACMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=im20aWBU; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="im20aWBU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718883707; x=1750419707;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BZcvucozcrG5PTgvDk1B8wKSOJzeNZC/8HZYRONIt5A=;
  b=im20aWBUogoh/ba1NJU5apruy2rfn4RpjHD6B9quAZdlEcWhD9bOn0dP
   8VzikiIhCxADRhg3Y/U8dQovoe0dRDXLtyMAMrXcWnMV8hvssvcQfNlxI
   4QX1lXlTBAECRRK6Sy6oCxhk3sluj9Px+T1XOiapsss70GnxO3yi0gfuC
   hwgapC+FRMKCDUu/ISUdQYkPcW8+gPe6rwXpHuvqik0Veq/VB53r15DBb
   4uyTGRitNq+YXed+w9IYSGdxPONfxuGiE89oZKeYEpUKby081oXRG0111
   5NIM/0aq/CxHJYsV+obfDreiftpKzUG6wE86WoNUQBDg/VhJ83EThShJW
   A==;
X-CSE-ConnectionGUID: QDB1yXA6RdqorWfOuUIcJw==
X-CSE-MsgGUID: T5JNarY9SSC2F6Q9DoBngg==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="15683438"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="15683438"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 04:41:46 -0700
X-CSE-ConnectionGUID: X7OSl4ncSCiF2B5kqGo+sQ==
X-CSE-MsgGUID: UxCutXIoRYmv8Gn8HFwoqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42327126"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 04:41:45 -0700
Date: Thu, 20 Jun 2024 13:41:40 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm/tests: judge foreign array in test cases
Message-ID: <20240620134140.000028a3@linux.intel.com>
In-Reply-To: <20240614024501.10832-1-xni@redhat.com>
References: <20240614024501.10832-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Jun 2024 10:45:01 +0800
Xiao Ni <xni@redhat.com> wrote:

> It needs to use array name when judging if one array is foreign or not.
> So calling is_raid_foreign in test cases which need it.
> 
> Fixes: 41706a915684 ('mdadm/tests: names_template enhance')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---

Applied! 

Thanks,
Mariusz
