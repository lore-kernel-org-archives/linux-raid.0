From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: sync action not working/ignored
Date: Mon, 24 Sep 2012 09:48:55 +0200
Message-ID: <50601067.4020003@profitbricks.com>
References: <20120923002734.Horde.j1X3SZk8pphQXjtWHRF5P_A@cakebox.homeunix.net> <alpine.DEB.2.00.1209230757420.13902@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1209230757420.13902@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: =?ISO-8859-15?Q?Alexander_K=FChn?= <alexander.kuehn@nagilum.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23.09.2012 07:59, Mikael Abrahamsson wrote:
> On Sun, 23 Sep 2012, Alexander K=FChn wrote:
>
>> root@nas:~# echo /sys/block/md*/md/sync_action
>> /sys/block/md1/md/sync_action
>> root@nas:~# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6]
>> sde[8] sdc[2] sda[1]
>>     11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2
>> [7/7] [UUUUUUU]
>>     bitmap: 0/15 pages [0KB], 65536KB chunk
>
> I'd imagine that it's the "(auto-read-only)" that is the culprit here=
=2E
> If you can do something that writes to the array (mount of a
> filesystem for instance) and then reproduce the problem?
>

Indeed, use "mdadm -w /dev/md1" to set it writeable. This immediately
starts pending sync actions. In the kernel code in "drivers/md/md.c"
there is the function "action_store" which handles your "sync_action"
sysfs file writes. I just sets some bits in "mddev->recovery".

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
