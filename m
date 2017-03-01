From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 09/14] md-cluster: set MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD
 in metadata_update_start
Date: Wed, 1 Mar 2017 10:58:37 +0800
Message-ID: <58B638DD.5070805@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-10-git-send-email-gqjiang@suse.com>
 <20170228182444.ggwl7dnmhw2zi3n4@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170228182444.ggwl7dnmhw2zi3n4@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids



On 03/01/2017 02:24 AM, Shaohua Li wrote:
> On Fri, Feb 24, 2017 at 11:15:19AM +0800, Guoqing Jiang wrote:
>> Since we have switched to sync way to handle METADATA_UPDATED
>> msg, then process_metadata_update can only continue with either
>> get the reconfig_mutex or MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD is
>> set.
> same here. Either the patch should be put into the 'METADATA_UPDATED' patch or
> this patch should be before the 'METADATA_UPDATED' patch.
>
> We shouldn't introduce a broken patch then fix it in latter patch.

Yes, for both 8 and 9, it is possible to merge with 6 (I resend it though
it was not posted successfully for some reason). I seperated them since
it would be more easy for review and don't want mess up  header of the
6th patch.

Thanks,
Guoqing

