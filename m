From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Raid stalls during --replace and other disk activity...
Date: Sat, 15 Mar 2014 15:53:33 -0400
Message-ID: <CAK_KU4bZnVSPR+mF3AX_sjQjTdnMonP9x+v84g9SEAN5Necr5g@mail.gmail.com>
References: <CAK_KU4bEFkydyqJfrUWNoq9R7AxVwPU29Kyzp+5mn=tmf7GgHQ@mail.gmail.com>
	<5324A7A9.1040700@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5324A7A9.1040700@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> This is deliberate, and in my opinion, desirable.  Same thing happens
> when doing a check or any kind of rebuild on multiple arrays that use
> partitions on shared underlying devices.  If you don't limit the raid
> background activity, the extra seek load on the devices can severely cut
> performance, especially on spinning rust.
>

If I was doing a 'normal' resync, I would also agree.

But my point was this...
My raid was doing a --replace of /dev/sdf1 with /dev/sde1
It was only reading/writing from/to those two devices, not the other
disks in the raid. (i.e. /dev/sd[a-d] were not being used)
The other job I started (dd if=/dev/zero of=/dev/sda2 bs=1M) was only
writing to /dev/sda

These jobs should be are perfectly capable of running in parallel
without slowing eachother down.

I think the logic that pauses a resync on 'related' disk activity
should treat a --replace slightly different
