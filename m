From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: intent-logging, not synchronizing written blocks?
Date: Wed, 9 Nov 2005 22:19:05 -0200
Message-ID: <17266.37369.974982.901592@fisica.ufpr.br>
References: <17266.30693.504831.133082@fisica.ufpr.br>
	<17266.32043.52698.717602@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17266.32043.52698.717602@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) wrote on 10 November 2005 09:50:
 >> Is intent-logging for raid5 already in mainline or only in -mm? I
 >> looked for it in 2.6.14 and found nothing...
 >
 >raid5 is in 2.6.14.  raid6 and raid10 should be in 2.6.16.
 >What did you look for?

Some doc, or compilation option. I suppose it's always on then and
just using --re-add with mdadm is enough.

 >I'm not sure what you mean by 'went out of sync'.

I wasn't clear, I meant a device failed.

 >When an array is active and being written to, many stripes could be
 >out-of-sync at any time, as writes have been started, but haven't
 >completed yet. Intent logging record the intent to write somewhere
 >before doing the write, and then clears the intent sometime after
 >the write completes.
 >
 >After a crash, some intents will still be recorded, and only the
 >stripes associated with these risk being out-of-sync, so only those
 >need to be resynced.

What about the writes that were started and completed after the
failure?

 >> I thought that another way to speed
 >> re-sync would be to not sync the blocks that were written to the array
 >> after it started, since they should be already up to date. Is there a
 >> way to do this? Does intent-logging takes this into account?
 >
 >intent-logging does not try to take this into account.  The chuck-size
 >for intent logging is usually quite large.  A single write it
 >unlikely to completely update an intent-chuck, so would need to keep
 >track of lots of recent writes to see if any collection of them
 >completely cover any intent-chuck.  The effort isn't worth it for the
 >saving.

It'd be useful for starting an array and filling part of it with data
because the sync wouldn't have to be done for the written part. When
you deal with 500+GB arrays used more than 50% it'd be significantly
faster. I understand that it's quite a specific situation though.
