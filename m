From: Simon Frettloeh <sifr@aifb.uni-karlsruhe.de>
Subject: Re: RAID5 recovery after disk-change
Date: Wed, 13 Aug 2003 19:30:52 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0308131930450.13687-100000@aifbshark.aifb.uni-karlsruhe.de>
References: <Pine.LNX.4.44.0308131852190.13687-100000@aifbshark.aifb.uni-karlsruhe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0308131852190.13687-100000@aifbshark.aifb.uni-karlsruhe.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again!

Strange things happen and I don't know why. After resynching the RAID I
get following output:
====snip=============================================================
thismachine:~ # cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdg1[2] hdh1[3] hdf1[1] hde1[0]
      480214656 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
====snap=============================================================
So it seems, that hdg1 moved by itself from "4" to "2". What happened
(according to my previous email)?

Do I have to do any further things or is my RAID now working fine?

Ciao,
Simon



