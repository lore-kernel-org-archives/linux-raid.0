From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: using the raid6check report
Date: Sun, 8 Jan 2017 21:46:59 +0100
Message-ID: <20170108204659.GB7057@lazy.lzy>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
 <20170108174010.GA3699@lazy.lzy>
 <a33dbf5c-465d-b5af-a9a9-a00664816489@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a33dbf5c-465d-b5af-a9a9-a00664816489@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 09, 2017 at 07:36:59AM +1100, Eyal Lebedinsky wrote:
> On 09/01/17 04:40, Piergiorgio Sartor wrote:
> > On Fri, Dec 23, 2016 at 11:56:34AM +1100, Eyal Lebedinsky wrote:
> > > From time to time I get non-zero mismatch_count in the weekly scrub. The way I handle
> > > it is to run a check around the stripe (I have a background job printing the mismatch
> > > count and /proc/mdstat regularly) which should report the same count.
> > > 
> > > I now drill into the fs to find which files use this area, deal with them and delete
> > > the bad ones. I then run a repair on that small area.
> > > 
> > > I now found about raid6check which can actually tell me which disk holds the bad data.
> > > This is something raid6 should be able to do assuming a single error.
> > > Hoping it is one bad disk, the simple solution now is to recover the bad stripe on
> > > that disk.
> > > 
> > > Will a 'repair' rewrite the bad disk or just create fresh P+Q which may just make the
> > > bad data invisible to a 'check'? I recall this being the case in the past.
> > 
> > "repair" should fix the data which is assumed
> 
> You say "should", as in "it does today" or as in "need to change to do" this?
> As I noted originally, the man pages says it does the simple thing - should the
> man page be fixed?

"should" as in "it is supposed to do it".

So, as far as I know, "raid6check" with "repair" will
check the parity and try to find errors.
If possible, it will find where the error is, then
re-compute the value and write the corrected data.

Now, this was somehow tested and *should* work.

An other option is just to check for the errors and
see if one drive is constantly at fault.
This will not write anything, so it is safer, but
it will help to see if there are strange things,
before writing to the disk(s).

bye,

pg
 
> > to be wrong.
> > It should not simply correct P+Q, but really
> > find out which disk is not OK and fix it.
> > 
> > > 
> > > 'man md' still says
> > > 	For RAID5/RAID6 new parity blocks are written
> > > I think RAID6 can do better.
> > > 
> > > TIA
> > > 
> > > --
> > > Eyal Lebedinsky (eyal@eyal.emu.id.au)
> 
> -- 
> Eyal Lebedinsky (eyal@eyal.emu.id.au)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
