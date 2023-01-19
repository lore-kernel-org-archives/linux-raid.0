Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95951C46467
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 13:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjASN6I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 08:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjASN6C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 08:58:02 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BD7469B
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 05:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674136681; x=1705672681;
  h=message-id:date:mime-version:subject:to:references:cc:
   from:in-reply-to:content-transfer-encoding;
  bh=QXC3inXwEwpOMSYZcVbWYNe0vrQUfhsEZVWutQs7cSg=;
  b=ag0aZEsUrD+V6XbF3uu+yMKcSvdUckpI8iTUevLi6/YjpE6B1EyQmGAC
   bgFc38ZpwPkZr9R1ggqLGdr4BPO5uV5ZWR+EV4USwIT0lM0Nz3VzsUiPL
   tSb59IUcvaLZoQTZSbkF5mD5tNNXt88BRcaBcMX6td88YCXU1s1wrqNh3
   GuIuvGveCHeRoWFOeq5Fie+zBFSxTfOXpctXVnlfnpxYHB6BZofkYLJNd
   8tOsTb90LgBEuSxwMPa8D2zNbw8qasUKZn9kbx4y+WkXOZ++UKmZsK2kR
   +tH5mkYEEo0eS9dHrObP7OPv0dczkcaD5wFb72XM1YLe6wFdckaXiJGYq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="322975964"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="322975964"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:58:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="662115632"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="662115632"
Received: from mgrzonka-mobl.ger.corp.intel.com (HELO [10.249.146.149]) ([10.249.146.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 05:57:59 -0800
Message-ID: <b0bb803e-18b3-2e7b-e644-fd981559be06@linux.intel.com>
Date:   Thu, 19 Jan 2023 14:57:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/9] Mdmonitor: Make alert_info global
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-3-mateusz.grzonka@intel.com>
 <6e8c91f1-28f1-c594-4881-0d1546fcb1a2@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org
From:   "Grzonka, Mateusz" <mateusz.grzonka@linux.intel.com>
In-Reply-To: <6e8c91f1-28f1-c594-4881-0d1546fcb1a2@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/28/2022 3:49 PM, Jes Sorensen wrote:
> On 9/7/22 08:56, Mateusz Grzonka wrote:
>> Move information about --test flag and hostname into alert_info.
>>
>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> 
> Hi Mateusz,
> 
> This one no longer applies, any chance you can do an update?
> 
> Thanks,
> Jes
> 

Hi Jes,
I fixed some problems with comments, and rebased the series.

Unfortunately got some problems while sending them.
All patches marked as v2 are the correct ones.
Sorry for inconvenience.

Thanks,
Mateusz
