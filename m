From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Wed, 14 Mar 2012 19:14:30 +0800
Message-ID: <CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EFEB6.4060402@kernel.org>
	<alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
	<CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
	<alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de>
	<CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com>
	<alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

2012/3/14 Holger Kiehl <Holger.Kiehl@dwd.de>:
> On Wed, 14 Mar 2012, Shaohua Li wrote:
>
>> 2012/3/13 Holger Kiehl <Holger.Kiehl@dwd.de>:
>>>
>>> On Tue, 13 Mar 2012, Shaohua Li wrote:
>>>
>>>> Thanks for testing. This is very wield, the req->__data_len is wro=
ng.
>>>> Is this a clean build?
>>>>
>>> I just downloaded linux-3.3-rc7.tar.bz2 from kernel.org and applied
>>> your patches again. The result is the same.
>>>
>>> Am I the only one experiencing these problems?
>>
>> Martin Petersen pointed out scsi layer doesn't support discard merge=
,
>> which
>> might be the reason you see the error message (my drive isn't a scsi
>> device).
>> can you please try attached patch?
>>
> Thanks! After this patch the error messages are away.
>
> However, when the system boots it takes a very long time to boot:
>
> =A0 [ =A0 16.527389] EXT4-fs (md0): mounted filesystem with ordered d=
ata mode.
> Opts: discard,commit=3D2400,journal_async_commit
> =A0 [ =A0 24.218410] EXT4-fs (md2): mounted filesystem with ordered d=
ata mode.
> Opts: discard,commit=3D600,journal_async_commit
> =A0 [ =A0 69.823138] udevd[474]: timeout '/sbin/blkid -o udev -p /dev=
/md0'
> =A0 [ =A0 70.824197] udevd[474]: timeout: killing '/sbin/blkid -o ude=
v -p
> /dev/md0' [866]
> =A0 [ =A0 70.826823] udevd[474]: '/sbin/blkid -o udev -p /dev/md0' [8=
66]
> terminated by signal 9 (Killed)
> =A0 [ =A0 70.829290] udevd[474]: timeout 'udisks-part-id /dev/md0'
> =A0 [ =A0 74.942625] udevd[475]: timeout '/sbin/blkid -o udev -p /dev=
/md2'
> =A0 [ =A0 75.947158] udevd[475]: timeout: killing '/sbin/blkid -o ude=
v -p
> /dev/md2' [874]
> =A0 [ =A0 75.949734] udevd[475]: '/sbin/blkid -o udev -p /dev/md2' [8=
74]
> terminated by signal 9 (Killed)
> =A0 [ =A0 75.951945] udevd[475]: timeout 'udisks-part-id /dev/md2'
> =A0 [ =A0 79.023741] rmmod[886]: ERROR: Module scsi_wait_scan does no=
t exist in
> /proc/modules
> =A0 [ =A0 96.005919] systemd[1]: dev-md3.swap activation timed out. S=
topping.
> =A0 [ =A0127.292002] Adding 9434108k swap on /dev/md3. =A0Priority:0 =
extents:1
> across:9434108k
>
> During another boot I saw this additional message:
>
> =A0 [ =A0 11.988732] scsi_verify_blk_ioctl: 930 callbacks suppressed
>
> The strange thing is that after boot I tried to enter the command
> '/sbin/blkid -o udev -p /dev/md0' and it works without any problems
> (time for this is 0m0.001s). So I also tried booting without discard
> option, but the result is the same.
>
> Otherwise I observed no problems. Even running some more extensive
> benchmark testing showed no problems. Only the performance drop is
> dramatic. In my own benchmark where thousand of files get copied arou=
nd
> via FTP the performance drops from 4000 files per second to 520 when
> mounting the filesystem with discard option. Also during the benchmar=
k
> any access to the disk can take very very long if discard is enabled.
>
> Next, I will try this patch on a system without SATA/SCSI disks.
Maybe the discard runs slow with small size request in the disk.
please drop patch "blk: add plug for blkdev_issue_discard" and try agai=
n. Since
we can't do merge, the plug just introduces latency.
if it doesn't help, please capture a blktrace when you do the benchmark=
 and
send it to me.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
