From: Neil Brown <neilb@suse.de>
Subject: Re: intent-logging, not synchronizing written blocks?
Date: Thu, 10 Nov 2005 09:50:19 +1100
Message-ID: <17266.32043.52698.717602@cse.unsw.edu.au>
References: <17266.30693.504831.133082@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Wednesday November 9
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 9, carlos@fisica.ufpr.br wrote:
> Hi,
> 
> Is intent-logging for raid5 already in mainline or only in -mm? I
> looked for it in 2.6.14 and found nothing...

raid5 is in 2.6.14.  raid6 and raid10 should be in 2.6.16.
What did you look for?

> 
> It seems that intent-logging accelerates synchronization by skipping
> the blocks that have not changed since the array went out of sync.

I'm not sure what you mean by 'went out of sync'.  When an array is
active and being written to, many stripes could be out-of-sync at any
time, as writes have been started, but haven't completed yet.
Intent logging record the intent to write somewhere before doing the
write, and then clears the intent sometime after the write completes.

After a crash, some intents will still be recorded, and only the
stripes associated with these risk being out-of-sync, so only those
need to be resynced.

If you take a device out of an array, and then re-add it "--re-add",
then recovery will only recover those blocks that have changed since
the device was removed.


>  I'm
> not sure but if this is correct I thought that another way to speed
> re-sync would be to not sync the blocks that were written to the array
> after it started, since they should be already up to date. Is there a
> way to do this? Does intent-logging takes this into account?

intent-logging does not try to take this into account.  The chuck-size
for intent logging is usually quite large.  A single write it
unlikely to completely update an intent-chuck, so would need to keep
track of lots of recent writes to see if any collection of them
completely cover any intent-chuck.  The effort isn't worth it for the
saving.

NeilBrown

