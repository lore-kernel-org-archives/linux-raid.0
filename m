From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 06/12] md-cluster: add the error check if failed to get
 dlm lock
Date: Tue, 28 Jul 2015 11:04:31 +0800
Message-ID: <55B6F13F.7070100@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com> <1436518883-12783-1-git-send-email-gqjiang@suse.com> <1436518883-12783-3-git-send-email-gqjiang@suse.com> <55B660CD.2030600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55B660CD.2030600@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Goldwyn,

Goldwyn Rodrigues wrote:
> Hi Guoqing,
>
> On 07/10/2015 04:01 AM, Guoqing Jiang wrote:
>> In complicated cluster environment, it is possible that the
>> dlm lock couldn't be get/convert on purpose, the related err
>> info is added for better debug potential issue.
>>
>> For lockres_free, if the lock is blocking by a lock request or
>> conversion request, then dlm_unlock just put it back to grant
>> queue, so need to ensure the lock is free finally.
>
>
> I cannot think of a scenario where a DLM_CANCEL will be returned.
> Could you explain the situation a bit more?
>
Thanks for the review. When the node is receiving message where it needs
to convert message
lock, and lockres_free is invoked if user stop array meanwhile, then the
message lock is put back
to grant queue at the CR mode and message lock is not released, am I
misunderstood the case?

Thanks,
Guoqing
