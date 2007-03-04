From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt questions
Date: Sun, 4 Mar 2007 22:50:01 +1100
Message-ID: <17898.45673.573800.56474@notabene.brown>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
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
> Hello,
> 
> these questions apparently got buried in another thread, so here goes again ...
> 
> I have a mismatch_cnt of 384 on a 2-way mirror.
> The box runs 2.6.17.4 and can't really be rebooted or have its kernel
> updated easily
> 
> 1) Where does the mismatch come from?
>  The box hasn't been down since the creation of the array.

Do you have swap on the mirror at all? 
I recently discovered/realised that when 'swap' writes to a raid1 it
can end up with different data on the different devices.  This is
perfectly acceptable as in that case the data will never be read.

If you don't have swap, then I don't know what is happening.

> 
> 2) How much data is 384? Blocks? Chunks? Bytes?

The units is 'sectors', but the granularity is about 64K.
so '384' means 3 different 64K sections of the device showed an
error.  One day I might reduce the granularity.

> 
> 3) Is the "repair" sync action safe to use on the above kernel? Any
> other methods / additional steps for fixing this?

"repair" is safe, though it may not be effective.
"repair" for raid1 was did not work until Jan 26th this year.
Before then it was identical in effect to 'check'.

NeilBrown
