From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: mdadm Consistency Policy initialization
Date: Mon, 24 Apr 2017 09:45:37 -0400
Message-ID: <543e7925-fe73-df55-bfdd-1fa0f10eb126@gmail.com>
References: <9b041a85-7d61-75c8-7fbf-857e095ab838@gmail.com>
 <8c3ddfa5-2069-b2e2-40c6-e1ec14b2461f@intel.com>
 <2ca923fa-c147-f8c9-2399-f3a0e0d1721a@gmail.com>
 <ac885b46-4f5f-c18c-ee45-a5d1886466e9@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac885b46-4f5f-c18c-ee45-a5d1886466e9@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/24/2017 06:07 AM, Artur Paszkiewicz wrote:
> On 04/20/2017 06:08 PM, Jes Sorensen wrote:
>> On 04/19/2017 06:29 AM, Artur Paszkiewicz wrote:
>>> Hi Jes,
>>>
>>> The "enum consistency_policy" and "mapping_t consistency_policies[]"
>>> represent values that can appear in sysfs. md/consistency_policy can be
>>> "unknown" when the array is inactive. On the other hand, UnSet just
>>> means that the --consistency-policy= parameter was not provided by the
>>> user. I wanted to differentiate between these two cases. If you think
>>> this is redundant I can change it and use CONSISTENCY_POLICY_UNKNOWN
>>> instead, this should be straightforward.
>>
>> Hi Artur,
>>
>> I made some changes to map_name() and noticed that you already there default to CONSISTENCY_POLICY_UNKNOWN if it returns UnSet in sysfs_read(). However given that you do a lot of checks manually outside of sysfs.c, I dind't change the code there for now. I think we the change I made to map_name() it should be possible to simply a bunch of that checking code.
>
> Hi Jes,
>
> It does seem to be better this way. I'll send a patch that removes using
> UnSet from all consistency policy related places soon.

Awesome!

I am glad you like it.

Jes

