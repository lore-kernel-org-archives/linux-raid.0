From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: help wanted - 6-disk raid5 borked: _ _ U U U U
Date: Thu, 20 Apr 2006 16:35:45 +0200
Message-ID: <20060420143545.GB27744@boogie.lpds.sztaki.hu>
References: <62b0912f0604161419udee8ff2tf0861bc2f6e8e304@mail.gmail.com> <17474.51121.178492.61143@cse.unsw.edu.au> <62b0912f0604161617k31eedfaev8778b299e4a65b4b@mail.gmail.com> <17474.54168.331725.412456@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17474.54168.331725.412456@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Molle Bestefich <molle.bestefich@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 17, 2006 at 09:30:32AM +1000, Neil Brown wrote:

> It is arguable that for a read error on a degraded raid5, that may not
> be the best thing to do, but I'm not completely convinced.

My opinion would be that in the degraded case md should behave as if it
was a single physical drive, and just pass the error to the upper layers.
Then the filesystem can decide what to do (for example, ext3 can be told
to just continue, remount read-only, or simply panic).

> A read error will mean that a write to the same stripe will have to
> fail, so at the very least we would want to switch the array
> read-only.

Not neccessarily. Just fail the write with -EIO and let the file system
decide. Or at least make the error-handling behaviour run-time configurable.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
