From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: O'Reilly RAID Book
Date: Mon, 29 Mar 2004 19:20:03 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0403291916280.22832@twinlark.arctic.org>
References: <1080605251.1695.14.camel@localhost> <87wu53yvtg.fsf@enki.rimspace.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wu53yvtg.fsf@enki.rimspace.net>
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 30 Mar 2004, Daniel Pittman wrote:

> 1. Buy and install the second disk.
>    Make sure you partition it to the desired sizes, and set all
>    partitions to type 'fd', 'RAID autodiscovery'.
>
> 2. Use mdadm to create the RAID1 in "degraded" mode, using only the
>    second disk.  eg:

you can do it the other way around with less copying -- using resize2fs to
shrink your main filesystem enough to fit the raid superblock at the end
of the partition.  then use mdadm to create a degraded array containing
your main partition ... then futz partition tables/etc. on the second
disk, and hotadd it.

i'm being deliberately vague because it's the sort of thing you want to
understand well enough that this vague description is all the hints you
need :)

the main difficulty is knowing how much to shrink... this would actually
be a useful addition to mdadm.  but you can't go wrong just shrinking by
128MB or such then grow after turning it into a raid.

-dean
