From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: force spare to sync
Date: Fri, 14 Nov 2003 11:26:17 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16308.8489.411169.830830@notabene.cse.unsw.edu.au>
References: <200311140019.hAE0JR204528@bzs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael on Thursday November 13
To: michael@insulin-pumpers.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 13, michael@insulin-pumpers.org wrote:
> > 
> > If you want the spare to be in-sync with the rest of the array, then
> > it is not a spare, it is full member.
> > 
> > i.e. instead of making a RAID1 array with 2 drives and one space,
> > make it with three drives and no spare.
> > 
> > NeilBrown
> > 
> Can you really make a 3 partition raid 1 with no spare???? And all 3 
> partitions will remain in sync???  I haven't dug into the kernel 

Certainly you can.  There is nothing magic a "2" in raid1.  You can
have a RAID1 array of 27 drives if you like and they will always be
kept in sync.

> ..... but wadda I know???

enough to ask questions, which is a good start.

NeilBrown
