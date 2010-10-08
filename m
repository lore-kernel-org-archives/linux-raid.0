From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: Ok, dumb question time ...
Date: Fri, 08 Oct 2010 14:07:55 -0400
Message-ID: <4CAF5DFB.2050200@scalableinformatics.com>
References: <4CAE9C13.3060002@scalableinformatics.com> <AANLkTinw+4N63KqLGadYeHiiCg_LjYWSHKBfdsMRPBGJ@mail.gmail.com>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinw+4N63KqLGadYeHiiCg_LjYWSHKBfdsMRPBGJ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/08/2010 02:01 PM, CoolCold wrote:

>> It doesn't.  The array is marked as being in the "clean, degraded" state.
>>   Which, as it is the root file system array, has the unfortunate side effect
>> of not allowing the RAID1 to properly assemble at boot (that degraded
>> state).
> Am I understanding right, you can't boot because that md array isn't
> assembled at all or just assembled but degraded?
> If first, are you happy Ubuntu user?

Its not assembling due to the "degraded" state.  This is on Centos 5.5 
using our kernel bits (never had a problem with this before).  We've 
gotten past that issue and are now onto the next one for them (many 
thanks to Neil for the solution)

The customer in question may have modified their configs, and we are 
trying to walk their changes back to the point where it stopped working.

Thanks

Joe


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
