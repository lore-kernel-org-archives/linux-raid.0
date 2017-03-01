From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 07/14] md: move bitmap_destroy before __md_stop
Date: Wed, 1 Mar 2017 11:46:37 +0800
Message-ID: <58B6441D.1090909@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-8-git-send-email-gqjiang@suse.com>
 <20170228182009.zfsi2epb24ihjudp@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228182009.zfsi2epb24ihjudp@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids



On 03/01/2017 02:20 AM, Shaohua Li wrote:
> On Fri, Feb 24, 2017 at 11:15:17AM +0800, Guoqing Jiang wrote:
>> Since we have switched to sync way to handle METADATA_UPDATED
>> msg for md-cluster, then process_metadata_update is depended
>> on mddev->thread->wqueue.
>>
>> With the new change, clustered raid could possible hang if
>> array received a METADATA_UPDATED msg after array unregistered
>> mddev->thread, so we need to stop clustered raid earlier
>> than before.
>>
>> And this change should be safe for non-clustered raid since
>> all writes are stopped before the destroy. Also in md_run,
>> we activate the personality (pers->run()) before activating
>> the bitmap (bitmap_create()). So it is pleasingly symmetric
>> to stop the bitmap (bitmap_destroy()) before stopping the
>> personality (__md_stop() calls pers->free()).
> There is no patch 6. So I can't judge the purpose of the patch.

Sorry, it is resent now.

> The patch changed behaviors. We only destroy bitmap with mode == 0, now we do it
> even for mode == 2. Please specify why it's safe.

Thanks for reminder, I will add the check for mode.

> The __md_stop will wait for
> behind writes for example only with bitmap set, but the patch makes us not do
> the wait.

I don't know behind write very well,  but we have call __md_stop_writes 
before
destroy bitmap, also bitmap is flushed. Shouldn't it mean the 
behind_writes is
cleared? If not, when the behind_write bit can be cleared? Thanks.

Guoqing

