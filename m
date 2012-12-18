From: pg@xf2.to.sabi.co.UK (Peter Grandi)
Subject: Re: super slow reshape speed after power failure
Date: Tue, 18 Dec 2012 22:44:06 +0000
Message-ID: <20688.61878.727600.786424@tree.ty.sabi.co.UK>
References: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Currently I am converting my 6x 2tb raid5 from 256 chunk down
> to 4k.

Such an (euphemism) audacious plan!

> While the reshape was running it was running around 4mb/s,
> which is slow to begin with.

Thanks for confirming how fast this is.

> Yesterday we lost power and afte the system came back up, I
> was able to bring the raid back up and running via 'export
> MDADM_GROW_ALLOW_OLD=1`.

This is a really (euphemism) strategic action!

> The current issue is that the reshape is running with only
> 700kb/s.

Thanks for confirming how fast this is.

> Any ideas?

Some, but perhaps you would not like them :-).


BTW I wonder whether the design was as (euphemism) stunning as
using 5400/5900RPM drives with 4KiB hardware sectors (such as
many current 2TB drives) without alignment, because it would be
a suitably (euphemism) extreme achievement in line with those
above.
