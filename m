From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Software Raid 1 data corruptions..
Date: Sat, 15 Nov 2003 17:28:39 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOOEEFGOAA.jim@jimtreats.com>
References: <Pine.LNX.4.44.0311151155150.28018-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0311151155150.28018-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Mark Hahn [mailto:hahn@physics.mcmaster.ca]
> Sent: 15 November 2003 17:00
> To: James R Bamford
> Subject: Re: Software Raid 1 data corruptions..
>
>
> > Promise Ultra 100 IDE controller
> > 2 x Samsung 8meg 160gig hdd
> >
> > I thought the promise controller was a raid controller, not
> used it for a
> > while.. but its just plain ide.. tho on reading i discovered that most
>
> but that's fine, since you've only got two disks (no raid5),
> and are not going to saturate your PCI bus.

Good to know and yes thats what i expected..

>
> > are basically just a controller with drivers to perform the raid
> > functionality in software..
>
> hw raid is mostly a fraud.  for sub-r5, it usually doesn't make sense
> because there is essentially zero extra work in doing r0 or r1.
> all disk interfaces have been fully busmastering for well over 5 years,
> even on cheap hardware.  you *could* argue that your data has to
> travel over the PCI twice for r1 writes.  it's true, but probably not
> a bottleneck, since you'll be unlikley to sustain writes of more than
> 40 MB/s per disk.

Ok

>
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

This is via promise Ultra 100 controller.. pci card.. I've not run memtest
yet but will do that now.. seeing as i can perform this test without raid
i'd of thought the md5sum calculations were more siginificant in memory
usage than raid but then again i dont know a lot about raid.. I will start
testing with memtest86 now

> > patches i can try.. should i abandon linux for raid and try
> using windows...
>
> egads.  there are billions and billions of ide-based linux servers
> out there, and most of them work fine.  your task is to find out what's
> wrong with your hardware.
>

Ok thanks I will look into this... all my computers seem to break at the
moment

