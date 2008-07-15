From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 21:40:28 +0100
Message-ID: <18557.2876.90167.508621@tree.ty.sabi.co.uk>
References: <1216130769.5633.318.camel@sam.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216130769.5633.318.camel@sam.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> [ ... ] compares the Linux Kernel RAID code to an $800
> hardware RAID card and might be of interest to list members:
> http://www.linux.com/feature/140734

Perhaps they could, if they were accompanied by vital details
like the exact experimental conditions used, because those who
talk of Bonnie++ and Iozone etc. as if they were mostly useful
benchmarks tend, in my experience, to forget about the several
pitfalls one can get into. I have seen several speed tests in
this mailing lists from the usual suspects, and most range from
the grossly meaningless to the rather misleading.

The comparison above is somewhat pointless to read without
knowing which elevator, readhead, plugging/unplugging, kernel
version (even if some ot these are somewhat implicit in Fedora
9, e.g. CFQ) and so on; also whether caching was enabled or not
between runs (even if the use, if properly done, of 100G
datasets with 2G memory might reduce the influence of that,
except of course for the CPU cost).

  The "using equal-sized partitions" bit is also worrying: it is
  not clear whether the sw RAID is built on the partitions or
  viceversa. This has a huge influence on alignment, and I am
  not sure that "chunk and stride aligned to the RAID where
  possible" can be relied upon without seeing exactly how the
  filesystems were created.

  Also, the graphs seem mislabeled, as all results are reported
  as coming from Bonnie++, including the metadata ones which are
  more likely to be coming from Iozone. Also for comparison they
  should have been drawn to the same Y scale.

There are so many nonlinearities in the Linux IO subsystem where
one can get wildly different results with small changes in
obscure parameters (or large changes in parameters that should
matter little, like the block device readahead) that overall
tests like the above are not that useful without a list of the
exact conditions.

Overall however most of the results are within the boundaries of
very rough plausibility, but the devil is in the details.

The overall conclusions that alignment matters a great deal with
parity RAID and that a system with a recent CPU and a PCIe bus
can outperform in most cases a hardware RAID card are not that
novel...
