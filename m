Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00D5CA0FE4
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 15:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbjIAPt3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjIAPt2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 11:49:28 -0400
Received: from sender-op-o11.zoho.eu (sender-op-o11.zoho.eu [136.143.169.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E995310EB
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 08:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693583354; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=iQoe5wCWWsMmKdQhj37vI81rZk8AAo7h+YPtsMQLhd1HBzjrHDRHk155APQPMpj9+Sh5+pHfj1RppE3/GcOVS+u5GXgBD7zUhTTJFVH/toK/Xq4S1TJsJmxVQzH9ccb7habHZKhIj3vrSnB111BpEndVu72DfUYrqNmriH+L3PQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693583354; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=BmVvIylCFM/SNo/Dt0Soz6N2GYAA49yX/T3ITVzKxuc=; 
        b=hMN+XmGCDLVOODRzbfjjgDXVOZVJXqJStR8CFRVhrvy2UzyZVTLDmE5LHWt1ShMGQEIKY8kPHm1kv0/i6PnmmNPExPM6u3qFbbi5CvIhLQq2ktvz7dCNNdFlpkhJ95KfTgv+74P0T/fNY9U93/l+FjHjlKKz9ratBFHBKHs2i/A=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1693583352462690.9835680825753; Fri, 1 Sep 2023 17:49:12 +0200 (CEST)
Message-ID: <1b788a2b-b90d-9b30-4240-49a548fa0fae@trained-monkey.org>
Date:   Fri, 1 Sep 2023 11:49:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V2 1/1] mdadm: Stop mdcheck_continue timer when
 mdcheck_start service can finish check
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com
References: <20230825125541.76501-1-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230825125541.76501-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/25/23 08:55, Xiao Ni wrote:
> mdcheck_continue is triggered by mdcheck_start timer. It's used to
> continue check action if the raid is too big and mdcheck_start
> service can't finish check action. If mdcheck start can finish check
> action, it doesn't need to mdcheck continue service anymore. So stop
> it when mdcheck start service can finish check action.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
> v2: fix typo errors and add spaces at the beginning of comments
>  misc/mdcheck | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/mdcheck b/misc/mdcheck
> index 700c3e252e72..f87999d3e797 100644
> --- a/misc/mdcheck
> +++ b/misc/mdcheck
> @@ -140,7 +140,13 @@ do
>  		echo $a > $fl
>  		any=yes
>  	done
> -	if [ -z "$any" ]; then exit 0; fi
> +	# mdcheck_continue.timer is started by mdcheck_start.timer.
> +	# When the check action can be finished in mdcheck_start.service,
> +	# it doesn't need mdcheck_continue anymore.
> +	if [ -z "$any" ]; then
> +		systemctl stop mdcheck_continue.timer
> +		exit 0;
> +	fi
>  	sleep 120
>  done
>  

Applied!

Thanks,
Jes

