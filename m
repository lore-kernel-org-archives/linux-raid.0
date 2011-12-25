From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by
 smart
Date: Sat, 24 Dec 2011 19:24:37 -0500
Message-ID: <4EF66D45.3020802@turmel.org>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com> <878vm32dan.fsf@poker.hands.com> <4EF5001F.8050409@gmail.com> <8762h62sgb.fsf@poker.hands.com> <4EF5E161.5010001@turmel.org> <4EF5F5C0.6050908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EF5F5C0.6050908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Philip Hands <phil@hands.com>, 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/24/2011 10:54 AM, Roger Heflin wrote:
> On my Seagates I turned down the SCTERC to really low (ie .2 seconds)
> and from what I could see it did not make an obvious difference in
> the length of the time that the system paused, the pauses appeared to
> stay at about 30 seconds...which I guess implies that the actual read
> failed timeout was being hit rather than the disk returning an error
> in a reasonable time...from the log each time it was forcing a
> re-write it appeared to be 8 sections of 8 sector each so 32k of
> data, 64 sectors.    I seem to remember there is a way to turn down
> the disk op timeout...but at least on my system turning it down lower
> would mean that the disks might not have enough time to spinup out of
> a sleep...

On the drives I've checked closely, any SCTERC setting below 6.5 seconds
is discarded and treated as zero (no limit).  Setting timeouts in the
driver stack below the timeout in the drive is counterproductive, as
drives won't abandon the error recovery attempt to reply to the controller's
next command.  So the drive gets kicked out of the array as completely
failed (unresponsive) instead of dealing with the localized read error.

If I recall my Seagate spec right, the 6.5 second timeout wouldn't count
the spin-up time.  I haven't tested that, as my application doesn't sleep.

Phil
