From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 18:05:16 -0800
Message-ID: <43DEC5DC.1030709@zytor.com>
References: <43DEB4B8.5040607@zytor.com>	<17374.47368.715991.422607@cse.unsw.edu.au>	<43DEC095.2090507@zytor.com> <17374.50399.1898.458649@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17374.50399.1898.458649@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> Well, grepping through fs/partitions/*.c, the 'flags' thing is set by
>  efi.c, msdos.c sgi.c sun.c
> 
> Of these, efi compares something against PARTITION_LINUX_RAID_GUID,
> and msdos.c, sgi.c and sun. compare something against
> LINUX_RAID_PARTITION.
> 
> The former would look like
>   e6d6d379-f507-44c2-a23c-238f2a3df928
> in sysfs (I think);
> The latter would look like
>   fd
> (I suspect).
> 
> These are both easily recognisable with no real room for confusion.

Well, if we're going to have a generic facility it should make sense 
across the board.  If all we're doing is supporting legacy usage we 
might as well export a flag.

I guess we could have a single entry with a string of the form 
"efi:e6d6d379-f507-44c2-a23c-238f2a3df928" or "msdos:fd" etc -- it 
really doesn't make any difference to me, but it seems cleaner to have 
two pieces of data in two different sysfs entries.

> 
> And if other partition styles wanted to add support for raid auto
> detect, tell them "no". It is perfectly possible and even preferable
> to live without autodetect.   We should support legacy usage (those
> above) but should discourage any new usage.
> 

Why is that, keeping in mind this will all be done in userspace?

	-hpa

