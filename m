From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt questions
Date: Mon, 5 Mar 2007 09:19:25 +1100
Message-ID: <17899.17901.429001.702653@notabene.brown>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
	<17898.45673.573800.56474@notabene.brown>
	<bb145bd20703040401h413d996av24d55eb21fae63a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian Pernegger on Sunday March 4
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday March 4, pernegger@gmail.com wrote:
> Hey, that was quick ... thanks!
> 
> > > 1) Where does the mismatch come from? The box hasn't been down since the creation of
> > >  the array.
> >
> > Do you have swap on the mirror at all?
> 
> As a matter of fact I do, /dev/md0_p2 is a swap partition.
> 
> > I recently discovered/realised that when 'swap' writes to a raid1 it can end up with different
> > data on the different devices.  This is perfectly acceptable as in that case the data will never
> > be read.
> 
> Interesting ... care to elaborate a little?

When we write to a raid1, the data is DMAed from memory out to each
device independently, so if the memory changes between the two (or
more) DMA operations, you will get inconsistency between the devices.

When the data being written is part of a file, the page will still be
dirty after the write 'completes' so another write will be issued
fairly soon (depending on various VM settings) and so the
inconsistency will only be visible for a short time, and you probably
won't notice.

If this happens when writing to swap - i.e. if the page is dirtied
while the write is happening - then the swap system will just forget
that that page was written out.  It is obviously still active, so some
other page will get swapped out instead.
There will never be any attempt to write out the 'correct' data to the
device as that doesn't really mean anything.

As more swap activity happens it is quite possible that the
inconsistent area of the array will be written again with consistent
data, but it is also quite possible that it won't be written for a
long time.  Long enough that a 'check' will find it.

In any of these cases there is no risk of data corruption as the
inconsistent area of the array will never be read from.

> 
> Would disabling swap, running mkswap again and rerunning check return
> 0 in this case?

Disable swap, write to the entire swap area
   dd if=/dev/zero of=/dev/md0_p2 bs=1M
then mkswap and rerun 'check' and it should return '0'.  It did for
me.

NeilBrown

