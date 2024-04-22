Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828C64C62A
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 07:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713770648; cv=none; b=WFMXLLG+sR6DvA8GD4Kx8pFTb4NtFqSrRcdXcsqNJ0FVYDOblIiikKZjvhi7ZgyAlKMnRFbZGy192FOf1BbXCvaOyuLC8XmWYXhOIqV2Ct0Z+G50BoEKyo9l3Spv4Ak3UaNMLHvMDcGNoHK8gbBKqjibw7KztQUrg26NgmMo73Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713770648; c=relaxed/simple;
	bh=+P3WWNrvRnEL5/pwY55+tQ5VidnVNf+Asf+RLdLx4JU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FiiTTeMDvhgOnU68OP6oFl0dXKHWjT1ckrawIFzoArycyapFnlBrvdubd1fsNSc+ot6fgLUxFVGTfMlYGAJkKDkEP3DhNbYeRJix/QpJwXPm/hGcPh+Vw41sJvKp9ZXRKZRlCGAqSeUeYk/wzjyEgbLSHNfd4h+UvYkqZm7QUIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hB8Nqa2j; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hB8Nqa2j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713770646; x=1745306646;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+P3WWNrvRnEL5/pwY55+tQ5VidnVNf+Asf+RLdLx4JU=;
  b=hB8Nqa2jZPNBYv8k7FU8p4u1Jmv3AyjC48xI4vWcmvxgj93Hxq1bQQ5J
   woP5kbCrI13vXfwvFdM+UD9jEr5TeCcqlDM66/EQ7+NYVJu1MOvYZWGzS
   HiYU5JvU3UP74YudQD3OPTEDv3T9NvmQ5rfvFpzzzyRe3Bdu/knC6x8+M
   LjbBA5P9JjGHDKaBAJdet3xE/gLg4e8NJET5Ur95W5bqkdrJ3v2z86Gtm
   n2mP45plPprwwKQSVU4DCCY3MseqRXw0NwKhR/5uPFaKVzh5RssGzc7ai
   RzqjyQDYDNq8ZdhLSv8FuKaRO7QqI7K3Fke2J8lh0PDFaIueni367U35y
   w==;
X-CSE-ConnectionGUID: 55wor/QXQsiSMRhE0mRtsQ==
X-CSE-MsgGUID: Au+p5wWOQeaXt9Nqgp9aZQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="12233667"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="12233667"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:24:06 -0700
X-CSE-ConnectionGUID: 5eEUFqb+R9i3wtkJtz0o7A==
X-CSE-MsgGUID: FUmEGBLlSu+joZVYuJUWtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="24531714"
Received: from unknown (HELO localhost) ([10.237.142.95])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 00:24:03 -0700
Date: Mon, 22 Apr 2024 09:23:58 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 2/5] tests/00createnames enhance
Message-ID: <20240422092358.00002736@linux.intel.com>
In-Reply-To: <CALTww28cKpHkvAHqeKiW0iLubC0vT8473OY63TH6-JU=3jz1nw@mail.gmail.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-3-xni@redhat.com>
	<20240419092021.00003bc1@linux.intel.com>
	<CALTww28cKpHkvAHqeKiW0iLubC0vT8473OY63TH6-JU=3jz1nw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Apr 2024 14:56:17 +0800
Xiao Ni <xni@redhat.com> wrote:

> >
> > What about adding empty mdadm config to the command `-c
> > ./mdadm_empty.conf`? I see it as the best option for now. That save use
> > from checking 2 config locations and any user defined behaviors. Do you see
> > any disadvantages?  
> 
> You mean specifying config file in test case when creating raid?

Yes, with that default config won't be read.

Mariusz
