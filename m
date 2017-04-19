From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: mdadm Consistency Policy initialization
Date: Wed, 19 Apr 2017 12:19:35 -0400
Message-ID: <a3050c46-f017-1c3d-3fc5-2a1b4d976db8@gmail.com>
References: <9b041a85-7d61-75c8-7fbf-857e095ab838@gmail.com>
 <8c3ddfa5-2069-b2e2-40c6-e1ec14b2461f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8c3ddfa5-2069-b2e2-40c6-e1ec14b2461f@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/19/2017 06:29 AM, Artur Paszkiewicz wrote:
> On 04/18/2017 06:50 PM, Jes Sorensen wrote:
>> Hi Artur,
>>
>> In 5308f11727b889965efe5ac0e854d197c2b51f6d you introduced struct mdinfo: enum consistency_policy, but in mdadm.c you initialize it to UnSet which isn't part of the enum.
>>
>> Is there any actual difference between CONSISTENCY_POLICY_UNKNOWN and UnSet? It seems suboptimal to mix and match within the enum like this, and if CONSISTENCY_POLICY_UNKNOWN does the job, couldn't we just initialize with that?
>
> Hi Jes,
>
> The "enum consistency_policy" and "mapping_t consistency_policies[]"
> represent values that can appear in sysfs. md/consistency_policy can be
> "unknown" when the array is inactive. On the other hand, UnSet just
> means that the --consistency-policy= parameter was not provided by the
> user. I wanted to differentiate between these two cases. If you think
> this is redundant I can change it and use CONSISTENCY_POLICY_UNKNOWN
> instead, this should be straightforward.

Hi Artur,

I would prefer to either use CONSISTENCY_POLICY_UNKNOWN or introduce a 
new state within the enum so we don't cross pollute the namespace.

Cheers,
Jes


