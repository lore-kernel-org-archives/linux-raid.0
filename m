From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Wed, 26 Nov 2008 14:50:18 -0700
Message-ID: <e9c3a7c20811261350n57fb3881if443969b27079543@mail.gmail.com>
References: <20081126190452.775333692@sun.com>
	 <20081126190854.813151413@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081126190854.813151413@sun.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: scjody@sun.com
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Nov 26, 2008 at 12:04 PM,  <scjody@sun.com> wrote:
> This patch tracks various statistics related to the performance of a RAID 5
> or 6 array.  These have been useful to us in the past to help solve
> performance issues.  They are reported via /proc/mdstat.
>
> I realize that the format of the statistics may not be the best, and
> there may be a better location than /proc/mdstat, so I welcome suggestions
> on where to put them.
>
> I will add documentation once we've decided on the format and location (or
> if nobody objects to the current format and location.)
>

Hi Jody,

I have done some work in this area too and have a lingering desire to
hook MD up to the tracing infrastructure du jour.  Have you considered
using tracepoints [1]? This would save the overhead of atomic
operations when we're not profiling.

Regards,
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/tracepoints.txt;h=5d354e16749447c667934ecd4c8f4fe5ee3da36c;hb=HEAD
