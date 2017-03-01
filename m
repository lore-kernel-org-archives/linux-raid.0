From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 05/14] md-cluster: add new parameter for lock_token
Date: Wed, 1 Mar 2017 10:48:48 +0800
Message-ID: <58B63690.8010405@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-6-git-send-email-gqjiang@suse.com>
 <20170228180714.ooim4khb4zlowlof@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228180714.ooim4khb4zlowlof@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids



On 03/01/2017 02:07 AM, Shaohua Li wrote:
> On Fri, Feb 24, 2017 at 11:15:15AM +0800, Guoqing Jiang wrote:
>> lock_token is called from either lock_comm or
>> metadata_update_start, if we look back more for
>> the call chain, some of them are called with the
>> reconfig_mutex held while a few of them don't.
>>
>> Specifically, resync_info_update is mostly called
>> without the protection of reconfig_mutex. But
>> resync_finish calls resync_info_update within
>> the mutex.
>>
>> We make the change to lock_token since we need
>> to use synchronous way to handle METADATA_UPDATED
>> message in latter patch.
> please merge this to the patch which uses the new paramter
>

NP, though I think it is easy for review.

Thanks,
Guoqing
