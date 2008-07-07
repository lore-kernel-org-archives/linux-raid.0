From: Neil Brown <neilb@suse.de>
Subject: Re: [Fwd: Re: mdadm: spare rebuilding]
Date: Mon, 7 Jul 2008 12:50:45 +1000
Message-ID: <18545.33925.939297.985909@notabene.brown>
References: <486A7974.4070204@blueyonder.co.uk>
	<55776.192.168.1.70.1214992071.squirrel@neil.brown.name>
	<486C7B62.1@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Buckingham on Thursday July 3
Sender: linux-raid-owner@vger.kernel.org
To: jbuckingham@blueyonder.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 3, jbuckingham@blueyonder.co.uk wrote:
> Hi Neil
> 
> So, a little while ago I did upgrade the kernel
> (2.6.22.18-0.2-default), but it did not seem to make any difference to the

I was thinking more like 2.6.25.
My guess is that the fix was
   commit 25156198235325805cd7295ed694509fd6e3a29e
which is in 25-rc4.

> 'echo sync > /sys/block/md3/md/sync_action'.
> 
> After receiving your latest email, I did the following...
> 
> echo sync > /sys/block/md3/md/sync_action
> (device busy reported to konsole as before)
> echo idle > /sys/block/md3/md/sync_action
> echo sync > /sys/block/md3/md/sync_action
> (device busy reported to konsole as before)
> 
> Then checked "top" - and saw significant activity from
> md3_sync and md3_raid5 processes.

I think the resync thread was sort of "half-started".   Writing 'idle'
killed it off, then it was automatically restarted and proceeded
properly.

Thanks for reporting your success.

NeilBrown
