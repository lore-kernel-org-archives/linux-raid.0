Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA66ECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 12:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiINMBh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 08:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiINMB0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 08:01:26 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B392F7FFAE
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 05:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663156876; x=1694692876;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lZOV8uk3LvQ7wz/ANPctOtuVNJt6R4HfeLuDojckD50=;
  b=VpY5cGsGt7oZkV3bsTqh2T8ChE296zKwylMtlZiZ6XH0o6lkS6mk/6Un
   80luPSNwXFWJ3Zx53N65qD3sSRgpdCK8seGno6cMIyld1l6EvzG0ayq2I
   tL1vfKb+bG9hF8L1nx6SDlPzDilrK7FzgCt5eJbaec1AvgZrcI9Pa6dk+
   WO5FwvJRf0tDRFg4lUiTLkopNkzqZ2qnUSDpABjdAPFZ9Tch8bldDfNUC
   kPBx3gHr1wsJD0oOTvdVgzMiMiblKGwD2rogdQYWOtdEKygyae9vwtOVn
   KJpKTEulpbVkTYHLceb1stv0QHq/YGWHywM0jfiQQN6DOVpyLpXrml+zK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="362371586"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="362371586"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 05:01:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="679014708"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.226])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 05:01:11 -0700
Date:   Wed, 14 Sep 2022 14:01:06 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
Message-ID: <20220914140106.00000b36@linux.intel.com>
In-Reply-To: <856072cb-ebdf-52fe-1a13-857763077bca@deltatee.com>
References: <20220908230847.5749-1-logang@deltatee.com>
        <20220908230847.5749-2-logang@deltatee.com>
        <20220909115749.00007431@linux.intel.com>
        <6dd46583-05ef-12e7-8a37-b732cbe79f23@deltatee.com>
        <20220913093559.0000438b@linux.intel.com>
        <856072cb-ebdf-52fe-1a13-857763077bca@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 13 Sep 2022 09:43:52 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 2022-09-13 01:35, Mariusz Tkaczyk wrote:
> > On Fri, 9 Sep 2022 09:47:21 -0600
> > Logan Gunthorpe <logang@deltatee.com> wrote:  
> >>>> +{
> >>>> +	uint64_t range[2] = {offset, size};    
> >>> Probably you don't need to specify [2] but it is not an issue I think.
> >>>     
> >>>> +	unsigned long buf[4096 / sizeof(unsigned long)];    
> >>>
> >>> Can you use any define for 4096?     
> >>
> >> I don't see any appropriate defines in the code base. It really just
> >> needs to be bigger than any O_DIRECT restrictions. 4096 bytes is usually
> >> the worst case.  
> > 
> > See comment bellow.  
> 
> I don't see how the comment below relates to this at all. This 4k has
> nothing to do with anything related to the array, it wos only a
> convenient size to read and check the result. But per Martin's points,
> this code will go away in v3 seeing it's more appropriate to use
> WRITE_ZEROS and that interface guarantees that there will be zeros, thus
> no need to check.

I suggested to skip verification at all in next comment but as you said with
WRITE_ZEROS it is not needed anyway. Sorry for being inaccurate.

> 
> 
> >> That's correct. I discussed this in the cover letter. That's why this
> >> check is here. Per some of the discussion from others I still think the
> >> best course of action is to just check what the discard did and fail if
> >> it is non-zero. Even though many NVMe and ATA devices have the ability
> >> to control or query the behaviour, the kernel doesn't support this and
> >> I don't think it can be relied upon.  
> > 
> > It is also controversial approach[1].
> > 
> > I think that the best we can do here is to warn user, for example:
> > "Please ensure that drive you used return zeros after discard."
> > We should ask for confirmation (it should be possible to skip with --run).
> > I would like to leave discard feature validation on user side, it is not
> > mdadm task. Simply, if you want to use it, then it is done on your own risk
> > and hopefully you know what you want to achieve.
> > That will simplify implementation on mdadm side. What do you think?  
> 
> I think the better approach is to just use WRITE_ZEROS.

Agree.

> 
> >>>> @@ -945,6 +983,15 @@ int Create(struct supertype *st, char *mddev,
> >>>>  				}
> >>>>  				if (fd >= 0)
> >>>>  					remove_partitions(fd);
> >>>> +
> >>>> +				if (s->discard &&
> >>>> +				    discard_device(c, fd, dv->devname,
> >>>> +						   dv->data_offset << 9,
> >>>> +						   s->size << 10)) {
> >>>> +					ioctl(mdfd, STOP_ARRAY, NULL);
> >>>> +					goto abort_locked;
> >>>> +				}
> >>>> +    
> >>> Feel free to use up to 100 char in one line it is allowed now.
> >>> Why we need dv->data_offset << 9 and  s->size << 10 here?
> >>> How this applies to zoned raid0?    
> >>
> >> As I understand it the offset and size will give the bounds of the
> >> data region on the disk. Do you not think it works for zoned raid0?  
> > 
> > mdadm operates on 512B, so using 4K data regions could be destructive.
> > Also left shift causes that size value is increasing. We can't clear more
> > that user requested. We need to use 512b sectors as mdadm does.  
> 
> I don't really follow this.

I understand that you want left shit is used to round size to data region
and I assumed that data_region is 4K and that is probably wrong.
You are right I has no sense, my apologizes.

Let's imagine that our size is for example, 2687 sectors. Left shit will
cause that we will get 2751488 and that will be passed as a size to function.
Similar for data_offset. That is much more than we want to clear.
Do I miss something? I guess that ioctl operates on sectors too but please
correct me if that is wrong.

> 
> > I don't know how native raid0 size is passed and how zones are created but I
> > suspect that s->size may not be correct for all drives. It it a global
> > property but for zoned raid member size could be different. You need to
> > check how it applies.  
> 
> > Also, I'm not sure if this feature is needed for raid0, because there is no
> > resync. Maybe we can exclude raid0 from discard?  
> 
> I'll check raid0 size. If possible I'd rather not have the restriction
> to avoid raid0 as it becomes complicated and users may have reason to
> zero besides avoiding resync.

Agree, thanks.

> >>
> >> Well it was my opinion that it was clearer in the code to just
> >> explicitly include discard in the conditionals instead of making discard
> >> also set assume-clean, but if you think otherwise I can change it for v3.
> >>
> >> What kind of user message are you thinking is necessary here?  
> > 
> > In my convention, all shape attributes should be set in mdadm.c, later they
> > should be considered as const, we should not overwrite them. This structure
> > represents user settings.
> > This is why I consider updating assume_clean in Create.c as wrong. When
> > discard is set then we are assuming that user want to skip resync too,
> > otherwise it doesn't have sense. Also, if discard of any drive fails we are
> > returning error and create operation will fail anyway.  
> 
> The v2 version of this patch did not modify the shape attributes in
> Create.c; that was only in v1.

Ok, I missed that, thanks.
> 
> > I would expected something like: "Discard requested, setting --assume-clean
> > to skip resync".
> > Also, will be great if you can add some tests, at least for command-line.  
> 
> Ok.
> 

Mariusz
