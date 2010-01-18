From: Neil Brown <neilb@suse.de>
Subject: Re: non-fresh data unavailable bug
Date: Mon, 18 Jan 2010 16:32:51 +1300
Message-ID: <20100118163251.28b6a84e@notabene>
References: <hinc60$fnh$1@ger.gmane.org>
	<4877c76c1001141124m1d3fcfcdmffc3df97d1b504a@mail.gmail.com>
	<hiq226$n6t$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hiq226$n6t$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <bruss@netezza.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Jan 2010 10:36:39 -0500
Brett Russ <bruss@netezza.com> wrote:

> On 01/14/2010 02:24 PM, Michael Evans wrote:
> > On Thu, Jan 14, 2010 at 7:10 AM, Brett Russ<bruss@netezza.com>  wrote:
> >> Slightly related to my last message here Re:non-fresh behavior, we have seen
> >> cases where the following happens:
> >> * healthy 2 disk raid1 (disks A&  B) incurs a problem with disk B
> >> * disk B is removed, unit is now degraded
> >> * replacement disk C is added; recovery from A to C begins
> >> * during recovery, disk A incurs a brief lapse in connectivity.  At this
> >> point C is still up yet only has a partial copy of the data.
> >> * a subsequent assemble operation on the raid1 results in disk A being
> >> kicked out as non-fresh, yet C is allowed in.
> >
> > I believe the desired and logical behavior here is to refuse running
> > an incomplete array unless explicitly forced to do so.  Incremental
> > assembly might be what you're seeing.
> 
> This brings up a good point.  I didn't mention that the assemble in the 
> last step above was forced.  Thus, the "bug" I'm reporting is that under 
> duress, mdadm/md chose to assemble the array with a partially recovered 
> (but "newer") member instead of the older member which was the recovery 
> *source* for the newer member.
> 
> What I think should happen is members that are *destinations* for 
> recovery should *never* receive a higher event count, timestamp, or any 
> other marking than the recovery sources.  By definition they are 
> incomplete and can't be trusted, thus they should never trump a complete 
> member during assemble.  I would assume the code already does this but 
> perhaps there is a hole.
> 
> One other piece of information that may be relevant--we're using 2 
> member RAID1 units with one member marked write-mostly.  At this time, I 
> don't have the specifics for which member (A or B) was the write-mostly 
> member in the example above, but I can find that out.
> 
> > I very much recommend running it read-only until you can determine which
> > assembly pattern produces the most viable results.
> 
> Good tip.  We were able to manually recover the array in the case 
> outlined above, now we're looking back to fixing the kernel to prevent 
> it happening again.
>


Thanks for the report.  It sounds like a real problem.
I'm travelling at the moment so reproducing it would be a challenge.
If you are able to, can you report the output of
  mdadm -E /dev/list-of-devices
at the key points in the process, and also add "-v" to any
mdadm --assemble
command you use, and report the output?

Thanks,
NeilBrown
