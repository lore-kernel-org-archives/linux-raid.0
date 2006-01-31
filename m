From: Neil Brown <neilb@suse.de>
Subject: Re: Exporting which partitions to md-configure
Date: Tue, 31 Jan 2006 13:01:03 +1100
Message-ID: <17374.50399.1898.458649@cse.unsw.edu.au>
References: <43DEB4B8.5040607@zytor.com>
	<17374.47368.715991.422607@cse.unsw.edu.au>
	<43DEC095.2090507@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Monday January 30
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 30, hpa@zytor.com wrote:
> Neil Brown wrote:
> > On Monday January 30, hpa@zytor.com wrote:
> > 
> >>Any feeling how best to do that?  My current thinking is to export a 
> >>"flags" entry in addition to the current ones, presumably based on 
> >>"struct parsed_partitions->parts[].flags" (fs/partitions/check.h), which 
> >>seems to be what causes md_autodetect_dev() to be called.
> > 
> > I think I would prefer a 'type' attribute in each partition that
> > records the 'type' from the partition table.  This might be more
> > generally useful than just for md.
> > Then your userspace code would have to look for '253' and use just
> > those partitions.
> > 
> 
> What about non-DOS partitions?

Well, grepping through fs/partitions/*.c, the 'flags' thing is set by
 efi.c, msdos.c sgi.c sun.c

Of these, efi compares something against PARTITION_LINUX_RAID_GUID,
and msdos.c, sgi.c and sun. compare something against
LINUX_RAID_PARTITION.

The former would look like
  e6d6d379-f507-44c2-a23c-238f2a3df928
in sysfs (I think);
The latter would look like
  fd
(I suspect).

These are both easily recognisable with no real room for confusion.

And if other partition styles wanted to add support for raid auto
detect, tell them "no". It is perfectly possible and even preferable
to live without autodetect.   We should support legacy usage (those
above) but should discourage any new usage.

NeilBrown

