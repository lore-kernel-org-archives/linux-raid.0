From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: force spare to sync
Date: Fri, 14 Nov 2003 10:59:15 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16308.6867.661476.81122@notabene.cse.unsw.edu.au>
References: <200311131739.hADHdS226410@bzs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael on Thursday November 13
To: michael@insulin-pumpers.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 13, michael@insulin-pumpers.org wrote:
> I've been messing with a new raid 1 system with hot swap bays and it 
> occurred to me that in a raid/boot situation, the spare drive is not 
> sync'd and has no boot track. Is there a way to force the spare drive 
> to sync to the "master" set so that lilo can be run on that drive to 
> place a boot track with the appropriate information... or is there a 
> way to hold the spare in sync. This need not be done for the entire 
> disk, only the raid 1 boot partition. I can't see an easy way to do 
> this with the current tools, it might be a nice option to add to 
> future I'mplimentations.

If you want the spare to be in-sync with the rest of the array, then
it is not a spare, it is full member.

i.e. instead of making a RAID1 array with 2 drives and one space, make
it with three drives and no spare.

NeilBrown
