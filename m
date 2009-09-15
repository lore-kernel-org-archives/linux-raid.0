From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID1 assembled broken array
Date: Tue, 15 Sep 2009 22:24:29 +0300
Message-ID: <70ed7c3e0909151224s75cd6c60kc65c2f4e9076e649@mail.gmail.com>
References: <h8ophd$n8p$6@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h8ophd$n8p$6@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Specifying partition names may cause problems if the disk names
changed. Specify the UUID instead.

On Tue, Sep 15, 2009 at 10:22 PM, Matthias Urlichs <matthias@urlichs.de=
> wrote:
> I had a somewhat strange error today.
>
> One of my servers has a RAID1 array. Two partitions at the end of the
> disk; the RAID superblocks are at the end of the partition.
>
> After a hard reboot today, one of the disks managed to not have its
> partition table scanned correctly, most probably because the disk was
> hung and the ("intelligent") controller got confused about it. After =
the
> initial scan, however, it came up correctly.
>
> This error caused mdadm to "successfully" build a RAID1 from /dev/sda=
3
> and /dev/sdb (instead of /dev/sdb3). Needless to say, the resulting
> volume was somewhat unuseable. To say the least.
>
> My server's mdadm.conf has a 'DEVICE=3Dpartitions' line. I suppose th=
at
> replacing these with a pattern that explicitly only matches partition=
s,
> not disks, would make the problem go away, and that the lesson from
> today's disaster recovery effort is to always explicitly list the all=
owed
> partition names, instead of being lazy and using 'DEVICE=3Dpartitions=
'.
>
> --
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
