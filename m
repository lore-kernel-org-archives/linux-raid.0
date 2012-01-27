From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID-6 recovery questions
Date: Fri, 27 Jan 2012 12:30:36 +0000
Message-ID: <CADNH=7FucU4vxjSom=n=vChHDCAvmZWWagsCgT-WEZE-pyhwKA@mail.gmail.com>
References: <20120127081025.GA22388@jurassic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120127081025.GA22388@jurassic>
Sender: linux-raid-owner@vger.kernel.org
To: Mukund Sivaraman <muks@banu.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27 January 2012 08:10, Mukund Sivaraman <muks@banu.com> wrote:
> Hi all
>
> I am interested in building a 3TB * 8 disk RAID-6 array for
> personal use. I am looking for info related to md recovery in the cas=
e
> of failure.
>
> I want to rely on the md RAID-6 array to some extent. It is a large
> capacity array, and it is not financially feasible for me to have an
> external mirror of it.
>
> It seems that distributions like Fedora have a raid-check script for
> periodic patrol read check, which is bound to reduce the risk of
> surprise read errors during recovery.
>
> In the unlikely case of 2 disk failure, a RAID-6 array loses redundan=
cy,
> but the array is still available.
>
> When a disk reports errors reading blocks, it's likely that the rest =
of
> the disk is readable, save for the bad blocks. In large capacity disk=
s
> available today, bad blocks are very common (as SMART output on year-=
old
> disks will show). (Rewriting these bad blocks should make the disk re=
map
> them and make them available again.)
>
> My questions:
>
> 1. During recovery after 1-disk failure, what happens if there are
> read errors on more than one disk? From what I've understood it seems
> that if there is a read error during recovery, the entire disk is mar=
ked
> as failed. It's very probable that these bad blocks are in different
> places on different disks. Is it mathematically possible (RAID-6) to
> recover such an array completely (rewriting the bad blocks with data
> from other disks)? What options are available to recover from such a
> situation?
>
> Figure:
>
> +---+---+---+---+---+---+---+---+
> | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | =C2=A0RAID-6 array
> +---+---+---+---+---+---+---+---+
> =C2=A0^ =C2=A0 ^ =C2=A0 ^ =C2=A0\---------v-------/
> =C2=A0| =C2=A0 | =C2=A0 | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ok
> dead =C2=A0| =C2=A0 |
> =C2=A0 =C2=A0 =C2=A0| =C2=A0 +- partial read errors
> =C2=A0 =C2=A0 =C2=A0+----- partial read errors
>
> {read_error_blocks(3)} intersect {read_error_blocks(2)} =3D NUL.
>
>
> 2. During recovery after 2-disk failure, what happens if there are
> read errors? =C2=A0Is it possible to overwrite the bad blocks with ze=
ros (so
> they are remapped and don't error anymore) and force them back into t=
he
> same array configuration so that most of the filesystem can be recove=
red
> (except for the data in the bad blocks) ?
>
> 3. What is the raid6check(8) tool useful for, which checks non-degrad=
ed
> arrays? =C2=A0Doesn't "echo check > /sys/block/$dev/md/sync_action" d=
o the
> same?
>
>
> Kind regards,
>
> Mukund
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

Hi,

(this caters to question 1 & 2)
I run a 7x 2TB array myself, which has had 2 drive failure the last ~2
years (the age of the array). The first time went smooth, MD kicked
out the bad drive almost immediately, and when I got the new drive it
rebuilt happily and everything was fine. The other time (see the last
few days on this mailing list) the drive wasn't kicked out straight
away - it kept retrying to read/write those bad sectors, and stalling
the entire system. I was unable to sync or anything, so I had to pull
the power, pull the bad disk, then power on the system again and
perform a RAID6 check (which turned out fine).

Lesson learned, you'll want a drive to get kicked out ASAP if it's
reporting errors. When it's kicked out, you can test it yourself while
your RAID6 still chugs along, and if you can fix the errors, stick it
back into the array. If not, RMA the drive.

3: I dunno.

Kind regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
