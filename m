Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD799487A5
	for <linux-raid@vger.kernel.org>; Thu, 18 Jul 2024 07:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721287206; cv=none; b=lkQ+ny1K4pq38EEIwAxBnnWDQw4RiVhDXSsSLBSBikZaw4Hb/0lYqaiUevlQIQTLDbfYw0Xrp/O1WPtNzLBiWDLizVrAsFPwtVrIHJD3UGOg+rL6N2efsIh/wOECXtWZ4FMBVPm3Y/NXzHJcfKh+m93SdG3Lzr2aVoRwRMw+Xr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721287206; c=relaxed/simple;
	bh=8DgAaQHwJpMufkWMJ3sxjo4cGklNPjSA6Z+40NbEmzY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfqFLrwgiQwTwwQSBWiEeDLsGKGIszwb0mqseenjdJOJvj153SLgNH/kPLYWYLI2pUtzuzLmvdwA575rUx1vtWWnsXR0ftgot08lOsf2oBTmmwcG9xwpjoYpTHTNTn+t1l3BNqLqOlc/dAJBONv/kk3iB4FjoqFz4meZiFJaIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cU4yWPtj; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cU4yWPtj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721287205; x=1752823205;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8DgAaQHwJpMufkWMJ3sxjo4cGklNPjSA6Z+40NbEmzY=;
  b=cU4yWPtjxhBH4e220ZvTHv3y3cnlmQ1QXRriCccTBvKrS2gE8s9MGZV2
   6Fk90lNeckaCqPQbZXpeoZjAeSuAJerd1dW3ZfEiR6UHWwC+LDCbsKujS
   8AifT7eZZ1GEunVeTUXmadIwvDdx7f9j/JdNn8aG2UMBudB67QahmtD4B
   SOT/Dh6A8nmUeh3Jp6hmgEx/UJjc7oFk2/E07Z9xEPLg2/prlD1yNetJR
   uYB+oQ9M9RKFbnrE1FC5fJSgoUH+o5eqfOBcaA74BgE1w0e/VesOqA+/m
   YQbNdH1MccA2yl2VdEhL0PJfb0aGqwGW3blNgTeq6MjDFaO5fBYD2xsRZ
   w==;
X-CSE-ConnectionGUID: J/mC+HHQTJuHs89YLO520w==
X-CSE-MsgGUID: 7hDrum8ATH+AMft455nVlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="18531421"
X-IronPort-AV: E=Sophos;i="6.09,217,1716274800"; 
   d="scan'208";a="18531421"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 00:19:54 -0700
X-CSE-ConnectionGUID: jn/rCkqFRtid9YRdnRv1iQ==
X-CSE-MsgGUID: ydj0bKRZSlei6HWLJsfsFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,217,1716274800"; 
   d="scan'208";a="55179968"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 00:19:53 -0700
Date: Thu, 18 Jul 2024 09:19:48 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 02/15] mdadm/Grow: fix coverity issue CHECKED_RETURN
Message-ID: <20240718091948.0000398e@linux.intel.com>
In-Reply-To: <CALTww2-UHvkCC-r-YS3DD=T79woc+kPvNrubDyfSMJOkZxd+KQ@mail.gmail.com>
References: <20240715073604.30307-1-xni@redhat.com>
	<20240715073604.30307-3-xni@redhat.com>
	<20240717113315.00002fd3@linux.intel.com>
	<CALTww2-UHvkCC-r-YS3DD=T79woc+kPvNrubDyfSMJOkZxd+KQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jul 2024 10:29:50 +0800
Xiao Ni <xni@redhat.com> wrote:

> > lseek64 errors are unusual, they are exceptional, and I'm fine with log=
ging
> > same error message but I would prefer to avoid repeating same message in
> > code. In case of debug, developer can do some backtracking, starting fr=
om
> > this function rather than hunt for the particular error message you used
> > multiple times. =20
>=20
> Hi Mariusz
>=20
> If we use the above way, pr_err only prints the line of code in the
> function lseek64_log_err. We can't know where the error is. pr_err
> prints the function name and code line number. We put pr_err in the
> place where lseek fails, we can know which function and which lseek
> fails. It should be easy for debug. Is it right?
> > =20

Oh right, I forgot about this from simple reason - I'm never using this.
Line is printed with make CXFLAGS=3DDDEBUG. If you will enable DEBUG flag t=
hen
mdadm will also spam with debug messages (prr_dbg messages). Anyway, you are
right it is an option.

Enabling DDEBUG in the past many times broke my time sensitive reproduction=
s. I
don't like it.

=46rom the top of my head, there is a rule "do not repeat same code". If we c=
an
avoid repeating same error message by wrapping that to function then you wi=
ll
satisfy my perfectionist sense. That's all.

I'm not going to force you to follow it - you proved that there is a way to
hunt the line by DDEBUG so I'm satisfied.

Thanks,
Mariusz
