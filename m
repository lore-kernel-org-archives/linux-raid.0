From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How do we handle the same but uptodated data to disk cache?
Date: Tue, 27 May 2003 12:47:06 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16082.53674.340479.177651@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0305261738440.19678-100000@q7.q7.com>
	<004301c323f9$71916a10$6b01a8c0@bmoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bmoon on Monday May 26
To: bmoon <bo@anthologysolutions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 26, bo@anthologysolutions.com wrote:
> Hello,
> 
> I want to write the data to the fixed sector with the same size frequently
> just like MD super block, but I do not want to sync and flush the dev
> on each write.
> 
> For example, to write md super block in /drivers/md/md.c

I suggest you look at a newer md.c.  With 2.4.21pre or 2.5.* have
"sync_page_io" which does what you want more effectively.

NeilBrown
