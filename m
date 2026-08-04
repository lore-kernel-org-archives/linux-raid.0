Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2554463B87
	for <linux-raid@vger.kernel.org>; Tue,  4 Aug 2026 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785856049; cv=none; b=S1NbN41JCLasAs0Q3pFVAy+8YoEbl3Kp9IkIRza0P384ZUmwRhTApGXRZ9qqIMgZqgNHYWlF0HQoRBIHHokUo/1YropE1kVrTOBji5o7mQ+hbRrBfCR+urJwMaLnQGSB5U6LTk7eEMUA0x03jDWXXhKfbPzoRBSiMoHVh2jkqcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785856049; c=relaxed/simple;
	bh=3vCX73HTin8OMhCLrL4mg1udeBnAS0Z1tTY+9wzBoW4=;
	h=To:Content-Type:In-Reply-To:Date:From:Message-Id:References:Cc:
	 Subject:Mime-Version; b=NinTsf2V7l3K9/Ak0v+72Yrp4gTdedNIq26cAS3Y1eZppVu1dD5DGbpBxRwnc/GDm4nsws/eZzb7D8GtZeTjPyVv1RAHvXhizY1LodylNb1dW/kBWL+ceXYpipDjT+HNQEvFMXU9puuI1uysO1bGcAwDfDL1K4v1tRGleEQDn50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=V1STQS/d; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="V1STQS/d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785856032;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aTkMnMJBZbmBk8aXgbvQ0jabgPpSOlUfMkXtPY+IHFY=;
 b=V1STQS/dXR/HSPdjfm3Z1JQVZ9XApb10C3EpWxb/YHFtZgCWgot2COjPgsuahxvGehWhgr
 2jq6BOpr2EYgx0tkND9n460gcNbrVty7i3UF7stSYVlVCrTs1/rW3sb2um4NO3Oe2P4RGk
 ZxnEJ/5IVY3VboGAluJxadgFM2cZpuVHeGahtB2wxHDzUpbguPxouapWFWxw9Kza71wEYb
 mZ4yuTbYv+Za8FsD0A7TPmKGdIP6anMykJ/Q8SiOqfHEWQ8zBDn00pl40h7T9nOFdY9NAF
 65lp+fHrKCZSWuhCuqwoidZbx8ATlYLgABCj85lPyKYABL7Yx2DhO0nI3GE9jQ==
To: "Christoph Hellwig" <hch@lst.de>, "Jan Kara" <jack@suse.cz>, 
	"yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260804132527.GA8078@lst.de>
X-Original-From: yu kuai <yukuai@fygo.io>
Date: Tue, 4 Aug 2026 23:07:03 +0800
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <a780016f-8f94-4337-b700-786f5487ca3f@fygo.io>
X-Lms-Return-Path: <lba+26a720020+773d21+vger.kernel.org+yukuai@fygo.io>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-2-yukuai@kernel.org> <prx5s4rwbgoeh7wtgyo7vwydh5iwqn6qc2utamowirsplspfmp@e3eteq5xwuyf> <20260804132527.GA8078@lst.de>
Cc: "Yu Kuai" <yukuai@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Tao Cui" <cui.tao@linux.dev>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <nvdimm@lists.linux.dev>, 
	<virtualization@lists.linux.dev>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v1 1/3] blk-cgroup: add helpers for bio cgroup state
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 15:07:11 +0000

Hi,

=E5=9C=A8 2026/8/4 21:25, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 04, 2026 at 12:52:16PM +0200, Jan Kara wrote:
>> Mostly looks good. Just I think bio_blkcg() should gracefully handle the
>> case where bio->bi_blkg is NULL (and return NULL in that case). That way
>> you can also get rid of somewhat odd pattern:
>>
>> 	if (!bio_blkg(bio))
>> 		return ...;
>> 	do something with bio_blkcg(bio)
>>
>> You can then just check bio_blkcg(bio) directly which is much more obvio=
us.
> Yes.  Looking at the whole series I'm also not sure that this makes too
> much sense as a split out patch as the next one touches more than half
> of the callsite anyway.

Yes, this make sense, I'm trying not to cook a huge patch, but patch 2 is g=
row
much bigger than I was expected. Unless I figure out a nicer way to split p=
atch 2,
I'll merge them in the next version.

>
--=20
Thanks,
Kuai
