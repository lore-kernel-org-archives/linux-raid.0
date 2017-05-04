From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: mdadm/mdmon Name vs argv[0]
Date: Thu, 4 May 2017 10:45:56 -0400
Message-ID: <f40434ba-5963-71b9-38e3-67f5b93a056f@gmail.com>
References: <a61470a2-2c3b-3f4a-5712-dfb87f3acad8@gmail.com>
 <3f64ba3e-e931-6055-8621-a91c637e0174@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3f64ba3e-e931-6055-8621-a91c637e0174@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/04/2017 09:40 AM, Pawel Baldysiak wrote:
> On 05/02/2017 04:19 PM, Jes Sorensen wrote:
>> Hi Pawel,
>>
>> In the below commit you changed the handling of how mdadm/mdmon
>> handles printing the name of the running process.
>>
>> However, if people for some reason decided to change the names of
>> mdadm/mdmon this would no longer be correct.
>>
>> Do you remember if there is any reason why you didn't use argv[0] for
>> this?
>>
>> commit d56dd607ba433d9334f0fb4114fe081742ae4361
>> Author: Pawel Baldysiak <pawel.baldysiak@intel.com>
>> Date:   Wed Feb 11 22:25:03 2015 +0100
>>
>>      Change way of printing name of a process
>>
>> Cheers,
>> Jes
> Hi Jes,
>
> We did not consider this option once we were implementing the change.
> Also, I was not considering that someone would like to change the
> mdadm/mdmon names :)
>
> I see one potential issue with usage of argv[0]:
> If you look into mdmon's code (start of the main()),
> you will see that first char is replaced with '@'.

Good point!

I somehow thought we weren't doing the name mangling anymore.

However we could copy from argv[0] before mangling the name. That way we 
would have generic code, rather than hard coded names.

Cheers,
Jes


