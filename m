From: Carlos Mennens <carloswill@gmail.com>
Subject: Re: RAID1 On 3 Drives
Date: Mon, 15 Mar 2010 09:47:25 -0500
Message-ID: <d80f793f1003150747h203aa5c4kc80375f4250f4532@mail.gmail.com>
References: <4B9C11FB.7040604@gmx.net>
	 <d80f793f1003131518u2bfe77e9k52ef77e3d2c68360@mail.gmail.com>
	 <4B9C24B6.7040507@tmr.com>
	 <d80f793f1003150530y1b229f43s1f140f91ab74f3e8@mail.gmail.com>
	 <70ed7c3e1003150548v65dce098ud62ddfbcc0747d49@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e1003150548v65dce098ud62ddfbcc0747d49@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 15, 2010 at 7:48 AM, Majed B. <majedb@gmail.com> wrote:
> Carlos,
>
> Choosing your RAID setup depends on the purpose of your machine. Is it
> a web server, file server, archive, mail, video storage, ...etc.

Basically this is my everyday workstation that I keep everything on.
It's not hosting Apache or MySQL or anything like that. Just my
everyday workstation.

> /boot is only used during boot up. Having a spare on stand by or not
> does not affect performance, except in the case a disk dies; in that
> case, the hot spare is engaged and becomes an active disk at which the
> array starts to resync the data to this new disk. During resyncing,
> performance will be degraded.

Oh, I was wondering why Bill noted previously that a spare would hurt
performance but based on your info above, this is only if a drive
fails and then the spare starts to synchronize. I hope that is what
Bill meant.

> As for your RAID5 question: I think if your usage of the server is
> write-mostly, you may find it to have better performance with 3 disks
> rather 4. If it's read-mostly, then 4 disks should perform better.
>
> If you have physical access to the machine, try both cases. Setting
> them up won't take more than 5-10 minutes. Benchmarking wouldn't take
> more than 15 minutes in each setup.
>
> Remember, there are parameters to fine-tune: NCQ, read-ahead, noatime,
> nodiratime, chunksize, ...etc.

I do have access to the machine as it's my new Desktop PC I am
building today at some point. I just wanted to get some expert advise
on how I should proceed. For now I am going to use all 4 disks with no
spares.

I just don't know enough about fine tuning and how it could benefit or
hinder disk performance for my setup so I guess I will omit them until
I can understand what to use for what function. If you guys have any
suggestions for what parameters to use for /boot, /, or swap...please
feel free to chime in.

Thanks all!
