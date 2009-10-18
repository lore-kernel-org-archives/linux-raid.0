From: "NeilBrown" <neilb@suse.de>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Mon, 19 Oct 2009 07:14:06 +1100
Message-ID: <358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, October 19, 2009 3:10 am, Guy Martin wrote:
>
> Hi,
>
> I'm currently doing tests with the latest devel-3.1 branch to migrate
> my fileserver's raid 5 array to a raid 6 array.
>
> I thus created a raid5 test array with 3 drives and tried to grow it to
> a raid 6 array with 4 drives.
> This is how the array looked like before the reshape :
> md0 : active raid5 sdf1[3](S) sde1[2] sdd1[1] sdb1[0]
>       976767872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>
> Using kernel 2.6.31.4, the reshape to raid 6 started as expected but
> would take about 2 weeks to complete at about 400Kb/s with 4*500G
> drives. I used the following command :
> mdadm --grow /dev/md0 --backup-file backup -l 6 -n 4
>
> Time is not so critical for me so I let it ran for 2 days. It was then
> at about 13% and I decided to perform a reboot to see if it would
> recover. Unfortunately, I now have the following output when trying to
> assemble the array :
> mdadm --assemble /dev/md0 /dev/sd[bdef]1 --backup-file backup
> mdadm: Failed to restore critical section for reshape, sorry.
>
> There were no usefull data on this test array but it would be nice if
> this doesn't happen on my fileserver :)
>

Thanks for doing this testing!

> Any idea how to resolve this issue ?

Try pulling the very latest from my git repo.  I was doing some testing
like this just last week and found a number of issues which I think
I have fixed.

NeilBrown

