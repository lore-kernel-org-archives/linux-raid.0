From: Derek Piper <derek.piper@gmail.com>
Subject: Re: Spares and partitioning huge disks
Date: Fri, 14 Jan 2005 14:14:47 -0500
Message-ID: <eaa6dfe050114111411321d24@mail.gmail.com>
References: <crmt7e$8d6$1@sea.gmane.org> <20050110081526.GA15920@janus>
	 <41E80188.60601@conterra.de> <200501141846.54441.maarten@ultratux.net>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501141846.54441.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ah, that does sound much better I agree ... having just been bitten by
the 'oh dear, I got one bit was out of place, bye bye disk' problem
myself.

Even if it only 'failed' a 'chunk', it would be an improvement. I'll
take 64K over 60GB any day. The read for the chunk could then be
calculated using parity and a notification sent upwards saying
something to this effect: 'uh, hey, I'm having to regenerate data from
disk N at area X on-the-fly (i.e. I'm 'degraded') but all disks are
still with us and the other data is not in harms way, you might want
to think about backups and possibly a new disk'. If the chunk/sector
(choose how much you want to fail) can then be read again, clear the
'alert'. Of course if you get two identical chunks that miss-read,
you're screwed. Probably less screwed than if it were whole disk
though.

Derek

On Fri, 14 Jan 2005 18:46:54 +0100, maarten <maarten@ultratux.net> wrote:
> 
> Mod parent "+5 Insightful".
> 
> Very well though out and said, Dieter.
> 
> Maarten
> 
> On Friday 14 January 2005 18:29, Dieter Stueken wrote:
> > Frank van Maarseveen wrote:
> 
> > > I did not intend to cut it out but simplified the situation a bit: if
> > > you have all the RAID5 disks even with a bunch of errors spread out over
> > > all of them then yes, you basically still have the data.  Nothing is
> > > lost provided there's no double fault and disks are not dead yet. But
> > > there are not many technical people I would trust for recovering from
> > > this situation. And I wouldn't trust myself without a significant
> > > coffee intake either :)
> >
> > I think read errors are to be handled very differently compared to disk
> > failures. In particular the affected disk should not be kicked out
> > incautious. If done so, you waste the real power of the RAID5 system
> > immediately! As long, as any other part of the disk can still be read,
> > this data must be preserved by all means. As long as only parts of a disk
> > (even of different disks) can't be read, it is not a fatal problem, as long
> > as the data can still be read from an other disk of the array. There is no
> > reason to kill any disk in advance.
> >
> > What I'm missing is some improved concept of replacing a disk:
> > Kicking off some disk at first and starting to resync to a spare
> > disk thereafter is a very dangerous approach. Instead some "presync"
> > should be possible: After a decision to replace some disk, the new
> > (spare) disk should be prepared in advance, while all other disks are still
> > running. After the spare disk was successfully prepared, the disk to
> > replace may be disabled.
> >
> > This sounds a bit like RAID6, but it is much simpler. The complicated part
> > may be the phase where I have one additional disk. A simple solution would
> > be to perform a resync offline, while no write takes place. This may even
> > be performed by a userland utility. If I want to perform the "presync"
> > online, I have to carry out writes to both disks simultaneously, while the
> > presync takes place.
> >
> > Dieter.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Derek Piper - derek.piper@gmail.com
http://doofer.org/
