From: Thomas Baker <tjb@unh.edu>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks reporting "No md superblock detected"?
Date: Sun, 8 Feb 2009 17:02:49 -0500
Message-ID: <9B27D278-ED85-498A-8EF6-DDB7EFB103F7@unh.edu>
References: <1233775657.10151.5.camel@localhost.localdomain> <18827.51024.270348.20624@notabene.brown> <alpine.LNX.2.00.0902061903510.21732@filesrv1.baby-dragons.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0902061903510.21732@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 6, 2009, at 11:05 PM, Mr. James W. Laferriere wrote:

> 	Hello Neil ,  In this thread you mention a (I think) script named  
> examinRAIDDisks .
> 	Is this available someplace ?
> 	I've searched the archive & it does not appear to be mentioned  
> anywhere but this thread .
> 		Tia ,  JimL

It's just a script I wrote that runs mdadm -E on all my disks so I  
don't have to keep typing all those disk names:

#!/bin/csh -x

mdadm -E \
/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 \
/dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 \
/dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1 \
/dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1



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



