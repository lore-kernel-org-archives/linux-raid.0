From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: Consensus?...
Date: Thu, 28 Aug 2003 14:49:33 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0308281352280.3109-100000@multivac.sdsc.edu>
References: <1062035585.21455.6.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1062035585.21455.6.camel@south.rosestar.lan>
To: Bob Hillegas <bobhillegas@houston.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27 Aug 2003, Bob Hillegas wrote:

> I will be setting up a raided system early next year once kernel 2.6 is
> stable.
>
> Is there any consensus as to which scsi adapter AND non-scsi adapter
> will be preferred?

I have used many of the 3Ware 7000/7500 series IDE RAID controllers.  They
are quite stable.  One of my customers had never-ending problems with
their Adaptec 2400A controllers, until they switched to 3Ware.

One caveat to this is the disks.  I used Western Digital disks in many of
the systems I've built.  On those systems AND ONLY THOSE SYSTEMS, I'm
getting a disk failure rate of 1%-2% per month.  This is with disks that
have the updated firmware.

When the WD diagnostic ('dlgdiag') is run on the disk, problems are
normally found, and repaired.  The bad news is that it takes time to
replace the disk, and run the diagnostic.

I have seen NO significant problems with IBM/Hitachi or Maxtor disks.  I
haven't tried using Seagate disks in an IDE array.

				Peter Ashford

