From: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Subject: RE: Growing an Array?
Date: Wed, 06 Nov 2002 10:26:54 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A506359028CAD21191C10008C75D895C040B8844@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Alistair Riddell' <ali@gwc.org.uk>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


My array is currently 6 X 73GB.

I think you are saying that I can do this now using resize2fs?   I think I pessimistically assumed that tool was destructive.


Regards,

Gary Huntress
Code 4113
Naval Undersea Warfare Center
Newport, RI  02841
1-800-669-6892 x28990

-----Original Message-----
From: Alistair Riddell [mailto:ali@gwc.org.uk]
Sent: Wednesday, November 06, 2002 10:13 AM
Cc: 'linux-raid@vger.kernel.org'
Subject: Re: Growing an Array?


On Wed, 6 Nov 2002, Huntress Gary B NPRI wrote:

> 1)  pop out drive 1
> 2)  Insert new drive
> 3)  "initialize" the new drive
> 4)  Some magic happens and the larger drive becomes part of the array
>
> lather, rinse, repeat for the remaining replacement drives and *poof* I have a larger array.

In theory you could do this now...

> This capability would save me an incredible amount of labor and hand wringing.  Our "technology refresh" upgrades happen quite regularly because our data never stops growing.   Is this a pipe dream or an eventual reality?

How much data are you talking about? It took me 16 hours to resize to a
10x73GB array. If you were to do that in stages then it could end up
taking days or weeks in which case backing up to DLT might become more
attractive.

Note that the raid array will be offline while the resize takes place.

-- 
Alistair Riddell - BOFH
IT Manager, George Watson's College, Edinburgh
Tel: +44 131 446 6070    Fax: +44 131 452 8594
Microsoft - because god hates us

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
