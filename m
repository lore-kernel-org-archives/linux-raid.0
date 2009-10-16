From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: Disappointing RAID10 Performance
Date: Fri, 16 Oct 2009 14:20:42 -0700
Message-ID: <7bc80d500910161420p3e16e20bj7ee69ee1d3ac3a9f@mail.gmail.com>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, I've looked at this again.

It's plausible that md's read balancing would increase the read speed,
but it appears that this is not the case. Are you using LVM? And the
readahead for the block devices are set appropriately? Distro? Version
of mdadm?

cc

On Fri, Oct 16, 2009 at 10:32 AM, adfas asd <chimera_god@yahoo.com> wro=
te:
> I was hoping to get better performance with RAID10 than from the raw =
disks, but that's turned out to not be the case. =A0Experimenting with =
the readahead buffer I get these bandwidths with the following command:
> # time dd if=3D{somelarge}.iso of=3D/dev/null bs=3D{readahead size}
>
> /dev/sd?
> =A01024 71.3 MB/s
> =A02048 71.2 MB/s
> =A04096 77.7 MB/s
> =A08192 69.4 MB/s
> =A016384 76.6 MB/s
>
> /dev/md2
> =A01024 =A067.1
> =A02048 =A069.1
> =A04096 =A075.7
> =A08192 =A064.9
> =A016384 69.0
>
> Using RAID10offset2 on 2 WD 2TB drives, and always the same input fil=
e.
>
> Why would RAID10 performance be -poorer-?
> If it weren't for mirroring, this wouldn't be worth it.
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
