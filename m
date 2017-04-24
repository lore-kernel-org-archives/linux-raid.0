From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: mdadm Consistency Policy initialization
Date: Mon, 24 Apr 2017 12:07:44 +0200
Message-ID: <ac885b46-4f5f-c18c-ee45-a5d1886466e9@intel.com>
References: <9b041a85-7d61-75c8-7fbf-857e095ab838@gmail.com>
 <8c3ddfa5-2069-b2e2-40c6-e1ec14b2461f@intel.com>
 <2ca923fa-c147-f8c9-2399-f3a0e0d1721a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2ca923fa-c147-f8c9-2399-f3a0e0d1721a@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/20/2017 06:08 PM, Jes Sorensen wrote:
> On 04/19/2017 06:29 AM, Artur Paszkiewicz wrote:
>> On 04/18/2017 06:50 PM, Jes Sorensen wrote:
>>> Hi Artur,
>>>
>>> In 5308f11727b889965efe5ac0e854d197c2b51f6d you introduced struct mdinfo: enum consistency_policy, but in mdadm.c you initialize it to UnSet which isn't part of the enum.
>>>
>>> Is there any actual difference between CONSISTENCY_POLICY_UNKNOWN and UnSet? It seems suboptimal to mix and match within the enum like this, and if CONSISTENCY_POLICY_UNKNOWN does the job, couldn't we just initialize with that?
>>
>> Hi Jes,
>>
>> The "enum consistency_policy" and "mapping_t consistency_policies[]"
>> represent values that can appear in sysfs. md/consistency_policy can be
>> "unknown" when the array is inactive. On the other hand, UnSet just
>> means that the --consistency-policy= parameter was not provided by the
>> user. I wanted to differentiate between these two cases. If you think
>> this is redundant I can change it and use CONSISTENCY_POLICY_UNKNOWN
>> instead, this should be straightforward.
> 
> Hi Artur,
> 
> I made some changes to map_name() and noticed that you already there default to CONSISTENCY_POLICY_UNKNOWN if it returns UnSet in sysfs_read(). However given that you do a lot of checks manually outside of sysfs.c, I dind't change the code there for now. I think we the change I made to map_name() it should be possible to simply a bunch of that checking code.

Hi Jes,

It does seem to be better this way. I'll send a patch that removes using
UnSet from all consistency policy related places soon.

Thanks,
Artur
