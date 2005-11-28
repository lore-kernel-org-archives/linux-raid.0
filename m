From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: [PATCH] Fix for "Booting from raid1 -- md: invalid raid superblock mag"
Date: Sun, 27 Nov 2005 21:15:24 -0500
Message-ID: <05e201c5f3c1$97865c90$200a11ac@NCNF5131FTH>
References: <438A238C.6030403@twilight-hall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Rapha=EBl_Rigo?= <raphael.rigo@twilight-hall.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 27 November 2005 16:18:23, Rapha=EBl Rigo wrote
>
> Hi,
> here is a patch that fixes the problem described by David M. Stra.
>
> The problem is that the array is first initialized with SET_ARRAY_INF=
O=20
> without
> any specific parameter and the md driver uses the 0.90 behaviour by=20
> default.
> So we must specify it's 1.0 superblock by doing another SET_ARRAY_INF=
O.
>
> I'll correct if anything is wrong.
>

^^-- This workaround does work; it may limit those run multiple raid ar=
rays=20
with different types superblocks in each array that need to be loaded v=
ia=20
do_mounts_md.c -- but if you are using all superblock v1.0; this does g=
et=20
the job done.

Many thanks for the time you spent debugging this with me today.

-- David=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
