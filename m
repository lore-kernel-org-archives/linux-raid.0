From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Software Raid 1 data corruptions..
Date: Sun, 16 Nov 2003 16:23:55 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOAEFFGOAA.jim@jimtreats.com>
References: <Pine.LNX.4.44.0311151155150.28018-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
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

Ok an update.. I've been running memtest over night, and all day, up to
nearly 22 hours now, its a slow computer (p3 450 with nearly 512meg memory)
so i've only gotten up to 12 tests in that time.. everyone has passed.. no
errors reported yet.. surely this makes memory errors fairly unlikely as the
cause of this problem... when i hit 24 hours i will be stopping the test and
trying to stress the 2 drives on the controller simultaneously to see if it
holds up (to possibly identify if the ata controller is at fault..

> > patches i can try.. should i abandon linux for raid and try
> using windows...
>
> egads.  there are billions and billions of ide-based linux servers
> out there, and most of them work fine.  your task is to find out what's
> wrong with your hardware.
>

