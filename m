Return-Path: <SRS0=MG8V=CC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1440C433E1
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 15:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D842071E
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 15:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9RFtmak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHXPx7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:53:59 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44898 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725973AbgHXPx5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 Aug 2020 11:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598284436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U9/QlHV9o4B1775YJWJPZb+wZfaHlXXDFg3pVvveGj4=;
        b=T9RFtmak93/lWNESEL+m8X0gSJx6q0laBqW/xoKZ8+LLht5CtBg3ur0fhwcIAtlRbGqAyS
        C6cyfP3OhaDd3ZaRwfJV1/UYPbrqIRIDfc7Mv8s1dYwEWmNGz+09Bt7tGMFmSnqDKI3mw0
        QZNRKOlfIbE+jpNcK8Ku0UeJxgmgE2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-3z0P4tqFPB2uSMvUKDCbOA-1; Mon, 24 Aug 2020 11:53:39 -0400
X-MC-Unique: 3z0P4tqFPB2uSMvUKDCbOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47A32807336;
        Mon, 24 Aug 2020 15:53:38 +0000 (UTC)
Received: from [10.72.8.21] (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B94E619144;
        Mon, 24 Aug 2020 15:53:34 +0000 (UTC)
Subject: Re: [PATCH V4 4/5] md/raid10: improve raid10 discard request
From:   Xiao Ni <xni@redhat.com>
To:     kernel test robot <lkp@intel.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     kbuild-all@lists.01.org, heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
References: <1598242308-9619-5-git-send-email-xni@redhat.com>
 <202008242114.1eBgvHc5%lkp@intel.com>
 <fc1f613a-9148-e98f-38a1-687308b8f4ba@redhat.com>
Message-ID: <9817552a-6a00-b2e5-8634-6d1edc210212@redhat.com>
Date:   Mon, 24 Aug 2020 23:53:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <fc1f613a-9148-e98f-38a1-687308b8f4ba@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I downloaded the .config in my environment and use `make W=1 ARCH=i386` 
to build the kernel.
It fails.
drivers/md/raid10.o: In function `raid10_handle_discard':
/home/xni/codes/md/drivers/md/raid10.c:1644: undefined reference to 
`__umoddi3'
/home/xni/codes/md/drivers/md/raid10.c:1648: undefined reference to 
`__umoddi3'
make: *** [Makefile:1167: vmlinux] Error 1

It's my first time to see these errors. I'll try to fix the error and 
send the patch again.

Regards
Xiao

On 08/24/2020 11:12 PM, Xiao Ni wrote:
> Hi all
>
> I can build successfully based on the latest upstream version
>
> [xni@xiao md]$ git branch
>   master
> * md-next
> [xni@xiao md]$ git pull
> Already up-to-date.
>
> Makefile:
> VERSION = 5
> PATCHLEVEL = 9
> SUBLEVEL = 0
> EXTRAVERSION = -rc1
>
> Regards
> Xiao
>
> On 08/24/2020 09:31 PM, kernel test robot wrote:
>> Hi Xiao,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on song-md/md-next]
>> [also build test ERROR on v5.9-rc2 next-20200824]
>> [cannot apply to md/for-next]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
>>
>> url: 
>> https://github.com/0day-ci/linux/commits/Xiao-Ni/md-raid10-move-codes-related-with-submitting-discard-bio-into-one-function/20200824-131217
>> base: git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
>> config: i386-randconfig-a015-20200824 (attached as .config)
>> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
>> reproduce (this is a W=1 build):
>>          # save the attached .config to linux build tree
>>          make W=1 ARCH=i386
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>     ld: drivers/md/raid10.o: in function `raid10_handle_discard':
>>     drivers/md/raid10.c:1624: undefined reference to `__umoddi3'
>>>> ld: drivers/md/raid10.c:1628: undefined reference to `__umoddi3'
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>

