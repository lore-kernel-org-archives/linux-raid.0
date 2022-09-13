Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D208C54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 07:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiIMHgK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 03:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiIMHgJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 03:36:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF857E12
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 00:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663054567; x=1694590567;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hz3h9c9Nnp7CVFUQPFGa5uYxR2hWkt1EUgGa0uYX+D0=;
  b=eGBGwmozkFlFMnumJBlP9Z205mkeu8uF+IEvsX+sT1D6bGmH0OrYykQC
   W52tHqM4nPX3/qZkYzOuGXsml5i8eagqrYxS2/Wssd7bDjQ4CQX3jbCw1
   kwmx8H0HSbeb6S8/QCOLn/Bfa7FPTPSPlM0m4oMD26aPxtLQfRe221wqe
   50q6ENk08KRtlDcsZhZLd+Fv62Vv9Hi7z1I/DRWR2Y1smx5gyiWDuaU6o
   asNMOkED3chzq/7IwLfsPcXMfPa7TjIbKevscVhYLSQ5p3I0NpJexcWm/
   4i/8VpdKyGqEy/jpkCSxJAQ9bANpV0cxnJpU81fRxlqbB31x/LRjBjtw8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="362017539"
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="362017539"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 00:36:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="678450486"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.207])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 00:36:04 -0700
Date:   Tue, 13 Sep 2022 09:35:59 +0200
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
Message-ID: <20220913093559.0000438b@linux.intel.com>
In-Reply-To: <6dd46583-05ef-12e7-8a37-b732cbe79f23@deltatee.com>
References: <20220908230847.5749-1-logang@deltatee.com>
 <20220908230847.5749-2-logang@deltatee.com>
 <20220909115749.00007431@linux.intel.com>
 <6dd46583-05ef-12e7-8a37-b732cbe79f23@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 9 Sep 2022 09:47:21 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:
> >> +{
> >> +	uint64_t range[2] = {offset, size};  
> > Probably you don't need to specify [2] but it is not an issue I think.
> >   
> >> +	unsigned long buf[4096 / sizeof(unsigned long)];  
> > 
> > Can you use any define for 4096?   
> 
> I don't see any appropriate defines in the code base. It really just
> needs to be bigger than any O_DIRECT restrictions. 4096 bytes is usually
> the worst case.

See comment bellow.
> 
> >> +	unsigned long i;
> >> +
> >> +	if (c->verbose)
> >> +		printf("discarding data from %lld to %lld on: %s\n",
> >> +		       offset, size, devname);
> >> +
> >> +	if (ioctl(fd, BLKDISCARD, &range)) {
> >> +		pr_err("discard failed on '%s': %m\n", devname);
> >> +		return 1;
> >> +	}
> >> +
> >> +	if (pread(fd, buf, sizeof(buf), offset) != sizeof(buf)) {
> >> +		pr_err("failed to readback '%s' after discard: %m\n",
> >> devname);
> >> +		return 1;
> >> +	}
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(buf); i++) {
> >> +		if (buf[i]) {
> >> +			pr_err("device did not read back zeros after
> >> discard on '%s': %lx\n",
> >> +			       devname, buf[i]);  
> > In previous version I wanted to leave the message on stderr, but just move a
> > data (buf[i]) to debug, or if (verbose > 0).
> > I think that printing binary data in error message is not necessary.  
> 
> I added the hex because it might be informative to know what a discard
> did to the device (all FFs or random data).
> 
> > BTW. I'm not sure if discard ensures that data will be all zero. It causes
> > that drive drops all references but I doesn't mean that data is zeroed.
> > Could you please check it in documentation? Should we expect zeroes?  
> 
> That's correct. I discussed this in the cover letter. That's why this
> check is here. Per some of the discussion from others I still think the
> best course of action is to just check what the discard did and fail if
> it is non-zero. Even though many NVMe and ATA devices have the ability
> to control or query the behaviour, the kernel doesn't support this and
> I don't think it can be relied upon.

It is also controversial approach[1].

I think that the best we can do here is to warn user, for example:
"Please ensure that drive you used return zeros after discard."
We should ask for confirmation (it should be possible to skip with --run).
I would like to leave discard feature validation on user side, it is not mdadm
task. Simply, if you want to use it, then it is done on your own risk and
hopefully you know what you want to achieve.
That will simplify implementation on mdadm side. What do you think?

> >> @@ -945,6 +983,15 @@ int Create(struct supertype *st, char *mddev,
> >>  				}
> >>  				if (fd >= 0)
> >>  					remove_partitions(fd);
> >> +
> >> +				if (s->discard &&
> >> +				    discard_device(c, fd, dv->devname,
> >> +						   dv->data_offset << 9,
> >> +						   s->size << 10)) {
> >> +					ioctl(mdfd, STOP_ARRAY, NULL);
> >> +					goto abort_locked;
> >> +				}
> >> +  
> > Feel free to use up to 100 char in one line it is allowed now.
> > Why we need dv->data_offset << 9 and  s->size << 10 here?
> > How this applies to zoned raid0?  
> 
> As I understand it the offset and size will give the bounds of the
> data region on the disk. Do you not think it works for zoned raid0?

mdadm operates on 512B, so using 4K data regions could be destructive.
Also left shift causes that size value is increasing. We can't clear more that
user requested. We need to use 512b sectors as mdadm does.

I don't know how native raid0 size is passed and how zones are created but I
suspect that s->size may not be correct for all drives. It it a global property
but for zoned raid member size could be different. You need to check how it
applies.

Also, I'm not sure if this feature is needed for raid0, because there is no
resync. Maybe we can exclude raid0 from discard?
> 
> >> diff --git a/mdadm.c b/mdadm.c
> >> index 972adb524dfb..049cdce1cdd2 100644
> >> --- a/mdadm.c
> >> +++ b/mdadm.c
> >> @@ -602,6 +602,10 @@ int main(int argc, char *argv[])
> >>  			s.assume_clean = 1;
> >>  			continue;
> >>  
> >> +		case O(CREATE, Discard):
> >> +			s.discard = true;
> >> +			continue;
> >> +  
> > 
> > I would like to set s.assume_clean=true along with discard. Then will be no
> > need to modify other conditions. If we are assuming that after discard all
> > is zeros then we can skip resync, right? According to message, it should be.
> > Please add message for user and set assume_clean too.  
> 
> 
> Well it was my opinion that it was clearer in the code to just
> explicitly include discard in the conditionals instead of making discard
> also set assume-clean, but if you think otherwise I can change it for v3.
> 
> What kind of user message are you thinking is necessary here?

In my convention, all shape attributes should be set in mdadm.c, later they
should be considered as const, we should not overwrite them. This structure
represents user settings.
This is why I consider updating assume_clean in Create.c as wrong. When discard
is set then we are assuming that user want to skip resync too, otherwise it
doesn't have sense. Also, if discard of any drive fails we are returning error
and create operation will fail anyway.

I would expected something like: "Discard requested, setting --assume-clean to
skip resync".
Also, will be great if you can add some tests, at least for command-line.

[1] https://lore.kernel.org/linux-raid/yq1sfkw7yqi.fsf@ca-mkp.ca.oracle.com/T/#t

Thanks,
Mariusz
