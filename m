From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Re: RAID1 VS RAID5
Date: Tue, 28 Oct 2003 11:45:10 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067337910.1283.5.camel@cala>
References: <200310261716.17030.maarten@vbvb.nl>
	 <1067179519.1222.107.camel@cala> <200310261716.17030.maarten@vbvb.nl>
	 <5.2.1.1.0.20031027015844.03a85e68@no.incoming.mail>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.2.1.1.0.20031027015844.03a85e68@no.incoming.mail>
To: Jeff Woods <kazrak+kernel@cesmail.net>
Cc: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>, maarten van den Berg <maarten@vbvb.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il lun, 2003-10-27 alle 11:16, Jeff Woods ha scritto:

> Alternating I/Os between two spindles on a RAID1 pair won't (in general) 
> speed up the transfer rate.

Are you sure? Have you done some tests? Because I think the opposite.

>  Leaving the other 
> spindle available to seek to another part of the drive and provide double 
> the bandwidth has major advantages in a multiprocessing environment 

Is good but I do not need it...



> OTOH, you have access to the source code if you really want to try it 
> another way.

So again my first question thats seems to go ignored: does someone have
made a patch? Is there some line to put in raidtab to change raid1
behavior?



-- 
Mario Giammarco


