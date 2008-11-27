From: Jody McIntyre <scjody@sun.com>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Thu, 27 Nov 2008 08:45:03 -0500
Message-ID: <20081127134503.GC29919@clouds>
References: <20081126190452.775333692@sun.com>
 <20081126190854.813151413@sun.com>
 <e9c3a7c20811261350n57fb3881if443969b27079543@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <e9c3a7c20811261350n57fb3881if443969b27079543@mail.gmail.com>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Dan,

On Wed, Nov 26, 2008 at 02:50:18PM -0700, Dan Williams wrote:

> I have done some work in this area too 

Got any preliminary patches you can share?

> and have a lingering desire to hook MD up to the tracing
> infrastructure du jour.  Have you considered using tracepoints [1]?
> This would save the overhead of atomic operations when we're not
> profiling.

Thanks for the suggestion, I'll look into that.

Cheers,
Jody

> 
> Regards,
> Dan
> 
> [1]: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/tracepoints.txt;h=5d354e16749447c667934ecd4c8f4fe5ee3da36c;hb=HEAD
