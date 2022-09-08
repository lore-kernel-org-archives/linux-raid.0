Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E6CC54EE9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Sep 2022 17:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiIHRB6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Sep 2022 13:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiIHRBx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Sep 2022 13:01:53 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8847CEA43E
        for <linux-raid@vger.kernel.org>; Thu,  8 Sep 2022 10:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=zVPGrAt6Uiyw/8nCJ/GhEnVDNUjLpDZZenudY5KNJS8=; b=t3wiF2BEppLl0vg2LhVi8qh53+
        R3Fa+1DSIK6Ri2cnwWx58SR3a6lyyAJNATlk5n+piM0oszcfzueHn9l+vQn8oOIKPdfPvqnqbgVY2
        g1irI9NwVdPzD5WENA88FjC5kar8Gl4CJzUFNLxmU0wWh/MNiQTehOu/e2qh2v1sthJ76LvZ3bG6C
        cFIZ6hmYw7xxGM5AxlqQducaiENR54dAFD50iSIEo+jERt2ZAWwrFVy81RGiFTQ7WL14L4j3+XNng
        N9d2Qo7ufzkh9BOyKaTKoobi25wZCqJTuODUUwET5pT+1KeEg3VT7WE2lMsPH6q7lr6shgn/rFWm0
        QXF2XzRA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oWKuP-001juX-95; Thu, 08 Sep 2022 11:01:46 -0600
Message-ID: <f60c7f6e-aa32-1fd3-654c-6b707c36d37a@deltatee.com>
Date:   Thu, 8 Sep 2022 11:01:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-CA
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220907200355.205045-1-logang@deltatee.com>
 <20220907200355.205045-2-logang@deltatee.com>
 <20220908095611.000072df@linux.intel.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220908095611.000072df@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org, jsorensen@fb.com, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm 1/2] mdadm: Add --discard option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Mariusz,

Thanks for the feedback. I've incorporated it into a v2 patch set which
I will send later today. Specific responses below.

On 2022-09-08 01:56, Mariusz Tkaczyk wrote:
> On Wed,  7 Sep 2022 14:03:54 -0600
> Logan Gunthorpe <logang@deltatee.com> wrote:
> 
>> Add the --discard option for Create which will send BLKDISCARD requests to
>> all disks before assembling the array. This is a fast way to know the
>> current state of all the disks. If the discard request zeros the data
>> on the disks (as is common but not universal) then the array is in a
>> state with correct parity. Thus the initial sync may be skipped.
> 
> Are we discarding whole device or only space for array? I can see that we are
> specifying range in ioctl.

Just the space for the array.

>> +static int discard_device(const char *devname, unsigned long long size)
>> +{
>> +	uint64_t range[2] = {0, size};
> Are we starting always from 0? If yest then it introduces bug. In IMSM there is
> a matrix array conception. Two arrays on same drives.
> I suspect that we are able to erase data from first array when we set --discard
> during second volume creation.

Yes, ok. I'll have this fixed in v2.

>> +	unsigned long buf[4096 / sizeof(unsigned long)];
>> +	unsigned long i;
>> +	int fd;
>> +
>> +	fd = open(devname, O_RDWR | O_EXCL);
> 
> Do we need to to open another RDWR descriptor, I think that mdadm will open
> something again soon. We are opening descriptors many times, it generates
> unnecessary uvents. We can incorporate it with existing logic and add
> discarding just before st->ss->add_to_super() and discard every drive one by
> one.
> We will fail on error anyway.

Ok, that makes sense and cleans things up a bit. This will be included
in v2.
>> +	for (i = 0; i < ARRAY_SIZE(buf); i++) {
>> +		if (buf[i]) {
>> +			pr_err("device did not read back zeros after discard
>> on '%s': %lx\n",
>> +			       devname, buf[i]);
>> +			goto out_err;
> Do we really need to print data here? Could you move it to debug?

This is an error message and describes why we will not be creating the
array (we error out in this case). So I think it is necessary to be a
pr_err().

>> +		if (c->verbose)
>> +			pr_err("discarding all data on: %s\n", dv->devname);
> I know that mdadm is printing messages to stderr mainly but for this one,
> stdout is enough IMO. I give it to you.

Switched to printf() for the informational message in v2.


>> +		if (first_missing >= s->raiddisks)
>> +			s->assume_clean = 1;
> 
> IMO missing drive has nothing to do with clean conception but please correct me
> I'm wrong. All assume_clean does is skipping resync after the creation and that
> is true even if some drives are missing. Array will be still clean but will be
> also degraded.
> 
> If I'm correct then it simplifies implementation because we can set
> s.assume_clean if s.discard is set too in mdadm.c.
> 
> If I'm wrong what is the point of discard when resync is started anyway with
> missing drive? Maybe those features should be mutually exclusive?

I think you are right. I've implemented v2 to just add a s.discard check
to all the cases where s.assume_clean is checked. Makes it simpler and
more clear, rather than changing assume_clean in mdadm.
>> +		case O(CREATE, Discard):
>> +			s.discard = 1;
> please use true.

Done for v2.

>>  	char	*bitmap_file;
>>  	int	assume_clean;
>> +	int	discard;
> 
> please use bool type.

Done for v2.



Logan
