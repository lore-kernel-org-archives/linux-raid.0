From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: promise sx6000 success / raid options
Date: Mon, 28 Oct 2002 10:06:36 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0210280957480.14007-100000@router.windsormachine.com>
References: <Pine.LNX.4.44.0210281543340.30878-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0210281543340.30878-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Vlad Milovanovic <vlad@webmail.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Something seems really off, here's what I'm getting with a software raid5,
with 5 old drives.  Quantum AS's, ranging from 30 to 60 gig, using a 30
gig partition at the beginning of the disk.

Version 1.02b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP /sec %CP
mickey         496M 25696  86 52301  13 17383   5 23384  76 52586   5 288.4   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  5149  92 +++++ +++ +++++ +++  5820  99 +++++ +++ 15755 100
mickey,496M,25696,86,52301,13,17383,5,23384,76,52586,5,288.4,0,16,5149,92,+++++,+++,+++++,+++,5820,99,+++++,+++,15755,100

e2fs'd with -i 262144, using a 256k blocksize in my raidtab.  2.4.20pre11
kernel(onboard ide doesn't work in dma with stock 2.4.19)

50 meg per second on block, in or out.

CPU is a single P4/2.53, 256 meg pc2100.  Using the onboard promise chips,
two drives per controller, and the last drive is on an onboard port.

Yes, I know this is not a very good way of doing this, if one drive fails
it might take the other on the chain with it.  But I'm waiting for Maxtor
to actually release(not this vapourware stuff) their 320 gig drives, so I
can get ahold of a 3ware 7500-4 and 3 of the 320's, and replace this
horrible mess.

Mike

