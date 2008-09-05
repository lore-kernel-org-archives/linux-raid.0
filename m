From: Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Fri, 05 Sep 2008 17:16:01 +0400
Message-ID: <48C13111.4030205@emcraft.com>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com> <20080905130622.4C497248B8@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080905130622.4C497248B8@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

Dear Wolfgang,

this patch is already applied (d2029eba in linux-2.6-denx repo) I just
sent it upstream.

Regards, Ilya.

Wolfgang Denk wrote:
>> Should clear the next pointer of the TX if we are sure that the
>> next TX (say NXT) will be submitted to the channel too. Overwise,
>> we break the chain of descriptors, because we lose the information
>> about the next descriptor to run. So next time, when invoke
>> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
>> NXT will be never submitted.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>> ---
>>  crypto/async_tx/async_tx.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>     
>
> What about this patch? SHould it be applied to our repository?
>
> Best regards,
>
> Wolfgang Denk
>
>   

