From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [V2 PATCH] Safeguard against writing to an active device of another
 node
Date: Fri, 31 Jul 2015 17:04:43 +0800
Message-ID: <55BB3A2B.8090407@suse.com>
References: <1438246190-24079-1-git-send-email-gqjiang@suse.com> <55BA097A.3090400@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55BA097A.3090400@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc: neilb@suse.com, rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goldwyn Rodrigues wrote:
>
>
> On 07/30/2015 03:49 AM, Guoqing Jiang wrote:
>> Modifying an exiting device's superblock or creating a new superblock
>> on an existing device needs to be checked because the device could be
>> in use by another node in another array. So, we check this by taking
>> all superblock locks in userspace so that we don't  step onto an active
>> device used by another node and safeguard against accidental edits.
>> After the edit is complete, we release all locks and the lockspace so
>> that it can be used by the kernel space.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>> V2 Changes: use run-time check for dlm library
>
> This may be better done using a structure of function pointers which
> is setup and resolved one-time as opposed to performing symbol
> resolution every time the function is called. You could include
> get_cluster_name as well in it.
Good point, I will send another incremental patch for this.

Thanks,
Guoqing
