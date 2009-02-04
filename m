From: "Thomas J. Baker" <tjb@unh.edu>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks
 reporting "No md superblock detected"?
Date: Wed, 04 Feb 2009 16:17:58 -0500
Message-ID: <1233782278.696.6.camel@localhost.localdomain>
References: <1233775657.10151.5.camel@localhost.localdomain>
	 <4989FF7B.6030503@scalableinformatics.com>
	 <1233781437.696.2.camel@localhost.localdomain>
Reply-To: tjb@unh.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233781437.696.2.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2009-02-04 at 16:03 -0500, Thomas J. Baker wrote:
> On Wed, 2009-02-04 at 15:50 -0500, Joe Landman wrote:
> > Thomas J. Baker wrote:
> > > Any help greately appreciated. Here are the details:
> > > 
> > > [root@node002 ~]# ./examineRAIDDisks 
> > > mdadm -E /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1 /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
> > > /dev/sdb1:
> > >           Magic : a92b4efc
> > >         Version : 00.90.00
> > 
> > Hi Thomas:
> > 
> >    Don't you need 1.0 or higher superblocks to make this work?
> > 
> > Joe
> 
> The array was made probably two years ago and had been working fine
> until recently. In reading the documentation for mdadm, it did seem like
> it should have required me to use the higher version but it never
> complained when I made it and worked fine.
> 
> Thanks,
> 
> tjb


Actually, rereading it makes me think it's OK. There are only 27 devices
in the array and one hot spare. Each device is only 300GB, less than the
2TB limit.

0, 0.90, default
                     Use the original 0.90  format  superblock.   This  format
                     limits  arrays  to 28 component devices and limits compo-
                     nent devices of levels 1 and greater to 2 terabytes.

I'll admit I could be misunderstanding something here.


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

