From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: The subarray is loaded container by load_container
Date: Thu, 04 Aug 2016 14:38:52 -0400
Message-ID: <wrfjshuk1irn.fsf@redhat.com>
References: <1782686607.3885369.1467882826743.JavaMail.zimbra@redhat.com>
	<4f57d953-8545-4647-49e7-c434e1892fb6@intel.com>
	<5798B4DD.6030702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5798B4DD.6030702@redhat.com> (Xiao Ni's message of "Wed, 27 Jul
	2016 21:19:25 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, tomasz.majchrzak@intel.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> On 07/07/2016 06:16 PM, Artur Paszkiewicz wrote:
>> Hi Xiao,
>>
>> I think you're right that mdadm -IRs should return 0 in this case.
>> IncrementalScan should not try loading a container from a member array,
>> because that will always fail. Can you check if this fixes the problem
>> for you?
>>
>> diff --git a/Incremental.c b/Incremental.c
>> index ba97b00..cc01d41 100644
>> --- a/Incremental.c
>> +++ b/Incremental.c
>> @@ -1347,8 +1347,12 @@ restart:
>>                    if (devnm && strcmp(devnm, me->devnm) != 0)
>>                          continue;
>> -               if (devnm && me->metadata[0] == '/') {
>> +               if (me->metadata[0] == '/') {
>>                          char *sl;
>> +
>> +                       if (!devnm)
>> +                               continue;
>> +
>>                          /* member array, need to work on container */
>>                          strncpy(container, me->metadata+1, 32);
>>                          container[31] = 0;
>>
>> Thanks,
>> Artur
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Hi Artur
>
> Sorry for late response. I have been waiting the result from customer
> and the customer haven't give me the answer. I tested this in my
> environment and this patch can fix this problem.

Artur,

Do you have a version of this patch you would like me to apply to the
official mdadm tree?

Cheers,
Jes
