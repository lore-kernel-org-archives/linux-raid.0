From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Tue, 27 Feb 2007 14:21:33 -0500
Message-ID: <45E484BD.5010501@tmr.com>
References: <45D89FF5.3020303@sauce.co.nz> <200702232122.16730.a1426z@gawab.com> <Pine.LNX.4.64.0702241716130.28888@coffee.psychology.mcmaster.ca> <200702251422.28079.a1426z@gawab.com> <Pine.LNX.4.64.0702251119300.21918@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702251119300.21918@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>>>> In contrast, ever since these holes appeared, drive failures became 
>>>> the
>>>> norm.
>>>
>>> wow, great conspiracy theory!
>>
>> I think you misunderstand.  I just meant plain old-fashioned 
>> mis-engineering.
>
> I should have added a smilie.  but I find it dubious that the whole 
> industry would have made a major bungle if so many failures are due to 
> the hole...
>
>> But remember, the google report mentions a great number of drives 
>> failing for
>> no apparent reason, not even a smart warning, so failing within the 
>> warranty
>> period is just pure luck.
>
> are we reading the same report?  I look at it and see:
>
>         - lowest failures from medium-utilization drives, 30-35C.
>         - higher failures from young drives in general, but especially
>         if cold or used hard.
>         - higher failures from end-of-life drives, especially > 40C.
>     - scan errors, realloc counts, offline realloc and probation
>     counts are all significant in drives which fail.
>
> the paper seems unnecessarily gloomy about these results.  to me, they're
> quite exciting, and provide good reason to pay a lot of attention to 
> these
> factors.  I hate to criticize such a valuable paper, but I think they've
> missed a lot by not considering the results in a fully factorial analysis
> as most medical/behavioral/social studies do.  for instance, they bemoan
> a 56% false negative rate from only SMART signals, and mention that if
>> 40C is added, the FN rate falls to 36%.  also incorporating the 
>> low-young
> risk factor would help.  I would guess that a full-on model, especially
> if it incorporated utilization, age, performance could comfortable 
> levels. 
The big thing I notice is that drives with SMART errors are quite likely 
to fail, but drives which fail aren't all that likely to have SMART 
errors. So while I might proactively move a drive with errors out or to 
non-critical service, seeing no errors doesn't mean the drive won't fail.

I haven't looked at drive temp vs. ambient, I am collecting what data I 
can, but I no longer have thousands of drives to monitor (I'm grateful).

Interesting speculation: on drives with cyclic load, does spinning down 
off-shift help or hinder? I have two boxes full of WD, Seagate and 
Maxtor drives, all cheap commodity drives, which have about 6.8 years 
power on time, 11-14 power cycles, and 2200-2500 spin-up cycles, due to 
spin down nights and weekends. Does anyone have a large enough 
collection of similar use drives to contribute results?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

