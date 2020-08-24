Return-Path: <SRS0=MG8V=CC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38421C433E1
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 15:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131102065F
	for <linux-raid@archiver.kernel.org>; Mon, 24 Aug 2020 15:15:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QXxioiPo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgHXPPU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Aug 2020 11:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725890AbgHXPNf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 24 Aug 2020 11:13:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598281999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ORKDCYY7jL5wEmubt8CiX4NmVWBvVQO/aJ4RXJnEME=;
        b=QXxioiPoO28HRryNfStS8ZYpWjEhiiXPjXg3dDPfi7w6hnUjcs2IGHYdg60KteHIHRH31B
        b2txsZMkewdYDFZnUUM30JnT+32y+qi69/lnfffqN33AmvXN5iN+u7tyVwm468uNxCGoY7
        LUixzSEHK8T1AxpyfHIQHcaoJMTrUrc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-6DHFAYy9N3OUEN4utDNoVw-1; Mon, 24 Aug 2020 11:13:01 -0400
X-MC-Unique: 6DHFAYy9N3OUEN4utDNoVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CA8A425CD;
        Mon, 24 Aug 2020 15:13:00 +0000 (UTC)
Received: from [10.72.8.21] (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA19419C58;
        Mon, 24 Aug 2020 15:12:56 +0000 (UTC)
Subject: Re: [PATCH V4 4/5] md/raid10: improve raid10 discard request
To:     kernel test robot <lkp@intel.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     kbuild-all@lists.01.org, heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
References: <1598242308-9619-5-git-send-email-xni@redhat.com>
 <202008242114.1eBgvHc5%lkp@intel.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <fc1f613a-9148-e98f-38a1-687308b8f4ba@redhat.com>
Date:   Mon, 24 Aug 2020 23:12:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <202008242114.1eBgvHc5%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

I can build successfully based on the latest upstream version

[xni@xiao md]$ git branch
   master
* md-next
[xni@xiao md]$ git pull
Already up-to-date.

Makefile:
VERSION = 5
PATCHLEVEL = 9
SUBLEVEL = 0
EXTRAVERSION = -rc1

Regards
Xiao

On 08/24/2020 09:31 PM, kernel test robot wrote:
> Hi Xiao,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on song-md/md-next]
> [also build test ERROR on v5.9-rc2 next-20200824]
> [cannot apply to md/for-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Xiao-Ni/md-raid10-move-codes-related-with-submitting-discard-bio-into-one-function/20200824-131217
> base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> config: i386-randconfig-a015-20200824 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>          # save the attached .config to linux build tree
>          make W=1 ARCH=i386
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     ld: drivers/md/raid10.o: in function `raid10_handle_discard':
>     drivers/md/raid10.c:1624: undefined reference to `__umoddi3'
>>> ld: drivers/md/raid10.c:1628: undefined reference to `__umoddi3'
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

