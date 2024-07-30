Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07473198856
	for <linux-raid@vger.kernel.org>; Tue, 30 Jul 2024 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722347476; cv=none; b=TWBjNS1rgUla2tezu/HJivrZsi6bmhfKr8IDqGmO6o01ziMaIbWYxzCEHT4+RyrYMyXrQeiahGY+aetqNxO38B7iCLMa+SHoiCqVkQzkvc56bf7LyerderSHk2JDHlz73IOG37PEqjLRdeZw/S58orw8Pf9RfAXb7Axw4mbfOpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722347476; c=relaxed/simple;
	bh=0M5lT96xHPVT2BAaDz9qLsS69eJavvCcVx1Up9Ika+k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVB3nnBW9InNjzYwMLWft868eA3LeKsinC5vJNdQeEvwgQ7YVZH9QgaxyfbOENahPlyJdzMkut7nA/8WLdZMEago3h4JELGWfL5bhPwodQXrMbHMPJ4IyZZNUilif5H3Ruhr8/ePV2k3TaUzohfef0ZZMFgy6G3VA6ggza4M1AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FV9r9A+3; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FV9r9A+3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722347475; x=1753883475;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0M5lT96xHPVT2BAaDz9qLsS69eJavvCcVx1Up9Ika+k=;
  b=FV9r9A+3uJFVfCaWN+NeMbWcS/Q/mt8TG6cZ7p5U4WYjw9eHRnlcUXxm
   zx51lxjsZ79XaphYiZ7FWs53YxBfhcYxjvcJLGTZKbYNIKFz8Sar639By
   by43V15GZHz8CtFQldiXJeiYIFzCOb5yLGaTGkr0LP7azQvSV6N2rK9dl
   rDLgUNdN5o9o0FBNcvI+ilbWVlh/UMFg2GzIh/Iuf742FioZSA3KgMDXT
   ltSbsOoI/Dqe++YvjjKC2fvq1OXhEnWT+WlltDr6sbj4KtezvDp8fS0dt
   RFZSFC63/q19NFf9yWqKZxccu2AKoVaxn2dt3bGldgaMwmVqBMmTK8Sky
   g==;
X-CSE-ConnectionGUID: aiw9Nh6SQ3m4Z77Q+L9yCw==
X-CSE-MsgGUID: KwenMmV0TZW4FE2yYXRL+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11149"; a="37675970"
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="37675970"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 06:51:14 -0700
X-CSE-ConnectionGUID: 1aO2H9liSOaMayonZW6SpA==
X-CSE-MsgGUID: CLwrlFymTGWGn7YQ9Us43g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,248,1716274800"; 
   d="scan'208";a="84989307"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2024 06:51:12 -0700
Date: Tue, 30 Jul 2024 15:51:06 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Xiao Ni <xni@redhat.com>, ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH V4 00/14] mdadm: fix coverity issues
Message-ID: <20240730155106.00001560@linux.intel.com>
In-Reply-To: <657cd05c-cc98-4f98-bd02-3db72089356b@molgen.mpg.de>
References: <20240726071416.36759-1-xni@redhat.com>
	<657cd05c-cc98-4f98-bd02-3db72089356b@molgen.mpg.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jul 2024 10:01:29 +0200
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> In my opinion, naming the tool reporting the issue in the commit message=
=20
> summary is not beneficial, and I=E2=80=99d prefer to have more detail on =
the=20
> change in there. The tool could be named/credited in the commit message=20
> body.

Hmm, I didn't put a huge patience into that, I accepted similar commits from
Nigel on GH, like this one:

https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D1b4b73fd5=
35a6487075e98f620454ff2e13b5240

However, he used the exact problem description reported by the tool in comm=
it
message. This is not exactly the same style.

I may looks like hypocrite, asking for changes from Xiao now.

For that reason I'm fine with current style but I doesn't mean that I disag=
ree
with Paul. I agree with Paul.

Xiao, let me know if you would like to rework descriptions or you would
prefer me to pick it in this form.

Mariusz
