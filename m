From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt again
Date: Tue, 17 Nov 2009 09:14:55 +1100
Message-ID: <20091117091455.33c8757c@notabene.brown>
References: <neilb@suse.de>
	<200911162136.nAGLatPb028438@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911162136.nAGLatPb028438@wind.enjellic.com>
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 16 Nov 2009 15:36:55 -0600
greg@enjellic.com wrote:

> If a scrub directive were to be implemented it would be beneficial to
> make it interruptible.  A 'halt' or similar directive would shutdown
> the scrub and latch the last block number which had been examined.
> That would allow a scrub to be resumed from that point in a subsequent
> session.
> 
> With some of these large block devices it is difficult to get through
> an entire 'check/scrub' in whatever late night window is left after
> backups have run.  The above infra-structure would allow userspace to
> gate the checking into whatever windows are available for these types
> of activities.

This is already possible with check.

If you write 'idle' to 'sync_action', the check will stop.
If you first read from 'sync_completed' and store that value,
then before starting a new 'check', write the value to
sync_max, then you get exactly what you are asking for, all
easily done in a shell script.
You can also set 'sync_max' if you like, thus you could e.g.
quite easily have a cron job that scrubs 1/28th of the array each
night based on the day of the month.

NeilBrown
