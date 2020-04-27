From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] Detail: adding sync status for cluster device
Date: Mon, 27 Apr 2020 10:33:20 -0400
Message-ID: <ca0df151-4d01-9122-fbcf-5baf281ec86a@trained-monkey.org>
References: <20200413144128.26177-1-lidong.zhong@suse.com>
 <bcd5713f-d2e8-d358-17c9-323f9c125d1b@cloud.ionos.com>
 <5c7b0055-917c-87ee-237f-1deaeb6fc575@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c7b0055-917c-87ee-237f-1deaeb6fc575@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhong Lidong <lidong.zhong@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/14/20 4:03 AM, Zhong Lidong wrote:
> 
> 
> On 4/14/20 3:25 PM, Guoqing Jiang wrote:
>> On 13.04.20 16:41, Lidong Zhong wrote:
>>> On the node with /proc/mdstat is
>>>
>>> Personalities : [raid1]
>>> md0 : active raid1 sdb[4] sdc[3] sdd[2]
>>>        1046528 blocks super 1.2 [3/2] [UU_]
>>>          recover=REMOTE
>>>        bitmap: 1/1 pages [4KB], 65536KB chunk
>>>
>>> the 'State' of 'mdadm -Q -D' is accordingly
>>
>> Maybe rephrase it a little bit, something like.
>>
>> "Let's change the 'State' of 'mdadm -Q -D' accordingly "
>>
>> Just FYI .
>>
> 
> Thank you for your suggestion, Guoqing. I'll send the
> patch again.
> 

Please mark the patch as v2 when you repost it with a change like this.

Thanks,
Jes
