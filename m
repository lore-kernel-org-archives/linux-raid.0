Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C611C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 16 May 2022 18:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiEPS00 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 14:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiEPS0Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 14:26:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B39EC2BB1B
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 11:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652725582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ugq1y16zDrq4M9/5Mw29Z4ZsNQv0PeraFVSccu/y04=;
        b=BoB+eyz/bUg+5aVBkCp3o2fkmMPyvT8nDZup9izh1BZD/UFVlgbnTFqeJKKpTz6Z/jkO7E
        kdiSLjib7CjP4X8S0IEP4haBsbAHn9IpUyUV91HfKVNpvW4ybv40AkdPPSqwoY7A8FTWY7
        k1AHpARUJGcbi9a8d8hOyoL49+m3el4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-RF65-FL_MneGI65ZSj5mcQ-1; Mon, 16 May 2022 14:26:21 -0400
X-MC-Unique: RF65-FL_MneGI65ZSj5mcQ-1
Received: by mail-qt1-f197.google.com with SMTP id a18-20020ac85b92000000b002f3c5e0a098so12109736qta.7
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 11:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6ugq1y16zDrq4M9/5Mw29Z4ZsNQv0PeraFVSccu/y04=;
        b=AMapUNj4EOCv9Yio3IQ/ZrifMMEQijruO9UhkksXnhPVpFIE+LCidvHHAb/fJLLS1f
         0PlSg131NVlMUiu3FBNrazNy+wYVBLmd5CALIxkftC9QQaqWc0/8eYCm6nlZ8gt4JlCc
         8xAQIH0H6k6ucO1fwBLrlQ8JT6r/IgjlfAV9HzVNwBNSrpAVp3i2Fv/vnlmNK1Tikn81
         3tbvEPccxIOizcp+NJ8KE2iys0FY59LRGTHJG2my7/C261mIzJpajckyC7cHWRRy4Lnx
         v5w35tXgWXtFOI1ZzV1WZ8f2u38dFvQPq0hvjQMjzaGsO2j+j88xrDnpMZoZyuVOsBdV
         MR6w==
X-Gm-Message-State: AOAM5304YNGB/iLjKwZs3KrVur8aHQf4mPlPpeX5xOevKj5sRIlElGFh
        1ORt4eW0ra5Og+7kBmvv6qZpI94h0DkWmHN7Kr+rIreILgBNC+VBiutoudPxtYi5l5zQt205Vrl
        zxunVUFbcF8IreTZ1NU3M9g==
X-Received: by 2002:ad4:5ba3:0:b0:45a:fd2c:225f with SMTP id 3-20020ad45ba3000000b0045afd2c225fmr16441953qvq.31.1652725581146;
        Mon, 16 May 2022 11:26:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznFqgaidpbYZkFN1/DphZxGtyzeW45ev4Uy2j4oF3L8pVA97bFk1ArtJcEwvZrhHI6Y4222g==
X-Received: by 2002:ad4:5ba3:0:b0:45a:fd2c:225f with SMTP id 3-20020ad45ba3000000b0045afd2c225fmr16441937qvq.31.1652725580977;
        Mon, 16 May 2022 11:26:20 -0700 (PDT)
Received: from [192.168.1.211] (d-137-103-110-215.nh.cpe.atlanticbb.net. [137.103.110.215])
        by smtp.gmail.com with ESMTPSA id i10-20020a05620a074a00b006a059f1d8b8sm6107564qki.124.2022.05.16.11.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 11:26:20 -0700 (PDT)
Message-ID: <d32acbc9-2383-609b-1c67-3f59f97066c0@redhat.com>
Date:   Mon, 16 May 2022 14:26:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: mdadm test suite improvements
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        linux-raid@vger.kernel.org
References: <20220516160941.00004e83@linux.intel.com>
From:   Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <20220516160941.00004e83@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/16/22 10:09 AM, Mariusz Tkaczyk wrote:
> Hello All,
> I'm working on names handling in mdadm and I need to add some new test to
> the mdadm scope - to verify that it is working as desired.
> Bash is not best choice for testing and in current form, our tests are not
> friendly for developers. I would like to introduce another python based test
> scope and add it to repository. I will integrate it with current framework.
> 
> I can see that currently test are not well used and they aren't often updated.
> I want to bring new life to them. Adopting more modern approach seems to be good
> start point.
> Any thoughts?
> 
> Thanks in advance,
> Mariusz
> 

Hello Mariusz,

Python is a great choice. Good with me.

-Nigel

