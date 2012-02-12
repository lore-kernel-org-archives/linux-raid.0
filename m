From: Jeff W <jeff.welling@gmail.com>
Subject: RAID6 ext3 problems
Date: Sun, 12 Feb 2012 12:47:38 -0500
Message-ID: <CAKXovcuTayKF2RKw3hYTBEdYsFM=bcV0xbc=UwYHCNTm+t-3GQ@mail.gmail.com>
References: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
	<CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
	<CAK2H+eerAkwup2UcAu2v=_4+=Bg_FBCqZmjGjmcLQA+2ozmvbg@mail.gmail.com>
	<CAKXovcvvTioOP+JKd8b5-Hc1GZhAiqB85=A4d-cCP03uDPiGkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKXovcvvTioOP+JKd8b5-Hc1GZhAiqB85=A4d-cCP03uDPiGkg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 12, 2012 at 12:31 PM, Mark Knecht <markknecht@gmail.com> wr=
ote:
> Jeff,
> =A0 I suspect that you'll need to provide more technical info for the
> heavy hitters to give good responses.
Thanks for the feedback Mark!

>
> mdadm -D /dev/md3

/dev/md1:
Version:00.90
Creation Time: Wed Sep 22 01:54:39 2010
Raid Level: raid6
Array Size: 2441437440 (2328.34 GiB 2500.03 GB)
Used Dev Size: 488287488 (465.67 GiB 500.01 GB)
Raid Devices: 7
Total Devices: 6
Preferred Minor: 1
Persistence: Superblock is persistent

Update Time: Sun Feb 12 11:01:35 2012
State: clean, degraded
Active Devices: 6
Working Devices: 6
=46ailed Devices: 0
Spare Devices: 0

Chunk Size: 64K

UUID: 82b58a02:0ea23fd4:bd4f9dde:33a158c6
Events: 0.5652574

Number =A0 =A0 Major =A0 =A0 Minor =A0 =A0 RaidDevice =A0 =A0 State
0 =A0 =A0 8 =A0 =A0 0 =A0 =A0 0 =A0 =A0 active sync =A0 /dev/sda
1 =A0 =A0 8 =A0 =A0 81 =A0 =A0 1 =A0 =A0 active sync =A0 /dev/sdf1
2 =A0 =A0 8 =A0 =A0 33 =A0 =A0 2 =A0 =A0 active sync =A0 /dev/sdc1
3 =A0 =A0 8 =A0 =A0 39 =A0 =A0 3 =A0 =A0 active sync =A0 /dev/sdd1
4 =A0 =A0 8 =A0 =A0 64 =A0 =A0 4 =A0 =A0 active sync =A0 /dev/sde
5 =A0 =A0 8 =A0 =A0 97 =A0 =A0 5 =A0 =A0 active sync =A0 /dev/sdg1
6 =A0 =A0 0 =A0 =A0 0 =A0 =A0 6 =A0 =A0 removed

>
> HTH,
> Mark
If there is anything else I can provide just ask, thanks for the tip Ma=
rk!

Jeff.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
