From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: RE: Disk failure during grow, what is the current state.
Date: Wed, 6 Feb 2008 17:55:42 -0000
Message-ID: <058101c868e9$7dc636f0$0603a8c0@meanmachine>
References: <047a01c868d1$821f92e0$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <047a01c868d1$821f92e0$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: 'Steve Fairbairn' <steve@fairbairn-family.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > -----Original Message-----
> > From: Steve Fairbairn [mailto:steve@fairbairn-family.com]
> > Sent: 06 February 2008 15:02
> > To: 'Nagilum'
> > Subject: RE: Disk failure during grow, what is the current state.
> > 
> > 
> >      Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
> >   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
> > 
> > Surely the added disk should now been added to the Array
> > Size?  5 * 500GB is 2500GB, not 2000GB.  This is why I don't 
> > think the reshape has continued.  As for speeding up because 
> > of no IO badwidth, this also doesn't actually hold very true, 
> > because the system was at a point of not being used anyway 
> > before I added the disk, and I didn't unmount the drive until 
> > this morning after it claimed it had finished doing anything.
> > 

Thanks again to Alex for his comments.  I've just rebooted the box, and
the reshape has continued on the degraded array and an RMA has been
raised for the faulty disk.

Thanks,

Steve.

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.19.20/1261 - Release Date:
05/02/2008 20:57
 

