From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Swap on RAID1?
Date: Mon, 13 Oct 2003 19:25:55 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8B3483.728E75E3@SteelEye.com>
References: <200310140012.33121.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hermann Himmelbauer wrote:

> But what happens if a disk fails and the swap is on this disk? I assume Linux
> would crash? Wouldn't a swap on a RAID prevent such a crash?

Yes and yes. One other possible alternative would be to fork out the
money for more RAM rather than a second disk for swap. And just don't
use swap, if you're worried about swap crashing the system...and
performance will be much better, too.

--
Paul
