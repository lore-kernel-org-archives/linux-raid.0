From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: using the raid6check report
Date: Sun, 8 Jan 2017 22:41:12 +0100
Message-ID: <20170108214111.GA7933@lazy.lzy>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au>
 <20170108174010.GA3699@lazy.lzy>
 <5872A698.7000009@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5872A698.7000009@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 08, 2017 at 08:52:40PM +0000, Wols Lists wrote:
> On 08/01/17 17:40, Piergiorgio Sartor wrote:
> > On Fri, Dec 23, 2016 at 11:56:34AM +1100, Eyal Lebedinsky wrote:
> >> > From time to time I get non-zero mismatch_count in the weekly scrub. The way I handle
> >> > it is to run a check around the stripe (I have a background job printing the mismatch
> >> > count and /proc/mdstat regularly) which should report the same count.
> >> > 
> >> > I now drill into the fs to find which files use this area, deal with them and delete
> >> > the bad ones. I then run a repair on that small area.
> >> > 
> >> > I now found about raid6check which can actually tell me which disk holds the bad data.
> >> > This is something raid6 should be able to do assuming a single error.
> >> > Hoping it is one bad disk, the simple solution now is to recover the bad stripe on
> >> > that disk.
> >> > 
> >> > Will a 'repair' rewrite the bad disk or just create fresh P+Q which may just make the
> >> > bad data invisible to a 'check'? I recall this being the case in the past.
> > "repair" should fix the data which is assumed
> > to be wrong.
> > It should not simply correct P+Q, but really
> > find out which disk is not OK and fix it.
> > 
> Having just looked at the man page and the source to raid6check as found
> online ...
> 
> "man raid6check" says that it does not write to the disk. Looking at the
> source, it appears to have code that is intended to write to the disk
> and repair the stripe. So what's going on?

There was a patch adding the write capability,
but likely only for the C code, not the man page.

> 
> I can add it to the wiki as a little programming project, but it would
> be nice to know the exact status of things - my raid-fu isn't good
> enough at present to read the code and work out what's going on.
> 
> It would be nice to be able to write "parity-check" or somesuch to
> sync_action, and then for raid5 it would check and update parity, or
> raid6 it would check and correct data/parity.

At that time, the agreement with Neil was to do
such things in user space and not inside the
md raid "driver" (so to speak) in kernal space.

So, as far as I know, the kernel md code can
check the parity and, possibily, re-write.

"raid6check" can detect errors *and*, if only one,
where it is, so a "data repair" capability is possible.

bye,

pg
 
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
