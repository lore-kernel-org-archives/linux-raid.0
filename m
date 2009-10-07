From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Wed, 7 Oct 2009 12:05:10 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0910071141010.29237@diagnostix.dwd.de>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
 <19141.32211.742547.19481@notabene.brown> <1254875779.16798.10.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1254875779.16798.10.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 6 Oct 2009, Dan Williams wrote:

>> From 0496c92cf6ac1f4f7dde6d416707988991d87d41 Mon Sep 17 00:00:00 2001
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Sat, 3 Oct 2009 13:47:05 -0700
> Subject: [PATCH] md/raid456: downlevel multicore operations to raid_run_ops
>
> The percpu conversion allowed a straightforward handoff of stripe
> processing to the async subsytem that initially showed some modest gains
> (+4%).  However, this model is too simplistic and leads to stripes
> bouncing between raid5d and the async thread pool for every invocation
> of handle_stripe().  As reported by Holger this can fall into a
> pathological situation severely impacting throughput (6x performance
> loss).
>
> By downleveling the parallelism to raid_run_ops the pathological
> stripe_head bouncing is eliminated.  This version still exhibits an
> average 11% throughput loss for:
>
> 	mdadm --create /dev/md0 /dev/sd[b-q] -n 16 -l 6
> 	echo 1024 > /sys/block/md0/md/stripe_cache_size
> 	dd if=/dev/zero of=/dev/md0 bs=1024k count=2048
>
> ...but the results are at least stable and can be used as a base for
> further multicore experimentation.
>
> Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> On Thu, 2009-10-01 at 21:13 -0700, Neil Brown wrote:
>> On Thursday October 1, dan.j.williams@intel.com wrote:
>>> Hi Neil,
>>>
>>> A few fixes:
>>> 1/ The multicore option is not ready for prime time
>>
>> But it is already marked experimental...
>> So do we really need to revert?  or is the current code broken beyond
>> repair?
>
> So we don't need a revert, this fixes up the unpredictability of the
> original implementation.  It surprised me that the overhead of passing
> raid_run_ops to the async thread pool amounted to an 11% performance
> regression.  In any event I think this is a better baseline for future
> multicore experimentation than the current implementation.
>
Just to add some more information, I did try this patch with
2.6.32-rc3-git1 and with the testing I am doing I get appr. 125%
performance regression. The tests I am doing is have several (appr. 60
process) sending via FTP or SFTP about 100000 small files (average size
below 4096 bytes) to localhost in a loop for 30 minutes. Here the
real numbers:

  with multicore support enabled (with your patch)    3276.77 files per second
  with multicore support enabled (without your patch) 1014.47 files per second
  without multicore support                           7549.24 files per second

Holger
