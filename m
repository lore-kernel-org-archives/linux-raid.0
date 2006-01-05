From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 08:13:59 -0500
Message-ID: <20060105131359.GA17042@ti64.telemetry-investments.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com> <fd8d0180601050106s5f5b4306o@mail.gmail.com> <87oe2r2d93.fsf@rimspace.net> <43BD026C.4050705@panix.com> <fd8d0180601050335ob7b791cm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fd8d0180601050335ob7b791cm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 05, 2006 at 12:35:12PM +0100, Francois Barre wrote:
> By the way, not really a raid-oriented question, but what is the exact
> robustness of ext3 resizing ? I mean : what happens if the box crashes
> while resizing an ext3 ?

Ext3 online resizing is undergoing some changes, so this question will
need to be applied to a particular version.

In any case, during online expansion, most of the time is spent preparing
the new block groups, which the filesystem at that point knows nothing
about.  Once everything is prepared, telling the filesystem about the new
block groups involves a small number of very quick operations.  I don't
know whether the ordering guarantees 100% safe (although I have great
trust in Andreas Dilger :-)), but even if not, the window of vulnerability
is very small.   And if the box crashes, e2fsck ought to recover easily.

Regards,

	Bill Rugolsky
