From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Thu, 27 Nov 2008 18:15:35 +0100
Message-ID: <20081127171535.GL14570@boogie.lpds.sztaki.hu>
References: <20081126190452.775333692@sun.com> <20081126190854.813151413@sun.com> <20081127114748.GE14570@boogie.lpds.sztaki.hu> <20081127135248.GD29919@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081127135248.GD29919@clouds>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, Nov 27, 2008 at 08:52:48AM -0500, Jody McIntyre wrote:

> I was thinking about your first suggestion but note that there is also
> /proc/diskstats as well as /sys/block/<dev>/stat.  The advantage of
> having everything in one file is that you only have to open one file
> when gathering statistics on many arrays, and /proc/mdstat already
> exists as a precedent.  I could add individual array statistics files as
> well if useful.

/proc contains a lot of legacy junk but nowadays the trend is that you
should not add new files under /proc that are not process-related.
Changing /proc/mdstat is IMHO out of question since it is part of the
user visible ABI and breaking that is a big no-no. So if you want all
info in a single file that pretty much leaves only debugfs.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
