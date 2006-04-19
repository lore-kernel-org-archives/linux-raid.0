From: Nate Byrnes <nate@qabal.org>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Wed, 19 Apr 2006 09:53:53 -0400
Message-ID: <444640F1.3020008@qabal.org>
References: <1145106091.18173.18.camel@nemo.qabal.org>	 <44456474.9040201@harddata.com> <1145403579.15773.1.camel@nemo.qabal.org> <44463E0A.8090906@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44463E0A.8090906@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi All,
    I'm not sure that is entirely the case. From a hardware perspective, 
I can access all the disks from the OS, via fdisk and dd. It is really 
just mdadm that is failing.  Would I still need to work the jumper issue?
    Thanks,
    Nate

Maurice Hilarius wrote:
> Nathanial Byrnes wrote:
>   
>> Yes, I did not have the funding nor approval to purchase more hardware
>> when I set it up (read wife). Once it was working... the rest is
>> history.
>>
>>   
>>     
>
> OK, so if you have a pair of IDE disks, jumpered as Master and slave,
> and if one fails:
>
> If Master failed, re-jumper remaining disk on pair on same cable as
> Master, no slave present
>
> If Slave failed, re-jumper remaining disk on pair on same cable as
> Master, no slave present.
>
> Then you will have the remaining disk working normally, at least.
>
> When you can afford it I suggest buying a controller with enough ports
> to support the number of drives you have, with no Master/Slave pairing.
>
> Good luck !
>
> And to the  software guys trying to help: We need to start with the
> (obvious) hardware problem, before we advise on how to recover data from
> a borked system..
> Once he has the jumpering on the drives sorted out, the drive that went
> missing will be back again..
>
>
>   
