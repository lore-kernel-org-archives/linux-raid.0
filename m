From: Neil Brown <neilb@suse.de>
Subject: Re: 3-way mirrors
Date: Wed, 8 Sep 2010 11:33:23 +1000
Message-ID: <20100908113323.1b25b2c9@notabene>
References: <20100907141904.3696.qmail@science.horizon.com>
	<20100908080155.2ed9300e@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908080155.2ed9300e@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 8 Sep 2010 08:01:55 +1000 Neil Brown <neilb@suse.de> wrote:
> On 7 Sep 2010 10:19:04 -0400 "George Spelvin" <linux@horizon.com> wrote:
> > 
> > I'm worried that someone not paying attention will --add rather than
> > --re-add the off-site backup drives and create mirrors 4 and 5 of
> > the first stripe half, thus producing an incomplete backup.
> 
> It is already on my to-do list for mdadm-3.2 to reject a --add that looks
> like it should be a --re-add.  You will need --force to make it a spare, or
> --zero it first.
> 

I just realised I had this slightly wrong.

mdadm will already perform a --re-add if asked to --add a device that can be
re-added.  So you should be safe from people accidentally using --add when
they should have used --re-add.

The change on my to-do list is that if it looks like a re-add might be
possible but the re-add fails, then don't do a normal --add without extra
encouragement.

The case where this is interesting is if you have a doubly-degraded RAID5 and
the devices just had a temporary failure.  
It would seem logical to just add the disks back.  The --re-add attempt will
fail of course, so mdadm will currently make the devices spares which isn't
what is wanted.  Rather mdadm should fail and suggest a 'stop' followed by
'--assemble --force'.

For raid1 my planned change won't make any difference - you should be safe as
you are.

NeilBrown


> 
> > 
> > Any suggestions on how to mitigate this risk?  And if it happens,
> > how do I recover?  Is there a way to force a drive to be added
> > as 9/10, even if 5/10 is currently empty?
> 
> 1/ hack at mdadm or wait for mdadm-3.2, or feed people more coffee:-)
> 2/ You probably cannot recover with any amount of certainty.
> 3/ That is entirely a kernel decision - 'fix' the kernel.
> 
> NeilBrown
> 
> 
> > 
> > 
> > Thank you very much!
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

