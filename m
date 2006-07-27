From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Thu, 27 Jul 2006 10:28:54 -0400
Message-ID: <170fa0d20607270728y176c3faega872bfa031342485@mail.gmail.com>
References: <44C5BA6F.3010404@steeleye.com>
	 <170fa0d20607261430n3e9d3962xeef50669ce0d1996@mail.gmail.com>
	 <44C8248B.7010501@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C8248B.7010501@steeleye.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 7/26/06, Paul Clements <paul.clements@steeleye.com> wrote:
> Mike Snitzer wrote:
>
> > I tracked down the thread you referenced and these posts (by you)
> > seems to summarize things well:
> > http://marc.theaimsgroup.com/?l=linux-raid&m=111116563016418&w=2
> > http://marc.theaimsgroup.com/?l=linux-raid&m=111117515400864&w=2
> >
> > But for clarity's sake, could you elaborate on the negative
> > implications of not merging the bitmaps on the secondary server?  Will
> > the previous primary's dirty blocks get dropped on the floor because
> > the secondary (now the primary) doesn't have awareness of the previous
> > primary's dirty blocks once it activates the raid1?
>
> Right. At the time of the failover, there were (probably) blocks that
> were out of sync between the primary and secondary.

OK, so now that I understand the need to merge the bitmaps... the
various scenarios that create this (potential) inconsistency are still
unclear to me when you consider the different flavors of raid1.  Is
this inconsistency only possible if using async (aka write-behind)
raid1?

If not, how would this difference in committed blocks occur with
normal (sync) raid1 given MD's endio acknowledges writes after they
are submitted to all raid members?  Is it merely that the bitmap is
left with dangling bits set that don't reflect reality (blocks weren't
actually changed anywhere) when a crash occurs?  Is there real
potential for inconsistent data on disk(s) when using sync raid1 (does
having an nbd member increase the likelihood)?

regards,
Mike
