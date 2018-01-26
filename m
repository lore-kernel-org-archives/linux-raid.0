From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [RFC PATCH] MD: fix lock contention for flush bios
Date: Fri, 26 Jan 2018 10:23:46 +0800
Message-ID: <eb9996af-a163-4ecb-ccb4-5eefdeccf13f@suse.com>
References: <1516761834-4701-1-git-send-email-xni@redhat.com>
 <c3b38c2f-e139-85e2-b78b-17f20b6622b3@suse.com>
 <248662549.3536363.1516801260103.JavaMail.zimbra@redhat.com>
 <3b9cdab1-c6ac-c40c-4cd8-4a6ea20b5547@suse.com>
 <20180126020655.GA8197@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180126020655.GA8197@ming.t460p>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org, shli@kernel.org, neilb@suse.com, ncroxon@redhat.com
List-Id: linux-raid.ids



On 01/26/2018 10:07 AM, Ming Lei wrote:
> Hi Guoqing,
>
> On Fri, Jan 26, 2018 at 09:10:11AM +0800, Guoqing Jiang wrote:
>>
>> On 01/24/2018 09:41 PM, Xiao Ni wrote:
>>> ----- Original Message -----
>>>> From: "Guoqing Jiang"<gqjiang@suse.com>
>>>> To: "Xiao Ni"<xni@redhat.com>,linux-raid@vger.kernel.org
>>>> Cc:shli@kernel.org,neilb@suse.com, "ming lei"<ming.lei@redhat.com>,ncroxon@redhat.com
>>>> Sent: Wednesday, January 24, 2018 5:02:57 PM
>>>> Subject: Re: [RFC PATCH] MD: fix lock contention for flush bios
>>>>
>>>>
>>>>
>>>> On 01/24/2018 10:43 AM, Xiao Ni wrote:
>>>>> There is a lock contention when there are many processes which send flush
>>>>> bios
>>>>> to md device. eg. Create many lvs on one raid device and mkfs.xfs on each
>>>>> lv.
>>>>>
>>>>> Now it just can handle flush request sequentially. It needs to wait
>>>>> mddev->flush_bio
>>>>> to be NULL, otherwise get mddev->lock.
>>>> With the new approach, can we still keep the synchronization across all
>>>> devices?
>>>> I found the previous commit a2826aa92e2e ("md: support barrier requests
>>>> on all
>>>> personalities") did want to keep synchronization.
>>> When one flush bio is sumbitted to md, it creates one bio for each rdev to send flush request.
>>> If it must waits for all the flush requests to return, my patch breaks the rule.
>>>
>>> Process A submits a flush bio to md, we call this flush bio bio-a.
>>> Process B submits a flush bio to md, we call this flush bio bio-b.
>>>
>>> Before my patch there is only one process can handle flush bio. Process B waits for the returning
>>> of bio-b from Process B. After my patch it can handle the flush bios from all processes. Can't
>>> we handle flush bios from different processes at the same time?
>> Hmm, barrier does need the synchronization though it caused the contention.
> Seems this patch only touches code of handling MD flush request, not related
> with barrier, could you explain a bit if it is?

Hmm, I didn't notice the barrier had been converted to flush/fua long 
time ago.
And some comments inside the code need to be updated I think.

>> For flush/fua, I guess
>> we may not need it since fs need to ensure that certain requests are
>> executed in order, but I am not
>> so sure about it.
>  From block layer's view, there isn't order in handling flush request
> among different IOs, and it is just a command sent to hardware for flushing
> the internal cache in drive.
>
> The current strictly serialized style of handling MD flush request does hurt
> performance, and IMO, the idea of the patch should be correct, at least from
> the view of handling flush request.

Thanks for the explanation, no more concern from me.

Regards,
Guoqing
