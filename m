From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: RAID5 causing lockups
Date: Wed, 25 Jun 2003 15:28:12 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0306251524310.2439-100000@router.windsormachine.com>
References: <200306251216300921.4D495D48@shargaas.coreyfro.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306251216300921.4D495D48@shargaas.coreyfro.com>
To: Corey McGuire <coreyfro@coreyfro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 25 Jun 2003, Corey McGuire wrote:

> I have 6 drives and 3 controllers.  Each drive is a 200GB WD drive, set to
> "Single/Master" on their channel.

Go get the utility on wdc's site to fix the problems they have, and see
what happens after that.

http://support.wdc.com/download/index.asp#raidno3ware

They have problems with power management, and the drive is kicked out of
the raid array.

This may or may not be the trouble, but at least see if it needs it.

Mike

