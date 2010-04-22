From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 22 Apr 2010 17:12:45 +0200
Message-ID: <64bd01cae22e$456461e0$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <alpine.DEB.1.10.1004221658040.6768@uplift.swm.pp.se>
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

Hi,


----- Original Message ----- 
From: "Mikael Abrahamsson" <swmike@swm.pp.se>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, April 22, 2010 5:00 PM
Subject: Re: Suggestion needed for fixing RAID6


> On Thu, 22 Apr 2010, Janos Haar wrote:
>
>> My question is, there is any way, to force the array to keep the members 
>> in even if have some reading errors?
>
> What version of the kernel are you running? If it's running anywhere 
> recent kernel it shouldn't kick drives upon read error but instead 
> recreate from parity. You should probably send "repair" to the md device 
> (echo repair > /sys/block/mdX/md/sync_action) and see if that fixes the 
> bad blocks. I believe this came in 2.6.15 or something like that (google 
> if you're in that neighbourhood, if you're in 2.6.26 or alike then you 
> should be fine).

The kernel is. 2.6.28.10.
I am just tested one of the badblock-hdds, and the bad blocks comes 
periodicaly, like a little and short scratch, and the drive can't correct 
these by write.
Maybe this is why the kernel kicsk it out...
But anyway, the problem is still here, i want to rebuild the missing disk 
(prior to replace the badblocked drives one by one), but the kernel kicks 
out more 2 drive during the rebuild.

Thanks for the idea,

Janos

>
> -- 
> Mikael Abrahamsson    email: swmike@swm.pp.se 

