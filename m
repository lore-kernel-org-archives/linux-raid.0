Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD8A18870F
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 07:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732262163; cv=none; b=iUNic8nY2xbt8EHQ6x5ycdlzrxBEiFcHSoQQHzUj/s3acWZT5jdSfK64e0rewjNY+EiRcx6eZZvSEK6NRVg34dohAzzZmAZuhN27+vo1F4wbbu3MPN8RCGr0oTIChiPAAQtqLL95W1jrjwXofyvYaRCf5iYNP97xXXzFuJTxYHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732262163; c=relaxed/simple;
	bh=0OWYQ1QXueMX722sS1kUQ68XdtFJe3s7RbPP2KGvwBg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gzzOlj0tdL/YI4SRwtRBycBMw4z0W8Usn6KVYYFxs7mGUYSuJa4xXL90dV6vILaDPqVgWHhUvskUqbPSHPMH88Bug0ddOn11xdmb4yELD4SsHVZX2ABN3Qo44Zj1eHaOx3dUZSdhtVLrUDaZIvsyHI81iaOTgws8LiXE8JjmVGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DlPQXQc4; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DlPQXQc4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732262162; x=1763798162;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0OWYQ1QXueMX722sS1kUQ68XdtFJe3s7RbPP2KGvwBg=;
  b=DlPQXQc4166H8MqNxmbYRlQOd/VXGWAXLokGReIEVK3jw+p36ky41TkH
   sXzbVMMgmq8xq0RA+DVIXfWMSrH6SZjom1sCmX/9XO2xIBDV1GmVC6Hdt
   0yYvY9FDOkEg6ky6ozV3kxjpkFlqINypUxAjybe3ZPqrkzf2aHae0MOcc
   FA6Gp0Xlh+ofyGOHMwjtj6FE3Jc4pOz4F2LE51XRi0uHTN2D0xPgR6v9n
   pGT2eIqS3x/tc/8XGOckWx9rYkY/qpWsr9xvV93OCg6+k3gq+r1x4WYjQ
   YjIXlX3KVSOVZmDzdapuMH3Y8ISXegqoDg99CkyDe94C3pZ5//g9AoF/2
   A==;
X-CSE-ConnectionGUID: 0U8QMwWOTcybddJl5K2mDQ==
X-CSE-MsgGUID: 6pWsB0gAQ8mnyBYcxdOB6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32157447"
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="32157447"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 23:56:02 -0800
X-CSE-ConnectionGUID: H5ZgRDB7Syqc4iLrdFRCvg==
X-CSE-MsgGUID: mM3+eZE9R4O6khwlnJM8uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="90303152"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.114.5])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 23:56:00 -0800
Date: Fri, 22 Nov 2024 08:55:55 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yangerkun@huawei.com, "yukuai (C)"
 <yukuai3@huawei.com>
Subject: Re: [PATCH v3 3/4] mdadm: remove bitmap file support
Message-ID: <20241122085555.00003318@linux.intel.com>
In-Reply-To: <122fe099-6e2b-8b1e-a9c2-d027cadb08b8@huaweicloud.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
	<20241120064637.3657385-4-yukuai1@huaweicloud.com>
	<20241120112730.00002cbe@linux.intel.com>
	<6e8270ba-a188-96ff-d8c5-30a3dc614be6@huaweicloud.com>
	<20241121091500.00004ce6@linux.intel.com>
	<122fe099-6e2b-8b1e-a9c2-d027cadb08b8@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit

On Fri, 22 Nov 2024 09:13:18 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> ÔÚ 2024/11/21 16:15, Mariusz Tkaczyk Ð´µÀ:
> > On Thu, 21 Nov 2024 09:25:50 +0800
> > Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >   
> >>> BitmapUnknown should be used only if we failed to parse bitmap setting in
> >>> cmdline. Otherwise first and default value should be always BitmapNone
> >>> because data access is always highest priority and dropping bitmap is
> >>> always safe. We can print warning in config parse failed or bitmap value
> >>> is repeated- it is reasonable. If I'm wrong here, please let me know.  
> >>
> >> Hi, there is a little difference betewwn BitmapNone and BitmapUnknow, if
> >> user doesn't pass in the "bitmap=xxx", then the BitmapUnkonw will be
> >> used to decide choosing BitmapNone or BimtapInternal based on the disk
> >> size. In Create:
> >>
> >>           if (!s->bitmap_file &&
> >>           ©®   !st->ss->external &&
> >>           ©®   s->level >= 1 &&
> >>           ©®   st->ss->add_internal_bitmap &&
> >>           ©®   s->journaldisks == 0 &&
> >>           ©®   (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
> >>           ©®    s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
> >>           ©®   (s->write_behind || s->size > 100*1024*1024ULL)) {
> >>                   if (c->verbose > 0)
> >>                           pr_err("automatically enabling write-intent
> >> bitmap on large array\n");
> >>                   s->bitmap_file = "internal";
> >>           }
> >>
> >> And I realized that I should used BitmapUnknow here, not BimtapNone.  
> > 
> > Oh yes.. Looking on that from the interface perspective suggest me that we
> > should remove it and always let user to decide. If the are not satisfied
> > with resync times they can enable bitmap in any moment but it may cause
> > functional regression for users that are used to this auto turning on.
> > 
> > Maybe, we can move it to main() and ask without checking raid size, assuming
> > that array size <100GB is used mainly for testing nowadays?
> > 
> > Here, proposal based on current code, your change may require some
> > adjustments:
> > 
> > diff --git a/mdadm.c b/mdadm.c
> > index 8cb4ba66ac20..2e803d441dd4 100644
> > --- a/mdadm.c
> > +++ b/mdadm.c
> > @@ -1535,6 +1535,13 @@ int main(int argc, char *argv[])
> >                          break;
> >                  }
> > 
> > +               if (!s->bitmap_file && !c.runstop != 1 && s->level >= 1) {
> > +                       int response = ask("To optimalize resync speed, it
> > is recommended to enable write-indent bitmap, do you want to enable it
> > now?"); +
> > +                       if (response)
> > +                               s->bitmap_file = "internal";
> > +               }
> > +
> >                  rv = Create(ss, &ident, devs_found - 1, devlist->next, &s,
> > &c); break;
> >          case MISC:
> > 
> > This is more reasonable than auto-forcing bitmap without possibility
> > to skip it (even for testing). I added c->runstop verification because it is
> > often used in Create to skip some errors and questions.
> > 
> > What do you think?  
> 
> I think it's good! I used to be curious why bitmap is not enabled by
> default for testing, and have to look into the source code.
> 
One note here (this one is easy to be missed):
If user set --bitmap=None we should not prompt this question, assuming that user
already made his decision. You need to differentiate default BitmapNone
and user defined BitmapNone (boolean is_bitmap_set should be fine, because
adding another enum status is not valuable I think).

Mariusz
