From: Phil Turmel <philip@turmel.org>
Subject: Re: Failed Raid 5 due to OS mbr written on one of the array drives
Date: Mon, 2 Nov 2015 13:19:23 -0500
Message-ID: <5637A92B.5010305@turmel.org>
References: <CAArDwD-7=Vmo16K3GH0dxZie=RAiSavZNfMNvabf4X6G4fK34w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAArDwD-7=Vmo16K3GH0dxZie=RAiSavZNfMNvabf4X6G4fK34w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Tellier <telliern@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good afternoon Nicolas,

On 11/02/2015 12:02 PM, Nicolas Tellier wrote:
> I'm looking for advices regarding a failed (2 disc down) Raid 5 array
> with 4 disks. It was running in a NAS for quite some time but after I
> came back from a trip, I found out that the system disk was dead.
> After replacing the drive, I reinstalled the OS (OpenMediaVault for
> the curious). Sadly the mbr was written to one of the raid disk
> instead of the OS one. This would not have been too critical if, afte=
r
> booting the system, I didn't realized that the array was already
> running in degraded mode prior to the OS disk problem. Luckily I have
> a backup for most of the critical data on that array. There is nothin=
g
> that I cannot replace, but it would still be quite inconvenient. I
> guess it's a good opportunity to learn more about raid :)

Very good.  Many people don't understand that RAID !=3D Backup.

>  mdadm --stop /dev/md0 and removing the boot flag from the wrongly
> written raid disk are the only stuff that I did so far.

Good.

[trim /]

> Now, /dev/sda is more interesting. The partition is still present and
> looks intact, it seems like it's just missing the superblock because
> of the mbr shenanigan. Also the two healthy drives still see it as
> active.

The superblock isn't anywhere near the MBR, so something more than just
grub-install must have happened.  Be prepared to have lost more of
/dev/sda1 than you've yet discovered.

> After looking around on the internet, I found people suggesting to
> re-create the raid. It seems a bit extreme to me, but I cannot find
> any other solution=E2=80=A6

Unfortunately, yes.  You are past the point of a forced assembly or
other normal operations.

> Luckily I saved the original command used to create this array. Here
> is the one I think would be relevant in this case :
>=20
> mdadm --create --verbose --assume-clean /dev/md0 --level=3D5
> --metadata=3D1.2 --chunk=3D128 --raid-devices=3D4 /dev/sda1 /dev/sdb1
> /dev/sdc1 missing /dev/sdd

1) Leave off /dev/sdd
2) Include --data-offset=3D262144

If it runs and you can access the filesystem (I suspect not), set up a
partition on sdd and add that to your array.  Use zero-superblock to
blow away the stale superblock on sdd.

If it doesn't work due to more sda1 damage and you end up starting over=
,
consider wiping all of those partition tables and creating the new arra=
y
on all bare devices.  That'll minimize the chance of a misidentified
device later.

You'll want to investigate the health of sdd.  If it's healthy, then it=
s
drop-out must have been for some other reason.  You'll want to ensure
that doesn't happen again.

Consider browsing the archives and/or subscribing to learn the many
pitfalls for the unwary (hint: try searching for "timeout mismatch").

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
