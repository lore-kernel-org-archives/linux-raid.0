From: Stephen Lee <splee@plexio.com>
Subject: Re: RAID startup problem
Date: 14 May 2003 20:12:15 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052968335.1906.108.camel@ralph.plexio.private>
References: <3EC2A232.8070308@moeraki.com>
	 <B0E6075E55C7D6119DDE0002A53F8BCEFFDD2D@blpfroclab01.bausch.com>
	 <20030514194644.GB6949@localhost> <3EC2A232.8070308@moeraki.com>
	 <5.1.1.6.2.20030514165613.03b11db0@mail.harddata.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.1.6.2.20030514165613.03b11db0@mail.harddata.com>
To: Raid <linux-raid@vger.kernel.org>
Cc: maurice@harddata.com
List-Id: linux-raid.ids

On Wed, 2003-05-14 at 19:47, Maurice Hilarius wrote:
> Hi There!
> 
> I just set up a server with 2 x 3Ware cards, 16 IDE disks, and am building 
> a number of software md raids using mdadm.
> 
> Everything built and synched OK, but the raid1 devices don't seem to come 
> up upon reboot.
> 
> Any suggestions are appreciated!
> 
> Here is some fairly detailed info:
> 
> 
> Status upon reboot:
> 
> md2 : active raid5 sdl1[2] sde1[1] sdd1[0]
>        19550848 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> md6 : active raid5 sdl2[2] sde2[1] sdd2[0]
>        136745088 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> md7 : active raid5 sdn2[2] sdm2[1] sdf2[0]
>        136745088 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> md8 : active raid5 sdo2[2] sdh2[1] sdg2[0]
>        136745088 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> unused devices: <none>

Was your raid1 module loaded prior to calling the raid1 devices during
bootup? What personalities does /proc/mdstat show?

Stephen



