From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Fri, 26 Aug 2011 22:25:10 +0100
Message-ID: <CADNH=7GgGzhLLqYc5kSC=bMN43MK=DE1TwP7gDAeDutHCoO2kA@mail.gmail.com>
References: <4E57FE4D.5080503@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E57FE4D.5080503@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 August 2011 21:13, Timothy D. Lenz <tlenz@vorgon.com> wrote:
> I have 4 drives set up as 2 pairs. =C2=A0The first part has 3 partiti=
ons on it
> and it seems 1 of those drives is failing (going to have to figure ou=
t which
> drive it is too so I don't pull the wrong one out of the case)
>
> It's been awhile since I had to replace a drive in the array and my n=
otes
> are a bit confusing. I'm not sure which I need to use to remove the d=
rive:
>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sudo mdadm --manage /dev/md0 --fail /dev/s=
db
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sudo mdadm --manage /dev/md0 --remove /dev=
/sdb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sudo mdadm --manage /dev/md1 --fail /dev/s=
db
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sudo mdadm --manage /dev/md1 --remove /dev=
/sdb
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sudo mdadm --manage /dev/md2 --fail /dev/s=
db
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sudo mdadm --manage /dev/md2 --remove /dev=
/sdb
>
> or
>
> sudo mdadm /dev/md0 --fail /dev/sdb1 --remove /dev/sdb1
> sudo mdadm /dev/md1 --fail /dev/sdb2 --remove /dev/sdb2
> sudo mdadm /dev/md2 --fail /dev/sdb3 --remove /dev/sdb3
>
> I'm not sure if I fail the drive partition or whole drive for each.
>
> -------------------------------------
> The mails I got are:
> -------------------------------------
> A Fail event had been detected on md device /dev/md0.
>
> It could be related to component device /dev/sdb1.
>
> Faithfully yours, etc.
>
> P.S. The /proc/mdstat file currently contains the following:
>
> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
> md1 : active raid1 sdb2[2](F) sda2[0]
> =C2=A0 =C2=A0 =C2=A04891712 blocks [2/1] [U_]
>
> md2 : active raid1 sdb3[1] sda3[0]
> =C2=A0 =C2=A0 =C2=A0459073344 blocks [2/2] [UU]
>
> md3 : active raid1 sdd1[1] sdc1[0]
> =C2=A0 =C2=A0 =C2=A0488383936 blocks [2/2] [UU]
>
> md0 : active raid1 sdb1[2](F) sda1[0]
> =C2=A0 =C2=A0 =C2=A024418688 blocks [2/1] [U_]
>
> unused devices: <none>
> -------------------------------------
> A Fail event had been detected on md device /dev/md1.
>
> It could be related to component device /dev/sdb2.
>
> Faithfully yours, etc.
>
> P.S. The /proc/mdstat file currently contains the following:
>
> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
> md1 : active raid1 sdb2[2](F) sda2[0]
> =C2=A0 =C2=A0 =C2=A04891712 blocks [2/1] [U_]
>
> md2 : active raid1 sdb3[1] sda3[0]
> =C2=A0 =C2=A0 =C2=A0459073344 blocks [2/2] [UU]
>
> md3 : active raid1 sdd1[1] sdc1[0]
> =C2=A0 =C2=A0 =C2=A0488383936 blocks [2/2] [UU]
>
> md0 : active raid1 sdb1[2](F) sda1[0]
> =C2=A0 =C2=A0 =C2=A024418688 blocks [2/1] [U_]
>
> unused devices: <none>
> -------------------------------------
> A Fail event had been detected on md device /dev/md2.
>
> It could be related to component device /dev/sdb3.
>
> Faithfully yours, etc.
>
> P.S. The /proc/mdstat file currently contains the following:
>
> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
> md1 : active raid1 sdb2[2](F) sda2[0]
> =C2=A0 =C2=A0 =C2=A04891712 blocks [2/1] [U_]
>
> md2 : active raid1 sdb3[2](F) sda3[0]
> =C2=A0 =C2=A0 =C2=A0459073344 blocks [2/1] [U_]
>
> md3 : active raid1 sdd1[1] sdc1[0]
> =C2=A0 =C2=A0 =C2=A0488383936 blocks [2/2] [UU]
>
> md0 : active raid1 sdb1[2](F) sda1[0]
> =C2=A0 =C2=A0 =C2=A024418688 blocks [2/1] [U_]
>
> unused devices: <none>
> -------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Looks like your sda is failing, that's the smartctl -a /dev/sda output?

/Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
