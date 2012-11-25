From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 11:13:06 +0100
Message-ID: <20121125101306.GA2373@lazy.lzy>
References: <50B1BCBD.70306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50B1BCBD.70306@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Nov 24, 2012 at 10:37:49PM -0800, H. Peter Anvin wrote:
> I was looking at the hot-replace (want_replacement) feature, and I
> had a thought: it would be nice to have this in a form which
> *didn't* fail the incumbent drive after the operation is over, and
> instead turned it into a spare.  This would make it much easier and
> safer to periodically rotate and test any hot spares in the system.
> The main problem with hot spares is that you don't actually know if
> they work properly until there is a failover...
> 

I go for this one.

Actually, this was also my original thinking for
the "proactive replacement".

The only thing that, in addition, should be done,
is to keep the spare in sleep mode until needed
(either for hot replacement or for real replacement).

bye,

-- 

piergiorgio
