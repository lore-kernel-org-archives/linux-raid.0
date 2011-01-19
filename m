From: NeilBrown <neilb@suse.de>
Subject: Re: How to force rewrite of a smart detected bad block with raid5:
 checkarray?
Date: Thu, 20 Jan 2011 07:58:42 +1100
Message-ID: <20110120075842.25912e84@notabene.brown>
References: <20110119070419.GC31606@merlins.org>
	<alpine.DEB.1.10.1101190842170.13151@uplift.swm.pp.se>
	<20110119204115.0fe4b159@notabene.brown>
	<20110119173150.GB6823@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119173150.GB6823@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 09:31:50 -0800 Marc MERLIN <marc@merlins.org> wrote:

> On Wed, Jan 19, 2011 at 08:41:15PM +1100, NeilBrown wrote:
> > All you need to do is get md/raid5 to try reading the bad block.  Once it does
> > that it will get a read error and automagically try to correct it.
>  
> So, if I get this right, raid5 only reads n-1 drives. Unless I'm unlucky
> enough to have the bad disk be the parity stripe, just reading the file with
> a bad stripe by luck would cause the kernel to recompute parity on the read
> error and re-write the bad block?
> (I also read in the online docs that raid4 actually reads all the blocks,
> including parity, which is a bit slower, but would actually guarantee that
> all blocks are read, and parity is still consistent at ready time?)
> 
> 
> But back to your point: check, which I had started, will indeed do what I
> was hoping it would, thanks.
> 
> > If you were really keen, you could 
> >   cd /sys/block/mdXX/md
> >   echo 3907029168 > sync_min
> >   echo 3907029170 > sync_max
> >   echo check > sync_action
> 
> I stopped the full check, and tried:
>  
> gargamel:/sys/block/md7/md# cat sync_min
> 244188936
> gargamel:/sys/block/md7/md# cat sync_max
> max
> gargamel:/sys/block/md7/md# echo 3907029168 > sync_min
> bash: echo: write error: Invalid argument
> 
> Any idea what went wrong here?

Like I suggest, rounding might be necessary.
I just checked the code and this number does need to be a multiple of the
chunk size, which is 1024 sectors for you.
so 
   echo 3907028992 > sync_min

should do the trick.

NeilBrown

