From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: Few questions
Date: Fri, 07 Dec 2007 19:22:45 -0800
Message-ID: <475A0E05.6010904@fatooh.org>
References: <4759E13F.7000308@makuch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4759E13F.7000308@makuch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Makuch <linuxraid@makuch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Makuch wrote:
> I realize this is the developers list and though I am a developer I'm 
> not a developer
> of linux raid, but I can find no other source of answers to these questions:

Don't worry; it's a user list too.

> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 etherd/e0.0[0] etherd/e0.2[9](S) etherd/e0.9[8] 
> etherd/e0.8[7] etherd/e0.7[6] etherd/e0.6[5] etherd/e0.5[4] 
> etherd/e0.4[3] etherd/e0.3[2] etherd/e0.1[1]
>       3907091968 blocks level 5, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
>       [============>........]  resync = 64.5% (315458352/488386496) 
> finish=2228.0min speed=1292K/sec
> unused devices: <none>
> 
> and I have no idea where the raid6 came from.

As far as I understand, the "Personalities" line just shows what RAID
capabilities are compiled into the kernel (and loaded, if modules). For
example, even though I'm only using raid0, I have:

-----------------------------------------------------------------
$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid0 sdc[0] sdb[1]
      976772992 blocks 64k chunks

unused devices: <none>
-----------------------------------------------------------------

-Corey
