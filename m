From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid 5: Lossless music archive server recommendations
Date: Tue, 1 Jun 2004 23:49:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406020349.i523nI305197@watkins-home.com>
References: <20040602000547.55368.qmail@web61002.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040602000547.55368.qmail@web61002.mail.yahoo.com>
To: 'M K' <maheshext3@yahoo.com>, 'James Bamford' <jim@jimtreats.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you buy and extra disk to be a spare, consider RAID6.

RAID6 will allow 2 simultaneous disk failures.

RAID5 with 1 spare will support 2 disk failures, but only 1 at a time.  1
must fail, then the array rebuilds to the spare, then another can fail.
During a re-build, if a single block is bad, the re-build fails and the
drive with the read error goes off-line and the array goes off-line.  Not
pretty!  This has happened to me!!  When it happens, it is like having 2
simultaneous disk failures, RAID6 would have survived!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of M K
Sent: Tuesday, June 01, 2004 8:06 PM
To: James Bamford; linux-raid@vger.kernel.org
Subject: Re: Raid 5: Lossless music archive server recommendations

I may be wrong, but do bear in mind that its not easy
to "expand" a RAID once you have created it. More or
less, when you need more space in the future, you may
just find it easier to create another big raid.
 also, IDE drives are not very reliable per-se. so you
may want to add another "hot-spare" to your system,
just in case more than one hard drive says bye-bye.
.. just my $0.02 of thought..

--- James Bamford <jim@jimtreats.com> wrote:
> Hi folks...
> 
> Its been a while since I've asked anything on here..
> after some effort you  
> guys got me rolling with linux for a backup server
> on an old machine and  
> an old promise ide controller running a simple 2
> drive software raid  
> mirror... Everything has been fine with it so far
> although its not in use  
> much at the moment as the machine to be backed up
> has since been  
> "upgraded" to be water cooled.. but i've yet to fit
> the controls to turn  
> the pump on automatically so it can't boot up
> without me being around and  
> so can't run the auto backup task..
> 
> ANyways.. For a long time i've been waiting for
> bigger harddisks to make a  
> backup of my entire music catalogue a possibility,
> in lossless formats  
> about 400meg an album.. I've just realised that this
> only really needs  
> around 400-500gig and so is within reach of not too
> many hdds right here  
> right now..
> 
> Its going to take some time to make these music rips
> and when i do i think  
> i'll want them to have some kind of backup which has
> got me thinking raid  
> again... I guess this time I would want raid5 as I
> need more space than is  
> really feasible off only a few drives..
> 
> I'm a little wet behind the ears with all things
> raid but i was thinking  
> that 3x200gig drives would do for the data.. needing
> a 4th drive for the  
> raid5 parity disk or however it works..
> 
> Beyond that i do continue to buy music so some form
> of expandability would  
> be nice.. 8 channels would allow me to scale
> although am i right in  
> thinking that i would have to stick to the same
> sized drives for any extra  
> drives i consider!?
> 
> I then guess i need to have seperate channels for
> each hdd, which starts  
> taking me towards 3ware type cards with hardware to
> the task.. does this  
> then move me away from using software raid in linux
> if i have to get these  
> cards?
> 
> I ideally would like SATA to try it but i can't find
> any 200gig Seagate  
> SATA drives in the UK at the moment, only Ultra ATA
> ..
> 
> Anyways if you experts could tell me if i've got the
> right idea for  
> requirements that'd be great..
> 
> Thanks for your time
> 
> Cheers
> 
> Jim
> 
> -- 
> Using M2, Opera's revolutionary e-mail client:
> http://www.opera.com/m2/
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html



	
		
__________________________________
Do you Yahoo!?
Friends.  Fun.  Try the all-new Yahoo! Messenger.
http://messenger.yahoo.com/ 
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


