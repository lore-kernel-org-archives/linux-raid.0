From: Billy Crook <billycrook@gmail.com>
Subject: Re: Two degraded mirror segments recombined out of sync for massive
	data loss
Date: Thu, 8 Apr 2010 09:58:10 -0500
Message-ID: <z2za43edf1b1004080758mbf88eeecg64b174d740573be9@mail.gmail.com>
References: <4BBCEEEC.4030606@cfl.rr.com> <r2v4877c76c1004071421o14e66ae5s35b0bf0914fb737c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <r2v4877c76c1004071421o14e66ae5s35b0bf0914fb737c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 7, 2010 at 16:21, Michael Evans <mjevans1983@gmail.com> wrote:
> It sounds like the last 'synced' time should be tracked, as well as
> the last modification time. If the two differ then it can be known
> that the contents has diverged since last sync.

I have perhaps a better solution:
Every time an event happens that could affect the coherency of the
components of an array (i.e. started, stopped, disk failed), a counter
is incremented on all of the components.  Then a random number is
written next to it (same number to all disks).

On assembling an array:
For all components in the array, find the highest counter.

If enough disks with this counter are present and contain the same
random number, the it starts the array, and if a rebuild is necessary
to regain parity or the specified number of mirrors, the remaining
components of the same array are consumed for this purpose.

If there are multiple randoms present for this highest counter, then
the last modification time can be used to choose the most up to date
one.  It comes online, and overwrites the components with the older
modification time, or maybe it just prompts the admin, and starts
degraded.

This would catch the problem originally reported by Phillip because
the random numbers written to the components' headers would have been
written at different times, and so they would be different.  mdadm
would know by this that they had diverged regardless of any timestamp
or counter.
