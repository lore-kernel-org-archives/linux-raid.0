From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Fri, 05 Sep 2008 13:15:42 +0400
Message-ID: <48C0F8BE.7060108@emcraft.com>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com> <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wd@denx.de, yur@emcraft.com, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Andrew Morton wrote:
>> From: Yuri Tikhonov <yur@emcraft.com>
>>
>> Should clear the next pointer of the TX if we are sure that the
>> next TX (say NXT) will be submitted to the channel too. Overwise,
>> we break the chain of descriptors, because we lose the information
>> about the next descriptor to run. So next time, when invoke
>> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
>> NXT will be never submitted.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>>     
Signed-off-by: Ilya Yanok <yanok@emcraft.com>

> This patch should include your signed-off-by: as well.  Because you
> were on the delivery path, as described in
> Documentation/SubmittingPatches, section 12.  
>   

Excuse me for being inattentive.

Regards, Ilya.

