Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C819EE4993
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 14:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbjHWOJT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 10:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbjHWOJT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 10:09:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C68DE46
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 07:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692799757; x=1724335757;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VRkKLDWLzyYGqRx9cNIyIQildgALl14TXko1HN4hrB0=;
  b=ViEmI/xVpyajjrMdLkktOL8UTppYTqNDyX5oouA2dgLlH5FfJhh/RKvm
   f6yCVbvxv4m045ETHtx6a/iluitYWh1mKtDpuAw5nJKVyuJy9wx1YONj6
   6kLTPAxTgtmiMh22Fx7E6M4TwKzRxRIA8aOsgTJXIwgzaJEwfjcKQY9ho
   /MiwI2vvwhIOJxXDrBjVtGHhwfWMzJ/TWlrvWgwutLO1LwSnKyfHon8rp
   aMm3ObJ5AB+LKgatL1Tq+gnR4h9zN2nKiQJWo8LfSwIu+yE2UWRFZKLxu
   E1aKm4JhKAm1wIdz5C/o+PDjYjlGSz6C68Oi66we67GsPGJjhWvxNkXFx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="353719973"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="353719973"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 07:09:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="739794723"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="739794723"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.143.195])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 07:09:09 -0700
Date:   Wed, 23 Aug 2023 16:09:05 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: Re: [PATCH 1/1] Stop mdcheck_continue timer when mdcheck_start
 service can finish check
Message-ID: <20230823160905.00004d3c@linux.intel.com>
In-Reply-To: <20230508133010.42313-1-xni@redhat.com>
References: <20230508133010.42313-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,
some nits:

On Mon,  8 May 2023 21:30:10 +0800
Xiao Ni <xni@redhat.com> wrote:

> mdcheck_continue is triggered by mdcheck_start timer. It's used to
> continue check action if the raid is too big and mdcheck_start
> service can't finish check action. If mdcheck start can finish check
> action, it doesn't need to mdcheck continue service anymore. So stop
> it when mdcheck start service can finish check action.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  misc/mdcheck | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/mdcheck b/misc/mdcheck
> index 700c3e252e72..f56972c8ed10 100644
> --- a/misc/mdcheck
> +++ b/misc/mdcheck
> @@ -140,7 +140,13 @@ do
>  		echo $a > $fl
>  		any=yes
>  	done
> -	if [ -z "$any" ]; then exit 0; fi
> +	if [ -z "$any" ]; then
> +		#mdcheck_continue.timer is started by mdcheck_start.timer.
> +		#When he check action can be finished in
's/he/the/g'
I think that there should be space after '#' but it is preferred to use /* */ 
Could you please send v2?

Thanks,
Mariusz
