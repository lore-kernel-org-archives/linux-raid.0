From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID-10 with odd number of disks (was Re: Software RAID 0+1 with mdadm.)
Date: Thu, 27 Jan 2005 13:30:27 -0500
Message-ID: <200501271828.j0RISV911260@www.watkins-home.com>
References: <20050127174200.GO82728@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050127174200.GO82728@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Andy Smith' <andy@lug.org.uk>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

A normal RAID 10 requires an even number of disks.

Neil gave a detailed description.  Maybe 6 months ago.  Do a search for
RAID10 or raid10.

I just looked at the link you gave.  RAID-1E does look like the RAID10 that
md supports.  Until today, I had never seen RAID-1E.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Andy Smith
Sent: Thursday, January 27, 2005 12:42 PM
To: 'linux-raid'
Subject: Re: RAID-10 with odd number of disks (was Re: Software RAID 0+1
with mdadm.)

On Thu, Jan 27, 2005 at 05:27:00PM +0000, Andy Smith wrote:
> On Thu, Jan 27, 2005 at 12:16:31PM -0500, Guy wrote:
> > It rotates the pairs!
> > Assume 3 disks, A, B and C.
> > Each stripe would be on these disks:
> > A+B
> > C+A
> > B+C
> > A+B
> > C+A
> > B+C
> > ...
> 
> Hmm, difficult to visualise and comprehend if there are any
> differences as opposed to "normal" RAID-10.
> 
> Is this anything like how RAID-1E works on IBM ServeRAID?

This seems relevant:

http://www.adaptec.com/worldwide/product/markeditorial.html?sess=no&language
=English+US&prodkey=raid_10_alternatives&type=White%20Papers

