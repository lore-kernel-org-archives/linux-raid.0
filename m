Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72704C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  6 Oct 2021 11:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA93610FC
	for <linux-raid@archiver.kernel.org>; Wed,  6 Oct 2021 11:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbhJFLUk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Oct 2021 07:20:40 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17299 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238227AbhJFLUj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Oct 2021 07:20:39 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633519103; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=G/zQF7r9pyG1qTzP+H2flv8wowOqabp3qXM7ZC06o5oc7Hgmvlcf2+8Sg+vKiE01lf6ZSdeRFSO+MlwYZPnNIhicQOxlMqGVuq5bUrsPuH1Vl2Hs7eWYkpwZc7mv4pwCWLJN9zmR2xaMZkL2OYrVXuz5oKTifIwYb3y9D9KZcDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633519103; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OSeEoy4wzVkjMLIVnyFortrXbJu60akKNe17Cu1TTG4=; 
        b=ir+Lp664M5V2W2J3NgHSdrvKYqZV+qlzlvXa+EaHTDdsnvjkHBokRyk3DtwwE087/Y1/OnmaNDBv2cUbx7iHosuRo3ADpz2dtkCEA3M7DE7inchZWf17ie/zIma5LAET7Ni/rR5gsr+fNJlMnUyL5eBfG4ts7C2G4IgHZle91FE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.4.32] (85.184.170.180 [85.184.170.180]) by mx.zoho.eu
        with SMTPS id 1633519100574797.4012519597119; Wed, 6 Oct 2021 13:18:20 +0200 (CEST)
Subject: Re: The mdadm maintenance
To:     Coly Li <colyli@suse.de>, Jes Sorensen <jsorensen@fb.com>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        "hare@suse.de" <hare@suse.de>, pmenzel@molgen.mpg.de,
        linux-raid <linux-raid@vger.kernel.org>
References: <c27798e0-dc8b-7058-4347-732d7162f011@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <7053cc53-3947-bfb1-4d0f-f12f8630ca9d@trained-monkey.org>
Date:   Wed, 6 Oct 2021 07:18:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c27798e0-dc8b-7058-4347-732d7162f011@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/5/21 11:01 AM, Coly Li wrote:
> Hi Jes,
> 
> As Paul and Mariusz suggested, I post this email for your opinion.
> 
> From the recent communication on linux-raid mailing list, I know and
> fully understand you are too busy to take care mdadm and response other
> developers in time. I'd like to help to maintainer mdadm project if you
> are glad to. I am very happy with my current job and employer, it is
> very probably I can be stable on the maintenance role for quite long
> time before I am retired (maybe 20+ years if I may live that long time).
> 
> So if you feel it works, and other folks on linux-raid being supportive,
> I'd like to take the maintenance of mdadm and keep things moving
> forward. Now I am bcache (linux/drivers/md/bcache/) maintainer of
> upstream Linux kernel, and SUSE internal md raid and mdadm maintainer.
> Taking care of mdadm can be my daily regular job for quite long time.
> 
> Thanks in advance for your response.

Hi Coly,

Thanks for starting this separate discussion. I'll try and address
issues Mariusz raised as well.

I am currently on paternity leave and traveling visiting family in
Denmark, so our 9 month old daughter gets to know her family here. I
only have my laptop and not access to my other computers and my time is
limited too. I had hoped to get 4.2 out the door before leaving mid
August but there was a sudden influx of patches that meant it didn't happen.

I look after mdadm in my spare time, it is not something I do as my
daytime jop anymore. I am totally open to discussing the process, but
keep in mind maintainership isn't just an issue of applying patches. It
is necessary to crititcally review and consider if patches are the right
thing to do. Mariusz has been pretty good helping out reviewing other
patches, but there is not a lot of activity reviewing patches from other
sides, in particular third party reviews of patches coming from Intel.
One thing that would help a lot is more effort in this area.

We also need to look at what we want to do first. What should go in 4.2
and what goes in later? In rc mode we shouldn't just apply anything,
especially new features. One suggestion for improvement is that people
tag patches for the rc release at this point. While I don't see 40-50
patches in my queue, it would be helpful if authors could ping for the
ones that really should go into 4.2.

I can try and go over the list for urgent patches, and apply them, but
keep in mind the testing I can do is rather limited right now.

Lets try and get 4.2 done and then we can figure out where we want to go
after that.

Jes
