From: Alistair Riddell <ali@gwc.org.uk>
Subject: Re: Growing an Array?
Date: Wed, 6 Nov 2002 15:12:34 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211061507140.21941-100000@frank.gwc.org.uk>
References: <A506359028CAD21191C10008C75D895C040B8841@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A506359028CAD21191C10008C75D895C040B8841@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

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

