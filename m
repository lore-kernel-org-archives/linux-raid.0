From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 22 Apr 2010 18:25:06 +0200
Message-ID: <652301cae238$5faf2440$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <alpine.DEB.1.10.1004221658040.6768@uplift.swm.pp.se> <64bd01cae22e$456461e0$0400a8c0@dcccs> <alpine.DEB.1.10.1004221713420.6768@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Mikael Abrahamsson" <swmike@swm.pp.se>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, April 22, 2010 5:18 PM
Subject: Re: Suggestion needed for fixing RAID6


> On Thu, 22 Apr 2010, Janos Haar wrote:
>
>> I am just tested one of the badblock-hdds, and the bad blocks comes 
>> periodicaly, like a little and short scratch, and the drive can't correct 
>> these by write.
>
> Oh, if you get write errors on the drive then you're in bigger trouble.

I am planning to replace all the defective drives, but first i need to 
rebuild the missing part.
I don't care about wich is the problem, the first drive have 123 unredable 
sectors, and i have tried to rewrite one but not works.
This will goes to RMA, but first i need to solve the problem.

>
>> Maybe this is why the kernel kicsk it out...
>
> Yes, a write error to the drive is a kick:able offence. What does smartctl 
> say about the drives?

The smart healt is good. (not wondering...)
But the drive have some offline unc sectors and some pendings.

>
>> But anyway, the problem is still here, i want to rebuild the missing disk 
>> (prior to replace the badblocked drives one by one), but the kernel kicks 
>> out more 2 drive during the rebuild.
>
> I don't have a good idea that assures your data, unfortunately. One way 
> would be to dd the defective drives to working ones, but that will most 
> likely cause you to have data loss on the defective sectors (since md has 
> no idea that these sectors should be re-created from parity).

Exactly.
This is why i ask here. :-)
Because i don't want to make some KB errors on the array wich have all the 
needed information.

Any good idea?

Thanks a lot,
Janos

>
> -- 
> Mikael Abrahamsson    email: swmike@swm.pp.se
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

