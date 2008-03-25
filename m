From: Hubert Verstraete <hubskml@free.fr>
Subject: Re: MDP major registration
Date: Tue, 25 Mar 2008 17:57:06 +0100
Message-ID: <47E92EE2.1080108@free.fr>
References: <47D90614.9040206@free.fr> <18408.36753.223347.129420@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.36753.223347.129420@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday March 13, hubskml@free.fr wrote:
>> Neil,
>>
>> What is the status of the major for the partitionable arrays ?
>
> automatically determined at runtime.
>
>> I see that it is 254, which is in the experimental section, according to 
>> the official Linux device list (http://www.lanana.org/docs/device-list/).
>> Will there be an official registration ?
> 
> No. Is there any need?

I got this question in mind when I saw that mkfs.xfs source code was 
referring to the MD major to tune its parameters on an MD device, while 
it ignores MDP devices.
If there were reasons to register MD, wouldn't they apply to MDP too ?

Regards,
Hubert
