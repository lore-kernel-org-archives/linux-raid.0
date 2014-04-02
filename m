From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Problem Syncing raid1
Date: Wed, 2 Apr 2014 17:53:44 -0400
Message-ID: <CAK_KU4bGUf_kEJBogotsO1OasPNN7wAZvJFmAWJndicBCZUSnw@mail.gmail.com>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Schmitz <schnet@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would advise copying everything important off that degraded array ASAP...

Check your dmesg logs and see if either sda or sdb is having trouble.

You should also install smartmon-tools and check the SMART status of
each drive, look for reallocated_sector_count . It might be helpful to
do it with a '-t long' option overnight so that SMART can try to remap
any sectors it is having trouble reading.

That will help you identify some potential hardware problems.

If the good disk in your array is acting up, you might be able to stop
the array, DD copy the misbehaving partition to a good drive, and then
restart the array.

Good luck!

On Wed, Apr 2, 2014 at 4:56 PM, Christian Schmitz <schnet@hotmail.com> wrote:
> Hi everyone,
> I have a linux with the following configuration:
> /dev/md0 ( degraded mode)  (/dev/sda2)
>
> /dev/md1 ( full mode) (/dev/sda3 /dev/sdb3)
>
> The problem is if i add /dev/sdb2 to /dev/md0 start the syncing, but when reach 7% the system crash.
> I am sure that the main problem is one ( or more) badblock into /dev/sda2.
>
> How i can do to syncing the disk?.
> Obviously Is the first step to change the disk.
>
> Best Regards
> Christian
>
> be free, be linux                                         --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
