From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 6/8] md-cluster: make resync lock also could be
 interruptted
Date: Mon, 1 Aug 2016 21:38:24 -0400
Message-ID: <579FF990.2050306@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
 <1469686612-16126-6-git-send-email-gqjiang@suse.com>
 <20160801222946.GC18810@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160801222946.GC18810@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/01/2016 06:29 PM, Shaohua Li wrote:
> On Thu, Jul 28, 2016 at 02:16:50AM -0400, Guoqing Jiang wrote:
>> When one node is perform resync or recovery, other nodes
>> can't get resync lock and could block for a while before
>> it holds the lock, so we can't stop array immediately for
>> this scenario.
>>
>> To make array could be stop quickly, we check MD_CLOSING
>> in dlm_lock_sync_interruptible to make us can interrupt
>> the lock request.
> if the thread is waiting for the resync lock and you set MD_CLOSING, where do
> you wake up the thread?

If array needs to do resync, it would call md_cluster_ops->resync_start
within md_do_sync. And since MD_CLOSING is set when stop md, we
can see do_md_stop would wake up sync_thread.

Thanks,
Guoqing

