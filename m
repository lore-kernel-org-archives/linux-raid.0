From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 11:23:08 -0500
Message-ID: <200501091623.j09GNG917488@www.watkins-home.com>
References: <crqvu3$q7e$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <crqvu3$q7e$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mario Holbe' <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bad sectors are detected on write.  There are 5 wires going to each of the
read/write heads on my disk drives.  I think each head can read after write
in 1 pass.  My specs say it re-maps on write failure and read failure.  Both
are optional.  But, I don't know if this is normal or not.  My disks are
Seagate ST118202LC, 10,000 RPM, 18 Gig SCSI.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mario Holbe
Sent: Sunday, January 09, 2005 5:10 AM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

maarten <maarten@ultratux.net> wrote:
> Do you mean SCSI ones do ?  If so, I thought the firmware intelligence
between 

I don't think, SCSI ones do so. However, I don't know many
SCSI drives and thus I limited my sentence to IDE drives :)

> 1.  If you write to it and that fails the drive will allocate a spare
sector.  

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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

