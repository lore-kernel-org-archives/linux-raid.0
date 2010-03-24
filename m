From: Neil Brown <neilb@suse.de>
Subject: Re: Raid Containers
Date: Thu, 25 Mar 2010 09:22:51 +1100
Message-ID: <20100325092251.3a599a6e@notabene.brown>
References: <1269466029.5759.668.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1269466029.5759.668.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 25 Mar 2010 10:27:09 +1300
Daniel Reurich <daniel@centurion.net.nz> wrote:

> Hi.
> 
> I'm wanting to know are containers properly supported now in mdadm and
> recent kernels (I assume using only 1.X metadata)?

I think we have some confusion over terminology here.

In the mdadm documentation I use the word "container" to mean a collection of
devices which all share a set of metadata which describes one or more arrays.

Thus a single 0.90 of 1.x array is in a sense a 'container' but is not
normally referred to as one.  More significantly a set of devices using
Intel's IMSM metadata or the "industry standard" DDF metadata form a
container.  In each case the member arrays cannot be treated as completely
independent as there is a single piece of metadata which describes them all.

Thus for example you could have 2 drives: the first 500GB of each form a
RAID0 set, the following 499.9GB form a RAID1 pair, and at the end there is
some metadata which describes both arrays.
When mdadm assembles this it creates a 'container' array which covers just
the metadata and serves as a handle to refer to the who set.  There are also
two 'real' arrays  (raid0 and raid1) which manage the data.

This native metadata (0.90 or 1.x) each set of metadata describes exactly one
array, so the extra level of 'containers' is not needed.  A similar situation
to the above could be formed by partitioning both drives in to 2 500GB
partitions and creating a RAID0 over  the first 2 and an independent RAID1
over the last two.

If you want to have a number of e.g. RAID1 arrays on the same pair of devices
you can do this in two ways using native metadata:
1/ partition the arrays and create a separate RAID1 over each pair of
 partitions.
2/ create a single RAID1 over the two whole devices and then partition that
 raid1 and create different filesystems (or swap space) in the different
 partitions.

For a management point of view, 2 is easier as you can remove just one
device, then add just one device when replacing a faulty device.

However many GUI partitions do not understand that approach, and boot loaders
can also have problems with it - you really need solid support from the
distro.

I'm guessing that when you say "container" above you are really talking about
option 2 here.  This is better referred to as "partitioned RAID".

> 
> I'm wondering if containers might make a better approach than
> partitioning and creating separate raid volumes.  My thoughts are that
> maybe using containers potentially simplify the management of drives, to
> simply adding new or replacement drives to the raid container and having
> them added into degraded arrays automatically or as spares (for live
> migration when it gets implemented).

If I understand your use of the word correctly, then yes it would simplify
management.  However if you want to boot from the array you might run in to
problems there.

> 
> Is there any more documentation around on the usage of containers in md?

Probably not...

NeilBrown
