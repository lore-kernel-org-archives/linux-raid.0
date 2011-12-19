From: Chris Worley <worleys@gmail.com>
Subject: RAID50, despite chunk setting, does everything in 4KB blocks
Date: Mon, 19 Dec 2011 15:43:13 -0700
Message-ID: <CANWz5fhEz20oi9fXVuxngywMu6mZQtghMKCBCAwm5uOVXOD__w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It doesn't really matter what chunk sizes I set, but, for example, I
create=A0three RAID5's of 5 drives each with a chunk size of 32K, and
create a RAID0 comprised of the three RAID5's with a chunk size of
64K:

md0=A0: active raid0 md27[2] md26[1] md25[0]
=A0 =A0 =A0 1885098048 blocks super 1.2 64k chunks

If I write to one of the RAID5's, using:

# dd of=3D/dev/md27 =A0if=3D/dev/zero bs=3D1024k oflag=3Ddirect

=2E.. then "iostat -dmx 2" shows the drives being written to in 32K
chunks (avgrq-sz=3D64), as you'd expect.

But, writing to the RAID0 that's striping the RAID5's, shows
everything being written in 4KB chunks (iostat shows=A0avgrq-sz=3D8) to
the RAID0 as well as to the RAID5's.

Why is that? =A0Note that this is true for reading too. =A0Note I don't
see the same problem when using RAID10 (via striped RAID1's) or
RAID100 (via striped RAID10's).

=2E.. this is on SLES11 using a=A02.6.32.43-0.5 kernel.

Thanks,

Chris
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
