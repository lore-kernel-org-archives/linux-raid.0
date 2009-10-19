From: =?ISO-8859-2?Q?Pawe=B3_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: [BUG] Soft lockups in 2.6.32-rc3
Date: Mon, 19 Oct 2009 11:02:29 +0200
Message-ID: <b95c1fdd0910190202y7bbceef7vbe6db2d5f6833a55@mail.gmail.com>
References: <20091011201955.GA19308@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091011201955.GA19308@uio.no>
Sender: linux-raid-owner@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/10/11 Steinar H. Gunderson <sgunderson@bigfoot.com>:
> Hello,
>
> I've just upgraded from 2.6.31-rc8 to 2.6.32-rc3, and I thought I wou=
ld turn
> on the new multicore RAID-5 processing. I did, it booted up and start=
ed
> syncing RAIDs (since the last shutdown before that was not clean), an=
d
> started syncing at the minimum speed (1000 K/sec). I've seen this bef=
ore, so
> I upped it in /proc to about 100MB/sec minimum (which is well below w=
hat I've
> seen from that RAID; six 7200rpm SATA drives connected by SAS).
>
> However, it never wanted to go above about 8-10MB/sec, and md4_raid5 =
used
> 100% CPU while I/O was extremely slow. Suddenly the serial console fl=
ashed:
>
< snip >

Hi,

I'm not savvy enough to read traces, but on surface it looks similar
to a problem described in a thread started on the linux-raid list by
Holger Kiehl on Oct. 16. (Raid reconstructing and process hanging in D
state).

Hope it helps.

Regards,
Pawe=B3
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
