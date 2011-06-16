From: NeilBrown <neilb@suse.de>
Subject: Re: md 3.2.1 and xfs kernel panic on Linux 2.6.38
Date: Thu, 16 Jun 2011 11:55:31 +1000
Message-ID: <20110616115531.298328f2@notabene.brown>
References: <BANLkTimCyX=fBuXfuYx30X7M-ninCULq4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimCyX=fBuXfuYx30X7M-ninCULq4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-xfs@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 Jun 2011 11:50:01 -0700 "fibreraid@gmail.com"
<fibreraid@gmail.com> wrote:

> Hi All,
>=20
> I am benchmarking md RAID with XFS on a server running Linux 2.6.38
> kernel. The server has 24 x HDD's, dual 2.4GHz 6-core CPUs, and 24GB
> RAM.
>=20
> I created an md0 array using RAID 5, 64k chunk, 23 active drives, and
> 1 hot-spare. I then created a LVM2 volume group from this md0, and
> created an LV out of it. The volume was formatted XFS as follows:
>=20
> /sbin/mkfs.xfs =96f =96l lazy-count=3D1 -l size=3D128m -s size=3D4096
> /dev/mapper/pool1-vol1
>=20
> I then mounted it as follows:
>=20
> /dev/mapper/pool1-vol1 on /volumes/pool1/vol1 type xfs
> (rw,_netdev,noatime,nodiratime,osyncisdsync,nobarrier,logbufs=3D8,del=
aylog)
>=20
> Once md synchronization was complete, I removed one of the active 23
> drives. After attempting some IO, the md0 array began to rebuild to
> the hot-spare. In a few hours, it was complete and the md0 array was
> listed as active and healthy again (though now lacking a hot-spare
> obviously).
>=20
> As a test, I removed one more drive to see what would happen. As
> expected, mdadm reported the array as active but degraded, and since
> there was no hot-spare available, there was no rebuilding happening.
>=20
=2E...
>=20
> What surprised me though is that I was no longer able to run IO on th=
e
> md0 device. As a test, I am using fio to generate IO to the XFS
> mountpoint /volumes/pool1/vol1. However, IO failed. A few minutes
> later, I received the following kernel dumps in /var/log/messages. An=
y
> ideas?
>=20
>=20
>=20
> Jun 12 11:33:54 TESTBA16 kernel: [59435.936575] fio             D
> ffff88060c6e1a50     0 30463      1 0x00000000
> Jun 12 11:33:54 TESTBA16 kernel: [59435.936578]  ffff880609887778
> 0000000000000086 0000000000000001 0000000000000086
> Jun 12 11:33:54 TESTBA16 kernel: [59435.936581]  0000000000011e40
> ffff88060c6e16c0 ffff88060c6e1a50 ffff880609887fd8
> Jun 12 11:33:54 TESTBA16 kernel: [59435.936583]  ffff88060c6e1a58
> 0000000000011e40 ffff880609886010 0000000000011e40
> Jun 12 11:33:54 TESTBA16 kernel: [59435.936586] Call Trace:
> Jun 12 11:33:54 TESTBA16 kernel: [59435.936594]  [<ffffffffa025e698>]
> make_request+0x138/0x3d0 [raid456]

>=20
> The errors seem to be a combination of XFS and md related messages.
> Any insight into this issue would be greatly appreciated. Thanks!
>=20

Very peculiar!

It appears that make_request in raid5.c is entering schedule() in an
uninterruptible wait.
There are 4 places where make_request calls schedule.
2 can only happen if the  array is being reshaped (e.2. 5 drives to 6 d=
rives)
but that does not appear to be happening.
1 causes and interruptible wait, so it cannot be that one.

That just leaves the one on line 4105.
This requires either than the stripe is being reshaped (which we alread=
y
decided isn't happening) or that md/raid5 has received overlapping requ=
ests.

i.e. while one request (either read or write) was pending, another requ=
est
(either read or write, not necessarily the same) arrives for a range of
sectors which over-laps the previous request.

When this happens (which it shouldn't because it would be dumb for a
filesystem to do that, but you never know) md/raid5 will wait for the f=
irst
request to be completely handled before letting the second proceed.
So we should be waiting here for at most a small fraction of a second.
Clearly we are waiting longer than that...

So this cannot possibly happen (as is so often the case when debugging =
:-)

Hmmm... maybe we are missing the wakeup call.  I can find where we wake=
-up
anyone waiting for an overlapping read request to complete, but I canno=
t find
where we wake-up someone waiting for when an overlapping write request
completes.  That should probably go in handle_stripe_clean_event.

Do you have the system still hanging in this state?  If not, can you ge=
t it
back into this state easily?
If so, you can force a wakeup with the magic incantation:

 cat /sys/block/mdXX/md/suspend_lo > /sys/block/mdXX/md/suspend_lo

(with 'XX' suitably substituted).

If that makes a difference, then I know I am on the right track

Thanks,
NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
