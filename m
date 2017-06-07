From: Zhilong Liu <zlliu@suse.com>
Subject: Re: mdadm: Apply to revert the commit of a4dcdb23
Date: Wed, 7 Jun 2017 10:03:59 +0800
Message-ID: <29c6a3b1-f408-53c0-b496-2fba0e0cc9c8@suse.com>
References: <0010fa6f-f227-cdd8-31ef-7073ec46546a@suse.com>
 <0d1a79b0-a7fd-656d-5cfd-a85b4398c284@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0d1a79b0-a7fd-656d-5cfd-a85b4398c284@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 06/07/2017 12:02 AM, Jes Sorensen wrote:
> On 06/06/2017 05:25 AM, Zhilong Liu wrote:
>> Hi, Jes;
>>     Excuse me, there is one problematic commit for Detail.c,
>> a4dcdb23(Detail: determine array state from sysfs).
>> This commit does change the codes meaning and it didn't
>> run to the right path. This commit was result in a bug that
>> Detail() cannot work normally.
>>
>> For example:
>> # ./mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --assume-clean
>> # ./mdadm -D /dev/md0
>> mdadm: cannot get array detail for /dev/md0: No such file or directory
>>
>> Thanks very much,
>> -Zhilong
>
> Please be more specific and explain what you believe is wrong. I 
> prefer a patch fixing the issue to just reverting things.
>

I just re-checked the mailing-list, found the email that post the commit 
of 9b8fea914f82
from Tomasz in May.24th, it has already fixed this issue. please ignore 
this mail. Sorry
for that.

Thanks,
-Zhilong

> Jes
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

