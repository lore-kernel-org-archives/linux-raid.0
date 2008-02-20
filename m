From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: LVM performance (was: Re: RAID5 to RAID6 reshape?)
Date: Wed, 20 Feb 2008 12:19:32 +0000
Message-ID: <18364.6868.854623.613958@tree.ty.sabi.co.UK>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
	<20080218062604.05ae4821@szpak>
	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>
	<20080218154203.6e2d1483@szpak>
	<47BB30DF.1080006@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47BB30DF.1080006@student.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> This might be related to raid chunk positioning with respect
>> to LVM chunk positioning. If they interfere there indeed may
>> be some performance drop. Best to make sure that those chunks
>> are aligned together.

> Interesting. I'm seeing a 20% performance drop too, with default
> RAID and LVM chunk sizes of 64K and 4M, respectively. Since 64K
> divides 4M evenly, I'd think there shouldn't be such a big
> performance penalty. [ ... ]

Those are as such not very meaningful. What matters most is
whether the starting physical address of each logical volume
extent is stripe aligned (and whether the filesystem makes use
of that) and then the stripe size of the parity RAID set, not
the chunk sizes in themselves.

I am often surprised by how many people who use parity RAID
don't seem to realize the crucial importance of physical stripe
alignment, but I am getting used to it.

Because of stripe alignment it is usually better to build parity
arrays on top of partitions or volumes than viceversa, as it is
often more difficult to align the start of a partition or volume
to the underlying stripes than the reverse.

But then those who understand the vital importance of stripe
aligned writes for parity RAID often avoid using parity RAID
:-).
