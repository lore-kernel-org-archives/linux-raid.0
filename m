Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADBD8C10F1B
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 13:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiLSNJK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 08:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiLSNJI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 08:09:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E4AFCEB
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 05:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671455346; x=1702991346;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8p97AKxrrEASq2tLEozZ5DIFzGFMgp6J5M2jwFGGEDk=;
  b=AmW2NVfwPvxQcNaQMC+zFYpbY79T/o92ybzFEw/snfOyGsCVeRaSA22Q
   s93oJl1bPwOOcusPagPNlCsbKG7YuAbUAU3H2jouxHy866qcv2UBQbaSP
   yfYFyHVacEzfgguH++tWiVoPirQZs6duajJmtJlyq/Wmdf9k2wNabpzi0
   Pzcjse9+ui4v4ikckhIpKJAqtPZW8BYijGZMUo4VrDNCIUBH6apx0I7TY
   4yfU/RQ6hcS4q8pEGytcsyaA0lZE/TnvxxgGNK/V1D5wm9u0EbSMcU7nB
   HXqD3KiiV0xFGYB4GJAaKQxDLdaVJAGL3uMASi8Gdl6CueeN+ixSUGGNu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="299020271"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="299020271"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 05:08:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="979370436"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="979370436"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.45.65])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 05:08:50 -0800
Date:   Mon, 19 Dec 2022 14:08:45 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     lixiaokeng <lixiaokeng@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
Subject: Re: [PATCH V2] Fix NULL dereference in super_by_fd
Message-ID: <20221219140845.000030c2@linux.intel.com>
In-Reply-To: <59f29da7-2d07-febd-fc7b-e194bdf3ced8@huawei.com>
References: <c2cb8668-afc8-459a-9c91-9b0002fbeaa0@huawei.com>
        <20221215125027.00002a45@linux.intel.com>
        <59f29da7-2d07-febd-fc7b-e194bdf3ced8@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 19 Dec 2022 19:50:52 +0800
lixiaokeng <lixiaokeng@huawei.com> wrote:

> On 2022/12/15 19:50, Mariusz Tkaczyk wrote:
> > On Wed, 14 Dec 2022 11:17:41 +0800
> > lixiaokeng <lixiaokeng@huawei.com> wrote:
> >   
> >> strcpy(st->devnm, devnm);  
> > 
> > Hi,
> > Please use strncpy or snprintf here.  
> 
> Thanks for your advice, but the length of devnm is not
> a defined value. I will keep it as the old codes.

Supertype devnm is a array defined to be 32.
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdadm.h#n1256

32 should be changed to MD_NAME_MAX - you can use this define.
I traveled fd2devnm and I can see that at the end devid2devnm returns:
static char devnm[32]
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/lib.c#n123

For that reason usage of strcpy in this case seems to be safe, unless we change
something deeper. My recommendation comes from general safe development rules-
we know dest buffer size so we can esnure that it will be ended properly by
'\0', whatever comes to write from fd2devnm().

Thanks,
Mariusz

