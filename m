From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: experiences with 3Ware 6400 3W-6400?
Date: Fri, 27 Jun 2003 10:36:09 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0306271017580.9087-100000@router.windsormachine.com>
References: <Pine.LNX.4.44.0306261700260.12147-100000@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0306261700260.12147-100000@chaos.egr.duke.edu>
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 26 Jun 2003, Joshua Baker-LePain wrote:

> As an IDE controller, it'll work great.  The hardware RAID performance
> (especially RAID 5) ain't gonna' be hot, though.  The 7500 series performs

Now that's an understatement :)

P4 2.53, Asus P4B533-e, 3ware 7500-4, 4 Maxtor Maxline 250 gb drives in
raid5.

mickey,512M,17840,60,19878,5,8683,2,28247,89,91356,8,243.0,0,16,2576,81,+++++,+++,+++++,+++,3184,96,+++++,+++,9392,96

P4 2.53, Asus P4B533, 3ware 7500-4, 2 Maxtor DiamondMax 9 200 gb drives in
Raid1. (different machine)

r1,512M,26616,94,52362,15,21394,5,28918,92,47633,4,301.8,0,16,3145,99,+++++,+++,+++++,+++,3214,99,+++++,+++,10229,95

Half to a third the write speed, although the read speed is a lot
better.

Haven't upgraded to the 7.6 firmware yet(still using 7.5.3 that was on
the card), anyone notice any difference?

The 7000-2 and 7500-4's in raid1 work quite nicely.  The 7500-4 in raid5
actually lags the system for 3-5 seconds when doing a lot of disk i/o.
Feels like working on a p120 with DMA shut off, to be honest.

Works for what I'm doing with it though.

Mike

