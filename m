From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Software Raid 1 data corruptions..
Date: Sat, 15 Nov 2003 23:19:37 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOCEEOGOAA.jim@jimtreats.com>
References: <Pine.LNX.4.44.0311151155150.28018-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311151155150.28018-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I just got it mounted and copied a file into it.. a 450meg
> image file... I
> > started running some md5 tests on the file (paranoid from other machines
> > recently having hdd corruptions) sadly i started to get this
> kind of result
> >
> > [jim@backup test]$ md5sum image.nrg
> >  3b5da2f7ad0e174421306b62a636fa12  image.nrg
> >
> > [jim@backup test]$ md5sum image.nrg
> >  4e815cd2c3ab565315ef47f53665f6ba  image.nrg
> >
> > [jim@backup test]$ md5sum image.nrg
> >  a14990ebfd5c502a68c29e2f789a34dd  image.nrg
>
> this isn't a via motherboard, is it?  have you run memtest86 overnight?
>

Ok well i have been doing a memtest on the machine since last replying..
coming up to 5 and a half hours now with no errors.. when i get back into
linux i think i will try mounting the hdds seperately and running md5sum
simultaneously on each drives copy of the file.. i guess this is quite a
good approximation of simultaneous reading that is done with RAID.. you'd
think the majority of the task will be this simultaneous reading, perhaps
that will cause problems which may indicate my hardware card is at fault..

ANy other tips, pointers.. you guys are my only help on this really, I don't
know where else to ask about this.. most linux irc channels etc have no RAID
experience..

Cheers

Jim

> > patches i can try.. should i abandon linux for raid and try
> using windows...
>
> egads.  there are billions and billions of ide-based linux servers
> out there, and most of them work fine.  your task is to find out what's
> wrong with your hardware.
>

