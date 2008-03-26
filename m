From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: MDP major registration
Date: Wed, 26 Mar 2008 11:54:39 -0400
Message-ID: <47EA71BF.8050800@tmr.com>
References: <47D90614.9040206@free.fr> <18408.36753.223347.129420@notabene.brown> <47E92EE2.1080108@free.fr> <20080326065232.GA21970@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080326065232.GA21970@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Tue, Mar 25, 2008 at 05:57:06PM +0100, Hubert Verstraete wrote:
>> Neil Brown wrote:
>>> On Thursday March 13, hubskml@free.fr wrote:
>>>> Neil,
>>>>
>>>> What is the status of the major for the partitionable arrays ?
>>>
>>> automatically determined at runtime.
>>>
>>>> I see that it is 254, which is in the experimental section, 
>>>> according to the official Linux device list 
>>>> (http://www.lanana.org/docs/device-list/).
>>>> Will there be an official registration ?
>>>
>>> No. Is there any need?
>>
>> I got this question in mind when I saw that mkfs.xfs source code was 
>> referring to the MD major to tune its parameters on an MD device, 
>> while it ignores MDP devices.
>> If there were reasons to register MD, wouldn't they apply to MDP too ?
>
> i don't think so:
> bluca@percy ~ $ grep mdp /proc/devices
> 253 mdp

Why is it important to have XFS tune its parameters for md and not for 
mdp? I don't understand your conclusion here, is tuning not needed for 
mdp, or so meaningless that it doesn't matter, or that XFS code reads 
/proc/devices, or ??? I note that device-mapper also has a dynamic 
major, what does XFS make of that?

I don't know how much difference tuning makes, but if it's worth doing 
at all, it should be done for mdp as well, I would think.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


