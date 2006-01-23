From: Gordon Henderson <gordon@drogon.net>
Subject: Re: cpu consumption
Date: Mon, 23 Jan 2006 22:40:18 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601232238440.23760@lion.drogon.net>
References: <43D55876.5020800@ula.ve>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D55876.5020800@ula.ve>
Sender: linux-raid-owner@vger.kernel.org
To: Gilberto Diaz <gilberto@ula.ve>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 Jan 2006, Gilberto Diaz wrote:

>    The problem is that the following proccesses are using a lot of cpu
> time.
>
>     md1_raid1
>     md1_resync
>     ......
>     md6_raid1
>     md6_resync
>
>     Here is a sample of the uptime command
>
> 17:54:16 up  5:48,  2 users,  load average: 5.02, 5.05, 5.26
>
>     Does anybody have an idea what is the problem? Thank a lot in advance

to me, it looks like the "problem" is that the RAID system is still
creating the array and syncing all the partitions up. Once it's finished
your system will be idle.

I bet it's stopped doing it by the time you get this email... What does
the output of

  cat /proc/mdstat

look like?

Gordon
