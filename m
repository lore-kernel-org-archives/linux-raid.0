Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE22ECAAD3
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 15:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiIIPra (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 11:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiIIPr3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 11:47:29 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728D410B7ED
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 08:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=kBDMZCM3+fME6HAM86IISOMiyLe3ud5HQXYmAJgrreY=; b=ficARkkMnyTwvEHFljfEF8bEYQ
        bogkD5KFfIXeoGBm42/chI8fsvU/2dd6Pig4J8WnOA0hzYYwV0jRfNNjgSwAOw4IcoQeg8RhFE19y
        9gVWqCPaDI3AfVkGWYrboYkIJUBy4JCOfNm0Umo/jGtkrGoDFMQK/B/+9Kr9ISgEPpvMlwDAd1d2G
        IVWgIZlxIq5sua/gecC1DgK69rNTRzGgnx7RykQAEBbm2PUM4iwQ9MPatndF2TOqGq6iMq/pC95CV
        emPnq3ks6SlwHD8/0FyxglI1v1c+qwFP+CGC6XHu/XTpU+gOgVnOV7owGNYiBz1jPSmNWLZgeM46N
        bAQRkcNg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oWgE0-002aaC-Sj; Fri, 09 Sep 2022 09:47:26 -0600
Message-ID: <6dd46583-05ef-12e7-8a37-b732cbe79f23@deltatee.com>
Date:   Fri, 9 Sep 2022 09:47:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220908230847.5749-1-logang@deltatee.com>
 <20220908230847.5749-2-logang@deltatee.com>
 <20220909115749.00007431@linux.intel.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220909115749.00007431@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-09 03:57, Mariusz Tkaczyk wrote:
>> If all the discard requests are successful and there are no missing
>> disks thin it is safe to set assume_clean as we know the array is clean.
> 
> Please update message. We agreed in v1 that missing disks and discard features
> are not related, right?

Oops, yes, I'll update the commit message for v3.


>> +static int discard_device(struct context *c, int fd, const char *devname,
>> +			  unsigned long long offset, unsigned long long size)
> 
> Will be great if you can description.

Ok, will do for v3.

>> +{
>> +	uint64_t range[2] = {offset, size};
> Probably you don't need to specify [2] but it is not an issue I think.
> 
>> +	unsigned long buf[4096 / sizeof(unsigned long)];
> 
> Can you use any define for 4096? 

I don't see any appropriate defines in the code base. It really just
needs to be bigger than any O_DIRECT restrictions. 4096 bytes is usually
the worst case.

>> +	unsigned long i;
>> +
>> +	if (c->verbose)
>> +		printf("discarding data from %lld to %lld on: %s\n",
>> +		       offset, size, devname);
>> +
>> +	if (ioctl(fd, BLKDISCARD, &range)) {
>> +		pr_err("discard failed on '%s': %m\n", devname);
>> +		return 1;
>> +	}
>> +
>> +	if (pread(fd, buf, sizeof(buf), offset) != sizeof(buf)) {
>> +		pr_err("failed to readback '%s' after discard: %m\n",
>> devname);
>> +		return 1;
>> +	}
>> +
>> +	for (i = 0; i < ARRAY_SIZE(buf); i++) {
>> +		if (buf[i]) {
>> +			pr_err("device did not read back zeros after discard
>> on '%s': %lx\n",
>> +			       devname, buf[i]);
> In previous version I wanted to leave the message on stderr, but just move a
> data (buf[i]) to debug, or if (verbose > 0).
> I think that printing binary data in error message is not necessary.

I added the hex because it might be informative to know what a discard
did to the device (all FFs or random data).

> BTW. I'm not sure if discard ensures that data will be all zero. It causes that
> drive drops all references but I doesn't mean that data is zeroed. Could you
> please check it in documentation? Should we expect zeroes?

That's correct. I discussed this in the cover letter. That's why this
check is here. Per some of the discussion from others I still think the
best course of action is to just check what the discard did and fail if
it is non-zero. Even though many NVMe and ATA devices have the ability
to control or query the behaviour, the kernel doesn't support this and
I don't think it can be relied upon.


>> @@ -945,6 +983,15 @@ int Create(struct supertype *st, char *mddev,
>>  				}
>>  				if (fd >= 0)
>>  					remove_partitions(fd);
>> +
>> +				if (s->discard &&
>> +				    discard_device(c, fd, dv->devname,
>> +						   dv->data_offset << 9,
>> +						   s->size << 10)) {
>> +					ioctl(mdfd, STOP_ARRAY, NULL);
>> +					goto abort_locked;
>> +				}
>> +
> Feel free to use up to 100 char in one line it is allowed now.
> Why we need dv->data_offset << 9 and  s->size << 10 here?
> How this applies to zoned raid0?

As I understand it the offset and size will give the bounds of the
data region on the disk. Do you not think it works for zoned raid0?

>> diff --git a/mdadm.c b/mdadm.c
>> index 972adb524dfb..049cdce1cdd2 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -602,6 +602,10 @@ int main(int argc, char *argv[])
>>  			s.assume_clean = 1;
>>  			continue;
>>  
>> +		case O(CREATE, Discard):
>> +			s.discard = true;
>> +			continue;
>> +
> 
> I would like to set s.assume_clean=true along with discard. Then will be no need
> to modify other conditions. If we are assuming that after discard all is zeros
> then we can skip resync, right? According to message, it should be.
> Please add message for user and set assume_clean too.


Well it was my opinion that it was clearer in the code to just
explicitly include discard in the conditionals instead of making discard
also set assume-clean, but if you think otherwise I can change it for v3.

What kind of user message are you thinking is necessary here?

Logan
