From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Sun, 25 Feb 2007 12:40:58 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702251119300.21918@coffee.psychology.mcmaster.ca>
References: <45D89FF5.3020303@sauce.co.nz> <200702232122.16730.a1426z@gawab.com>
 <Pine.LNX.4.64.0702241716130.28888@coffee.psychology.mcmaster.ca>
 <200702251422.28079.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200702251422.28079.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> In contrast, ever since these holes appeared, drive failures became the
>>> norm.
>>
>> wow, great conspiracy theory!
>
> I think you misunderstand.  I just meant plain old-fashioned mis-engineering.

I should have added a smilie.  but I find it dubious that the whole 
industry would have made a major bungle if so many failures are due to 
the hole...

> But remember, the google report mentions a great number of drives failing for
> no apparent reason, not even a smart warning, so failing within the warranty
> period is just pure luck.

are we reading the same report?  I look at it and see:

         - lowest failures from medium-utilization drives, 30-35C.
         - higher failures from young drives in general, but especially
         if cold or used hard.
         - higher failures from end-of-life drives, especially > 40C.
 	- scan errors, realloc counts, offline realloc and probation
 	counts are all significant in drives which fail.

the paper seems unnecessarily gloomy about these results.  to me, they're
quite exciting, and provide good reason to pay a lot of attention to these
factors.  I hate to criticize such a valuable paper, but I think they've
missed a lot by not considering the results in a fully factorial analysis
as most medical/behavioral/social studies do.  for instance, they bemoan
a 56% false negative rate from only SMART signals, and mention that if 
>40C is added, the FN rate falls to 36%.  also incorporating the low-young
risk factor would help.  I would guess that a full-on model, especially
if it incorporated utilization, age, performance could comfortable levels.

>>> The problem is, that's not enough; the room temperature/humidity has to
>>> be controlled too.  In a desktop environment, that's not really
>>> feasible.
>>
>> 5-90% humidity, operating, 95% non-op, and 30%/hour.  seems pretty easy
>> to me.  in fact, I frequently ask people to justify the assumption that
>> a good machineroom needs tight control over humidity.  (assuming, like
>> most machinerooms, you aren't frequently handling the innards.)
>
> I agree, but reality has a different opinion, and it may take down that
> drive, specs or no specs.

why do you say this?  I have my machineroom set for 35% (which appears 
to be it's "natural" point, with a wide 20% margin on either side.
I don't really want to waste cooling capacity on dehumidification,
for instance, unless there's a good reason.

> A good way to deal with reality is to find the real reasons for failure.
> Once these reasons are known, engineering quality drives becomes, thank GOD,
> really rather easy.

that would be great, but depends rather much on relatively small number of 
variables, which are manifest, not hidden.  there are billions of studies
(in medical/behavioral/social fields) which assume large numbers of more
or less hidden variables, and which still manage good success...

regards, mark hahn.
