Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78190EE49A5
	for <linux-raid@archiver.kernel.org>; Tue, 22 Aug 2023 20:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjHVUy3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Aug 2023 16:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjHVUy3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Aug 2023 16:54:29 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B935F1BE
        for <linux-raid@vger.kernel.org>; Tue, 22 Aug 2023 13:54:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1692737642; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ZbUlI+RDCnL/1owGcEbXbRD0xOCgKvnQRKmczXs92qkY4oOvUcEaQjz2CpXAlNzVzmkGc4xqyzb1X1wGwpwHB8RUrlCmH8Bs3tSnkNYfCPFdsrRzRl21Amrdx9KjDeC07kV58h5F9XlYZDe6VK7GOOc15LErUgBp+UfrGOI8YHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1692737642; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LxsKo8q6uMSuJcw7dON52kxujNXYZ3DMvV+VI8AUXWY=; 
        b=Mbg31ugnq2mO/qJyoQ0K53ibogHzdHQM4ujmZ56XyeJFl7KSXJV+I7FUT0V/W36qD9n9um3YxF3X6N4wuQKAcw41AUFFkiauDcYTnOJ1OPNJGk6FHraMnjZu/qzL6IRSngTl0pjHqUNcqoYXVqF5zp6rYuNte0gZPr0sEZaLuVQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1692737641820451.6538615909391; Tue, 22 Aug 2023 22:54:01 +0200 (CEST)
Message-ID: <24acd8dc-e3c6-cfb1-3fba-42d1d0699b39@trained-monkey.org>
Date:   Tue, 22 Aug 2023 16:54:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: libsed in mdadm
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Xiao Ni <xni@redhat.com>,
        Paul E Luse <paul.e.luse@linux.intel.com>,
        Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org
References: <20230821161604.000048c7@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230821161604.000048c7@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/21/23 10:16, Mariusz Tkaczyk wrote:
> Hello,
> IMSM/VROC is going to support self-encrypted drives. With this feature you need
> to unlock the drives during boot-up in UEFI first. It is kind of protection
> from physical stealing.
> 
> To ensure security, Linux have to respect that. It means that we need to
> determine if the drive support locking and do not allow to mix locked and
> unlocked drives in one IMSM array.
> 
> To grab that information we will need to impose the "magic commands" to the
> drives. There is a libsed library, designed for such purposes:
> https://github.com/sedcli/sedcli
> 
> So far I know, this library is not released under distributions (not handled by
> package managers) and that will bring not user friendly dependency- you will
> need to compile and install the lib first to build mdadm.
> 
> The sedcli project is maintained in Intel, currently it is not in active
> development but there are no plans to drop it, interest around it is growing as
> you can see. It seems to be great opportunity for this project to
> become integrated with mainstream distributions when mdadm will start to
> require it.
> 
> So, my questions are: Are we fine with adding this dependency? Are there big
> cons you see?
> Obviously, I will make it optional like libudev is.
> 
> I can try to re-implement the functionality I need in mdadm but it is like
> reinventing the wheel.
> 
> Any feedback will be appreciated.

Hi Mariusz,

I am not against adding it to mdadm, though I think a better approach is
to try and get the library built as a package for the distros.

Did you look into that yet?

Thanks,
Jes


