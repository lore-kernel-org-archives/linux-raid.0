From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: building a large/fast server
Date: Wed, 29 Jan 2003 15:44:39 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301291534250.12434-100000@chaos.egr.duke.edu>
References: <Pine.LNX.4.44.0301292122570.24750-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0301292122570.24750-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Jan 2003 at 9:23pm, Mikael Abrahamsson wrote

> On Wed, 29 Jan 2003, Joshua Baker-LePain wrote:
> 
> > As for comments, in my testing on a single 3ware board (in hardware 
> > RAID5), ext3's write speeds sucked.  I'd suggest including XFS in your 
> > testing.
> 
> Will xfs help write speeds with 3ware hardware raid5? You have tested 
> this? Just as you have experienced, my 3ware raid5 write speeds are lousy, 
> approx 5-15 megs/s.

Here's the output of a bonnie++ run on a single 3ware hardware RAID5 
array.  The system is dual 2.2GHz Xeons on a SuperMicro P4DPE-G2 with 
2GB of RAM.  I'm using the 160GB Maxtors, and I've setup a hot spare (so 
it's a 7 drive array).  I'm running Red Hat 7.3 with kernel 2.4.18-17 
patched with XFS 1.2pre3 from SGI:

Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
$BOX             4G 24222  99 56221  16 31373  13 24478  95 204587  39 394.6   2
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  1901  15 +++++ +++  1099   8   979   8 +++++ +++   960   7
$BOX,4G,24222,99,56221,16,31373,13,24478,95,204587,39,394.6,2,16,1901,15,+++++,+++,1099,8,979,8,+++++,+++,960,7


-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

