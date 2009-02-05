From: "Thomas J. Baker" <tjb@unh.edu>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks
 reporting "No md superblock detected"?
Date: Thu, 05 Feb 2009 13:59:18 -0500
Message-ID: <1233860358.1780.21.camel@localhost.localdomain>
References: <1233775657.10151.5.camel@localhost.localdomain>
	 <4989FF7B.6030503@scalableinformatics.com>
	 <1233781437.696.2.camel@localhost.localdomain>  <498B34AA.5020606@tmr.com>
Reply-To: tjb@unh.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <498B34AA.5020606@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2009-02-05 at 13:49 -0500, Bill Davidsen wrote:
> Thomas J. Baker wrote:
> > The array was made probably two years ago and had been working fine
> > until recently. In reading the documentation for mdadm, it did seem like
> > it should have required me to use the higher version but it never
> > complained when I made it and worked fine.
> >   
> 
> What have you changed lately? Are the drives all on a single controller? 
> Are you using PARTITIONS in mdadm.conf and letting mdadm find things for 
> itself?
> 

The array is made up of two Dell PowerVault 220s in split bus
configuration with two Adaptec 39160 Dual Channel SCSI controllers. Each
half of each PowerVault (7 disks) is connected to one of the channels on
the Adaptecs. Four channels in all.

As far as changing things, what do you mean? The cause of the failure is
likely heat as we've had some AC issues recently.

I didn't use mdadm.conf at all. All disks are partitioned with one
'Linux raid autodetect' partition.  mdadm had always found the array
automatically at boot.


Thanks,

tjb
-- 
=======================================================================
| Thomas Baker                                  email: tjb@unh.edu    |
| Systems Programmer                                                  |
| Research Computing Center                     voice: (603) 862-4490 |
| University of New Hampshire                     fax: (603) 862-1761 |
| 332 Morse Hall                                                      |
| Durham, NH 03824 USA              http://wintermute.sr.unh.edu/~tjb |
=======================================================================

