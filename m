From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 11:10:11 +0100
Message-ID: <crqvu3$q7e$1@sea.gmane.org>
References: <200501081855.j08It8910389@www.watkins-home.com> <200501082025.20463.maarten@ultratux.net> <crpg32$2rr$1@sea.gmane.org> <200501090001.31738.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> Do you mean SCSI ones do ?  If so, I thought the firmware intelligence between 

I don't think, SCSI ones do so. However, I don't know many
SCSI drives and thus I limited my sentence to IDE drives :)

> 1.  If you write to it and that fails the drive will allocate a spare sector.  

As I said earlier:

>> 1. would require some verify-operation, so I'm not sure if this
>> is done at all in the wild.

A verify would take time and therefore I think, this is not done.
Btw: *if* it would be done, write speed to disks should be read-speed/2
or smaller, but usually it isn't.

> From that we [should be] able to conclude that if you get a write failure 
> that the drive ran out of spare sectors. (is that a fact, or not??)

Yes, this is a fact.

> So basically what you're saying is that reallocation _only_ happens on 
> _writes_ ?  Hm.  Maybe, I don't know...

What I'm saying is: bad sectors are _only_ detected on reads and
reallocations only happen on writes, yes.

> Or maybe that isn't a problem since the disk gets kicked, and afterwards 
> during resync the reallocation pays off. Yeah.  That must be it. :-)

This is what I said, yes :)


regards,
   Mario
-- 
() Ascii Ribbon Campaign
/\ Support plain text e-mail

