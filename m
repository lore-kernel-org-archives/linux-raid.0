From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How safe is software RAID compared to how safe hardware RAID
     is!?
Date: Fri, 21 Nov 2003 10:38:05 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16317.20573.33929.67942@notabene.cse.unsw.edu.au>
References: <16314.40792.616508.878124@notabene.cse.unsw.edu.au>
	<PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
	<16314.44161.438158.27514@notabene.cse.unsw.edu.au>
	<48898.192.168.9.10.1069361618.squirrel@ncircle.nullnet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomi Orava on Thursday November 20
To: Tomi Orava <tomimo+linux-raid@ncircle.nullnet.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 20, tomimo+linux-raid@ncircle.nullnet.fi wrote:
> 
> >  I had a mirrored pair that kept getting data corruption.  It turned
> >  out that one of the drives had a bad bit in an internal buffer, and
> >  would occasionally return 1 for the 12th bit (or similar) of each
> >  sector even when it should be zero.   Neither software raid or
> >  hardware raid would cope with that.
> 
> How did you manage to figure out what was the reason for this
> corruption ? I mean, does there exist a some sort of "generic"
> way how to solve such errors, or was it just hard work in comparing
> what got written to the different disks ...

I think the generic solution is "Tear your hair out and wander around
muttering to everyone how this couldn't possibly be happening and
seeking sympathy".

Like lots of problem solving, it is a case of gathering as much
information as possible, staring at it for a while, and then
explaining to someone who has absolutely no expertise in the field
exactly why this collection of evidence is internally inconsistent and
it just isn't possible.  Usually that brings the answer out very
quickly.  (Some people say a brick wall will do, but I find a person
works much better).

One interesting aspect was that the drive with the problems was the
one that it would preferentially rebuild the raid from.  That tended
to make transient errors more permanent as they would get written onto
the second driver.  I'm not sure if that helpped or hindered though.

> 
> >  Some people find that their IDE controller works fine until they try
> >  to use RAID1.  RAID1 hits multiple discs concurrently a lot, and some
> >  (few, specific) ide controllers don't appear to cope.  You probably
> >  would not get that with hardware raid.  You can with software raid
> >  because it is a "whole-system" thing.
> 
> Can you name the controllers which have had problems in this area ?
> I'm having big problems in Linux 2.4 kernels IDE-stability with
> heavy I/O (all disks are RAID1), perhaps either the Sil680 or
> HPT374 are just problematic controllers ... ? (it would be just great
> to solve all of these problems by buying new IDE-cards :)

I'm afraid I haven't collected names.  I avoid IDE raid like the
plague, and just stick with SCSI - too many bad experiences.
NOTE: This is not advice on my part to not use IDE.  My experience is
not sufficient to base a recommendation on.  But for me, my budget
allows SCSI, and it just makes me feel a lot safer.

NeilBrown
