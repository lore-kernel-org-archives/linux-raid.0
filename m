From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: using the raid6check report
Date: Sun, 8 Jan 2017 18:40:10 +0100
Message-ID: <20170108174010.GA3699@lazy.lzy>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 23, 2016 at 11:56:34AM +1100, Eyal Lebedinsky wrote:
> From time to time I get non-zero mismatch_count in the weekly scrub. The way I handle
> it is to run a check around the stripe (I have a background job printing the mismatch
> count and /proc/mdstat regularly) which should report the same count.
> 
> I now drill into the fs to find which files use this area, deal with them and delete
> the bad ones. I then run a repair on that small area.
> 
> I now found about raid6check which can actually tell me which disk holds the bad data.
> This is something raid6 should be able to do assuming a single error.
> Hoping it is one bad disk, the simple solution now is to recover the bad stripe on
> that disk.
> 
> Will a 'repair' rewrite the bad disk or just create fresh P+Q which may just make the
> bad data invisible to a 'check'? I recall this being the case in the past.

"repair" should fix the data which is assumed
to be wrong.
It should not simply correct P+Q, but really
find out which disk is not OK and fix it.

> 
> 'man md' still says
> 	For RAID5/RAID6 new parity blocks are written
> I think RAID6 can do better.
> 
> TIA
> 
> -- 
> Eyal Lebedinsky (eyal@eyal.emu.id.au)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
