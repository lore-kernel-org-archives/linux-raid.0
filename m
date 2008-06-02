From: David Greaves <david@dgreaves.com>
Subject: Re: Problem Growing Raid 5 Array - Help Needed!
Date: Mon, 02 Jun 2008 16:13:14 +0100
Message-ID: <48440E0A.7020707@dgreaves.com>
References: <484408bf.20018e0a.68db.ffffe97f@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484408bf.20018e0a.68db.ffffe97f@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Leigh <jeremy.leigh@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeremy Leigh wrote:
> Hi Guys, I have just grown my raid 5 from 7 to 8 500Gb drives.
> I am now running into this problem.
> When I try to run fsck /dev/md0 I get the following:

What command line?

> fsck.ext2: Device or resource busy while trying to open /dev/md0
> Filesystem mounted or opened exclusively by another program?
>=20
> Or when I try to run resize2fs /dev/md0 to make use of new drive, I g=
et the
> following:
>=20
> resize2fs: Device or resource busy while trying to open /dev/md0
> Couldn=92t find valid filesystem superblock.
again, what command.


> Cat /proc/mdstat outputs:
>=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 sdb1[0] sdi1[7] sdg1[6] sdh1[5] sdf1[4] sde1[3] sd=
d1[2]
> sdc1[1]
>       3418686208 blocks level 5, 256k chunk, algorithm 2 [8/8] [UUUUU=
UUU]
>      =20
> unused devices: <none>
So the resize worked and is complete.

> However, I can still access and mount my filesystem - I just cannot g=
row it,
> which I find very strange.
> I have tried to init 1, to go to single user mode, and I have made su=
re file
> system is unmounted, but this =91busy=92 error still occurs.

Have you rebooted? (Question, not suggestion)

What is the output from a mount command.
What is the line in /etc/fstab than normally mounts this filesystem?

Is mdadm running as a monitor daemon?

does lsof | grep <mountpoint> show anything?

David

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
