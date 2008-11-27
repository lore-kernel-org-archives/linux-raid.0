From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Thu, 27 Nov 2008 12:47:48 +0100
Message-ID: <20081127114748.GE14570@boogie.lpds.sztaki.hu>
References: <20081126190452.775333692@sun.com> <20081126190854.813151413@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081126190854.813151413@sun.com>
Sender: linux-raid-owner@vger.kernel.org
To: scjody@sun.com
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Nov 26, 2008 at 02:04:53PM -0500, scjody@sun.com wrote:

> I realize that the format of the statistics may not be the best, and
> there may be a better location than /proc/mdstat, so I welcome suggestions
> on where to put them.

Are these values useful for mere mortals trying to create a RAID array
best suited for a specific workload, or are these only useful for people
hacking on the RAID code? If the former, then I'd suggest to use sysfs
(something like /sys/block/<dev>/md/statistics, similar to
/sys/class/net/<dev>/statistics). If the latter, then debugfs would be
better.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
