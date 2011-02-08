From: NeilBrown <neilb@suse.de>
Subject: Re: Periodic RebuildStarted event
Date: Tue, 8 Feb 2011 11:25:13 +1100
Message-ID: <20110208112513.2b82111c@notabene.brown>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
	<AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
	<20110207234411.GA93362@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110207234411.GA93362@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Feb 2011 18:44:11 -0500 Martin Cracauer <cracauer@cons.org> wrote:

> I just got through the RebuildStarted event which seems to be
> monthly.  This is being triggered by my Debian config, but before I
> nuke it I'd like to know a little more.
> 
> If a real disk error happens during this rebuild on a raid5, would the
> disk go into regular degraded mode or would it count as a double
> fault?

The monthly thing is a 'check', not a 'rebuild'  (yes, the 'monitor' email is
a little misleading).
So a real disk error will be handled correctly.  In fact the main point of a
monthly check is to find and correct these latent read errors.


> 
> I also noticed that recently all the checks for all the arrays happen
> simultaneously.  That's bad because most of them share the same
> physical disks.  Am I imagining this or was the system smart enough to
> do them one after another until recently?

Arrays that share a partition certainly should not be
synced/recovered/checked at the same time (unless you set
sync_force_parallel in sysfs).

If you have evidence that they do I would like to see that evidence.

> 
> Do you do period checks? I get lots of device mismatches reported but
> apparently that's normal if there's write activity.  The whole thing
> sound contra-productive to me and might panic new users.

Periodic checks are a good thing.
Yes, it can cause confusion.  That is not good, but a better approach has not
yet been found.  Patches welcome.

What would be really good is to just do an hour of check every night.  It is
quite possible to get the kernel to do this, but it requires some non-trivial
scripting that no-one has written yet.  You need to record where you are up
to on which array, and when you last did each array.  Then start either the
'next' array at the beginning, or the 'current' array at the current point
(write to sync_min).
Then wait for however long you want, abort the check (write 'idle' to
'sync_action') and find out where it got up to (read sync_min) and record
that for next time.

Great project for someone.....

NeilBrown



> 
> Martin

