From: Neil Brown <neilb@suse.de>
Subject: RE: Spare fails to transfer between RAID groups
Date: Wed, 13 May 2009 21:07:28 +1000
Message-ID: <18954.43504.87590.384746@notabene.brown>
References: <001901c9d202$709acad0$51d06070$@us>
	<18952.46349.611683.608352@notabene.brown>
	<007c01c9d34c$9a618f70$cf24ae50$@us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Garth Snyder on Tuesday May 12
Sender: linux-raid-owner@vger.kernel.org
To: garth@grsweb.us
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 12, garth@grsweb.us wrote:
> On Sunday May 10, I (garth@grsweb.us) wrote:
> 
> > I'm having a problem getting a spare partition moved to the right RAID
> group
> > after a failure...All superblocks involved are version 1.2.
> 
> Neil Brown replied:
> 
> > This would be because no one has tried the spare-group feature with
> > 1.x metadata yet...The following patch should make it work...This patch
> > is against 2.6.9, though it should apply to any reasonably recent 2.x
> mdadm.
> 
> Thanks for the response, Neil. The patch works great; now I get Fail,
> MoveSpare, and Rebuild events in sequence with no errors. /proc/mdstat shows
> that the appropriate spare was moved into the failed array and that the
> array is being rebuilt onto it.

Excellent.  Thanks for testing and reporting.

> 
> I patched the 2.6.7.1 tree, which was Jaunty's default for "apt-get source
> mdadm" (and the same version included in the binary package). Manage.c and
> Monitor.c already matched the "after" state of your patch, so the only code
> that actually changed was the one-liners in super0.c and super1.c.

That is impossible.  I had only just written that patch, so there is
no way the 'after' bit could possibly be in Jaunty.  Maybe something
got confused when you ran patch.... doesn't really matter - it works,
and that is the important thing.

NeilBrown
