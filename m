From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: sync action not working/ignored
Date: Sun, 23 Sep 2012 07:59:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209230757420.13902@uplift.swm.pp.se>
References: <20120923002734.Horde.j1X3SZk8pphQXjtWHRF5P_A@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-295466906-1348379902=:13902"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120923002734.Horde.j1X3SZk8pphQXjtWHRF5P_A@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Alexander_K=FChn?= <alexander.kuehn@nagilum.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-295466906-1348379902=:13902
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 23 Sep 2012, Alexander Kühn wrote:

> root@nas:~# echo /sys/block/md*/md/sync_action
> /sys/block/md1/md/sync_action
> root@nas:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md1 : active (auto-read-only) raid5 sdb[5] sdg[9] sdd[7] sdf[6] sde[8] sdc[2] 
> sda[1]
>     11719408128 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] 
> [UUUUUUU]
>     bitmap: 0/15 pages [0KB], 65536KB chunk

I'd imagine that it's the "(auto-read-only)" that is the culprit here. If 
you can do something that writes to the array (mount of a filesystem for 
instance) and then reproduce the problem?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-295466906-1348379902=:13902--
