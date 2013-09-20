From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Fri, 20 Sep 2013 10:56:16 +0200
Message-ID: <CAC9WiBjnM5nwKf4f7UN6hQgsbYhVLLPnfAD6RATbF3C-NHRrXg@mail.gmail.com>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
	<20130914064305.0baadc69@notabene.brown>
	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>
	<20130914203800.385466b2@notabene.brown>
	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>
	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>
	<5234CA6A.3070305@arcor.de>
	<CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>
	<52373A19.7000105@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52373A19.7000105@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Martin,

On Mon, Sep 16, 2013 at 7:04 PM, Martin Wilck <mwilck@arcor.de> wrote:
> On 09/16/2013 03:56 PM, Francis Moreau wrote:
>
>> I did give your patch "DDF: compare_super_ddf: fix sequence number
>> check" a try and now mdadm is able to detect a difference between the
>> 2 disks. Therefore it refuses to insert the second disk which is
>> better.
>>
>> However it's still not able to detect which version is the "fresher"
>> like mdadm does with soft RAID1 (metadata 1.2). Therefore mdadm is not
>> able to kick out the first disk if it's the outdated one.
>>
>> Is that expected ?
>
> At the moment, yes. This needs work.
>

Actually this is worse than I thought: with your patch applied mdadm
refuses to add back a spare disk into a degraded DDF array.

For example on a DDF array:

# cat /proc/mdstat
Personalities : [raid1]
md126 : active raid1 sdb[1] sda[0]
      2064384 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive sdb[1](S) sda[0](S)
      65536 blocks super external:ddf

unused devices: <none>

# mdadm /dev/md126 --fail sdb
[   24.118434] md/raid1:md126: Disk failure on sdb, disabling device.
[   24.118437] md/raid1:md126: Operation continuing on 1 devices.
mdadm: set sdb faulty in /dev/md126

# mdadm /dev/md127 --remove sdb
mdadm: hot removed sdb from /dev/md127

# mdadm /dev/md127 --add /dev/sdb
mdadm: added /dev/sdb

# cat /proc/mdstat
Personalities : [raid1]
md126 : active raid1 sda[0]
      2064384 blocks super external:/md127/0 [2/1] [U_]

md127 : inactive sdb[1](S) sda[0](S)
      65536 blocks super external:ddf

unused devices: <none>


As you can see the reinserted disk sdb sits as spare and isn't added
back to the array.

Is it possible to add this major feature work again and keep your improvement ?

Thanks
-- 
Francis
