From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 002 of 2] Make md threads interruptible again.
Date: Fri, 18 Nov 2005 11:24:23 +1100
Message-ID: <17277.7991.33335.100135@cse.unsw.edu.au>
References: <20051115125442.9317.patches@notabene>
	<1051115015641.9393@suse.de>
	<20051114180805.01dbf4b9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Monday November 14
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 14, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >
> > 
> > Despite the fact that md threads don't need to be signalled, and won't
> > respond to signals anyway, we need to have an 'interruptible' wait,
> > else they stay in 'D' state and add to the load average.
> > 
> > ...
> > +		if (signal_pending(current))
> > +			flush_signals(current);
> 
> Kernel threads don't accept signals by default, so the above is
> unneeded.

Not by default, but md_thread calls
	allow_signal(SIGKILL);

because md_check_recovery (called by some, but not all, md_threads)
does
	if (signal_pending(current)) {
		if (mddev->pers->sync_request) {
			printk(KERN_INFO "md: %s in immediate safe mode\n",
			       mdname(mddev));
			mddev->safemode = 2;
		}
		flush_signals(current);
	}

i.e. We allow that if SIGKILL is sent to an md array controller thread
(as opposed to a resync thread), the array will be switched to
'immediate safe mode'.  In this mode the superblock is marked clean as
soon as there are no outstanding writes, rather than 20msecs later.
This if you 'alt-sysrq-K' then you can be fairly sure that the array
is marked clean NOW.

One of the reasons I did this was that I didn't like the whole idea of
md_notify_reboot which is hooked into the reboot notifiers chain and
switches all arrays to read-only, thus marking the superblock clean.
Having effectively the same thing happen on a SIGKILL to all processes
seemed a reasonable replacement.  However I haven't actually removed
md_notify_reboot yet....

NeilBrown

> 
> I'll leave it in there now, since that's how things used to be, but please
> make a note to nuke that check, then test it to make sure I'm telling the
> truth, then fix it up later on?
