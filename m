From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Fri, 20 Jul 2012 07:28:06 -0400 (EDT)
Message-ID: <cd566e75-b51c-4503-a914-ba7c59eca361@zmail15.collab.prod.int.phx2.redhat.com>
References: <c4ee4468-579c-4bc3-acd3-c487bebfe35d@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c4ee4468-579c-4bc3-acd3-c487bebfe35d@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Btrfs and zfs has it's own RAID layer, so there's no need for
> underlying MD-RAID. But I haven't studied how exactly it's done
> there.

I just read some ZFS docs and look at the following paragraph ...

---
Mirrored Vdev=E2=80=99s (RAID1)
This is akin to RAID1. If you mirror a pair of Vdev=E2=80=99s (each Vde=
v
is usually a single hard drive) it is just like RAID1, except
you get the added bonus of automatic checksumming. This prevents
silent data corruption that is usually undetectable by most
hardware RAID cards.
---

As you see that's not just my own blurred dream ... It seems
I'm not the only one who encountered silent data corruptions.
And it doesn't matter what the root cause of such corruptions is.
They simply appear from time to time and checksums seem to
prevent from them being silently ignored.

>=20
> > This should probably be a
> > DM/LVM
> > project.
>=20
> LVM ? How do you want to implement that in LVM? You would create
> two big PVs with two big logical partitions protected by checksums?
> The mdraid layer would be built on top of these, right?
> That could possibly work too if LVM returns read errors for blocks
> with incorrect checksums. I'm not fully against that idea.

I just got on my mind, that this wouldn't allow us to resync
the correct data immediately back to the drive where the corruption
appeared. So ... I still believe, that the RAID layer is the best
place for this feature.

Regards,
Jaromir.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
