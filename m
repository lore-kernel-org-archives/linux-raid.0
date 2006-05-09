From: Mike Hardy <mhardy@h3c.com>
Subject: Re: slackware -current softraid5 boot problem - additional info
Date: Tue, 09 May 2006 08:58:01 -0700
Message-ID: <4460BC09.8000402@h3c.com>
References: <200605090006.32615.Dexter.Filmore@gmx.de> <20060509055048.GA22085@percy.comedia.it> <200605091235.58939.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200605091235.58939.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Something fishy here

Dexter Filmore wrote:

> # mdadm -E /dev/sdd

Device /dev/sdd

> # cat /proc/mdstat
> Personalities : [raid5]
> md0 : active raid5 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>       732563712 blocks level 5, 32k chunk, algorithm 2 [4/4] [UUUU]

Components that are all the first partition.

Are you using the whole disk, or the first partition?

It appears that to some extent, you are using both.

Perhaps some confusion on that point between your boot scripts and your
manual run explains things?


-Mike
