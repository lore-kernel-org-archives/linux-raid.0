From: Phil Turmel <philip@turmel.org>
Subject: Re: help needed restoring data
Date: Sun, 04 Aug 2013 10:54:02 -0400
Message-ID: <51FE6B0A.7020704@turmel.org>
References: <CAHTsmnnifoZAP0x4NhPW6xDiJCF_idp6=gqDKjMY-yNFXQEF2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHTsmnnifoZAP0x4NhPW6xDiJCF_idp6=gqDKjMY-yNFXQEF2A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VXdlIFfDpGNodGVy?= <uwe.waechter@googlemail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Uwe,

I see that you've gone unanswered for a while here...

On 08/03/2013 09:59 AM, Uwe W=C3=A4chter wrote:
> Hi list,
> I have a problem with my raid 5 array based on 3 harddisks. I need
> help to find the best way to recover my data.
> So what happens ....
> First of all 1 harddisk fails with the message :
>=20
> A Fail event had been detected on md device /dev/md/0.
>=20
> It could be related to component device /dev/sde1.
>=20
>=20
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sde1[4](F) sdc1[3] sdd1[0]
>       1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3=
/2] [U_U]
>=20
> unused devices: <none>
>=20
>=20
> No problem at this time, the raid is still running with 2 harddisks.
> The reason for the error was the following message of sde1
> Jul 27 06:38:31 fed1 kernel: [987606.852610] md/raid:md0: Disk failur=
e
> on sde1, disabling device.
> Jul 27 06:38:31 fed1 kernel: [987606.852610] md/raid:md0: Operation
> continuing on 2 devices.
> Jul 27 06:38:31 fed1 kernel: [987606.852613] sd 4:0:0:0: [sde]
> Jul 27 06:38:31 fed1 kernel: [987606.852615] Result:
> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
> Jul 27 06:38:31 fed1 kernel: [987606.852617] sd 4:0:0:0: [sde] CDB:
> Jul 27 06:38:31 fed1 kernel: [987606.852618] Read(10): 28 00 36 d4 f0
> 3f 00 02 98 00
> Jul 27 06:38:31 fed1 kernel: [987606.852625] end_request: I/O error,
> dev sde, sector 919924799
> Jul 27 06:38:31 fed1 kernel: [987606.852629] md/raid:md0: read error
> not correctable (sector 919924736 on sde1).
> Jul 27 06:38:31 fed1 kernel: [987606.852638] md/raid:md0: read error
> not correctable (sector 919924744 on sde1).
> Jul 27 06:38:31 fed1 kernel: [987606.852641] md/raid:md0: read error
> not correctable (sector 919924752 on sde1).
> Jul 27 06:38:31 fed1 kernel: [987606.852643] md/raid:md0: read error
> not correctable (sector 919924760 on sde1).
> Jul 27 06:38:31 fed1 kernel: [987606.852645] md/raid:md0: read error
> not correctable (sector 919924768 on sde1).

It seems that your drive was kicked out of the array on a *read* error.
 Nowadays, that usually happens when a drive dies completely.  Your
drives haven't, which suggests you are using an old kernel.  Current
kernels tolerate some read errors in order to attempt to rewrite the
problem locations.

Please supply your platform details, kernel version, and mdadm version.

> A couple of hours later, just when I wanted to start backup the data
> partition the sdd also fails :-( with similar failures :
>=20
> A Fail event had been detected on md device /dev/md/0.
>=20
> It could be related to component device /dev/sdd1.

This sounds like an array that is lightly used and has never been scrub=
bed.

[trim /]

> So I have 2 device sdd and sde with unreadable sectors. sdc has no er=
rors.
> smartd[690]: Device: /dev/sde [SAT], 14 Currently unreadable (pending=
) sectors
> smartd[690]: Device: /dev/sdd [SAT], 11 Currently unreadable (pending=
) sectors

Regular scrubbing would have prevented these from accumulating, as long
as your devices handle timeouts properly.  (You should search this
list's archives for combinations of "ERC" "error recovery control"
"scterc" and "device/timeout" for an education on this common problem.)

> What is the best way to rebuild the array with sdc and sdd only ?

A degraded raid5 cannot have any bad sectors, so you'd have to fix the
bad sectors on /dev/sdd.  This is typically done with dd_rescue onto a
spare drive.

If you avoided writing to the degraded array, this may not be your best
recovery choice.  Did you have *anything* writing into the array during
those couple hours?

> Can I correct unreadable sectors before rebuild the array or does it
> destroy the array.

It doesn't destroy the array if you *only* rewrite the problem sectors.
 But don't do this yet.  Providing more information will help us help
you better.

> Do I need to change the 2 harddisks ?

Not enough information.  Please supply the full output of "smartctl -x"
for all three drives.

> I hope you can help me restoring much data as possible.

I think we can help you save the vast majority of your data.

> best regards Uwe

Regards,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
