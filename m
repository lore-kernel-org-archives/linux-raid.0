Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F0F1C7B64
	for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 08:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732176908; cv=none; b=d7RLrm34SMQdLxeYZqY72501dkR0P7EeBCLPYFF9LwK091T/S9ad4e+3ooxWxKhk6gtjIWp1/B3IGT3u32pV5Uw8AKoO5AuuiGLyIRiH7yxXwYoMLDgfIgfYrKg7CRnz9JTRXfr9GgCbEMilQP5SQfyhAP3xpJ899ChOI7lVzyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732176908; c=relaxed/simple;
	bh=KTP+O+p8x6upFtLM6eV5vbA/CCCbLUa4Kf1wftzJA4s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kCzgpzsG5W78S9H+jpcwKY7cGVq7BfzIud8QsyBjjGk4wN5w7SNNgL2P0gjHhpfI+vUGwgugkaJO3t57400ZjJsHfoBLwRk11c7t6rKUqf64fqwOHlanUPKcwo9lPqzkOINxXr96hT7JX/NsPzkdqbVmk7/+zC1EBLAQFiKdjzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k6nrMm0T; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k6nrMm0T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732176908; x=1763712908;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KTP+O+p8x6upFtLM6eV5vbA/CCCbLUa4Kf1wftzJA4s=;
  b=k6nrMm0TjrW3NVu4euPuUvTjpFWq8QRvIUfv/8pLSTzDWsGctpbYxm1J
   tzqKSDDH+Rz2Wz4FxQWRyyRxqW1nUNEVVqD8jv2tF0fZfqSwKfDwXouLF
   VJWpVAmqi7k0grofK6sFgNXRB0VK4PHz1H6UKC8g1hPrvoIud4c8ZhjR/
   31UB5Z0gEqL930NgYSua9F4lzcsfLXHi6lIam34UCqkBSUhOfA0sRj6Ty
   cUyRzLzYA897VFFamgpTTMYyHKkO8frX0lcES/GG6iuJutp9sqmLWY7g3
   ZtEUbqB60H60W1xT/mM9kPD9/xEkrXEaWkRn3/a7+jv6HyYYLYZL7Qlga
   A==;
X-CSE-ConnectionGUID: doXBT8D1R/6kfwNfLLhMRw==
X-CSE-MsgGUID: pRG0nXQSTvWT4+JwJoYV1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="32023171"
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="32023171"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 00:15:07 -0800
X-CSE-ConnectionGUID: hmg2BZovSHmyH+U9yhJ+Mg==
X-CSE-MsgGUID: IW97YmB3SOW6ntgcrt34Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="90159710"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.20.233])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 00:15:05 -0800
Date: Thu, 21 Nov 2024 09:15:00 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yangerkun@huawei.com, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: [PATCH v3 3/4] mdadm: remove bitmap file support
Message-ID: <20241121091500.00004ce6@linux.intel.com>
In-Reply-To: <6e8270ba-a188-96ff-d8c5-30a3dc614be6@huaweicloud.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
	<20241120064637.3657385-4-yukuai1@huaweicloud.com>
	<20241120112730.00002cbe@linux.intel.com>
	<6e8270ba-a188-96ff-d8c5-30a3dc614be6@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit

On Thu, 21 Nov 2024 09:25:50 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> > BitmapUnknown should be used only if we failed to parse bitmap setting in
> > cmdline. Otherwise first and default value should be always BitmapNone
> > because data access is always highest priority and dropping bitmap is always
> > safe. We can print warning in config parse failed or bitmap value is
> > repeated- it is reasonable. If I'm wrong here, please let me know.  
> 
> Hi, there is a little difference betewwn BitmapNone and BitmapUnknow, if
> user doesn't pass in the "bitmap=xxx", then the BitmapUnkonw will be
> used to decide choosing BitmapNone or BimtapInternal based on the disk
> size. In Create:
> 
>          if (!s->bitmap_file &&
>          ©®   !st->ss->external &&
>          ©®   s->level >= 1 &&
>          ©®   st->ss->add_internal_bitmap &&
>          ©®   s->journaldisks == 0 &&
>          ©®   (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
>          ©®    s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
>          ©®   (s->write_behind || s->size > 100*1024*1024ULL)) {
>                  if (c->verbose > 0)
>                          pr_err("automatically enabling write-intent 
> bitmap on large array\n");
>                  s->bitmap_file = "internal";
>          }
> 
> And I realized that I should used BitmapUnknow here, not BimtapNone.

Oh yes.. Looking on that from the interface perspective suggest me that we
should remove it and always let user to decide. If the are not satisfied with
resync times they can enable bitmap in any moment but it may cause functional
regression for users that are used to this auto turning on.

Maybe, we can move it to main() and ask without checking raid size, assuming
that array size <100GB is used mainly for testing nowadays?

Here, proposal based on current code, your change may require some adjustments:

diff --git a/mdadm.c b/mdadm.c
index 8cb4ba66ac20..2e803d441dd4 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1535,6 +1535,13 @@ int main(int argc, char *argv[])
                        break;
                }

+               if (!s->bitmap_file && !c.runstop != 1 && s->level >= 1) {
+                       int response = ask("To optimalize resync speed, it is
  recommended to enable write-indent bitmap, do you want to enable it now?");
+
+                       if (response)
+                               s->bitmap_file = "internal";
+               }
+
                rv = Create(ss, &ident, devs_found - 1, devlist->next, &s, &c);
                break;
        case MISC:

This is more reasonable than auto-forcing bitmap without possibility
to skip it (even for testing). I added c->runstop verification because it is
often used in Create to skip some errors and questions.

What do you think?

Thanks,
Mariusz
