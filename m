From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Fri, 22 Jun 2007 12:24:45 +1000
Message-ID: <18043.13037.40956.366334@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<46756BE2.7010401@tmr.com>
	<467B03C1.50809@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday June 21
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 21, davidsen@tmr.com wrote:
> I didn't get a comment on my suggestion for a quick and dirty fix for 
> -assume-clean issues...
> 
> Bill Davidsen wrote:
> > How about a simple solution which would get an array on line and still 
> > be safe? All it would take is a flag which forced reconstruct writes 
> > for RAID-5. You could set it with an option, or automatically if 
> > someone puts --assume-clean with --create, leave it in the superblock 
> > until the first "repair" runs to completion. And for repair you could 
> > make some assumptions about bad parity not being caused by error but 
> > just unwritten.

It is certainly possible, and probably not a lot of effort.  I'm not
really excited about it though.

So if someone to submit a patch that did the right stuff,  I would
probably accept it, but I am unlikely to do it myself.


> >
> > Thought 2: I think the unwritten bit is easier than you think, you 
> > only need it on parity blocks for RAID5, not on data blocks. When a 
> > write is done, if the bit is set do a reconstruct, write the parity 
> > block, and clear the bit. Keeping a bit per data block is madness, and 
> > appears to be unnecessary as well.

Where do you propose storing those bits?  And how many would you cache
in memory?  And what performance hit would you suffer for accessing
them?  And would it be worth it?

NeilBrown
