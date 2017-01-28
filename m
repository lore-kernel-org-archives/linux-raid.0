From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID 5 reshape stalled at 77.5% - next steps??
Date: Sun, 29 Jan 2017 04:15:59 +0500
Message-ID: <20170129041559.723d8259@natsu>
References: <CAF-Kpgbz_Ld5WVOid1SHopcOjdx63kM-zVDUScZowtQzxrtZHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-Kpgbz_Ld5WVOid1SHopcOjdx63kM-zVDUScZowtQzxrtZHg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>
List-Id: linux-raid.ids

On Sat, 28 Jan 2017 18:01:30 -0500
George Rapp <george.rapp@gmail.com> wrote:

> The reshape proceeded normally until it hit 77.5%, where it has been
> stuck for the last couple of days:
> 
> # cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md4 : active raid5 sdd4[13](R) sdb4[12] sdg4[10](F) sdi4[8] sdl4[9]
> sdf4[1] sdj4[7] sdh4[2] sde4[0] sdk4[11]
> 
> 13454923776 blocks super 1.1 level 5, 512k chunk, algorithm 2 [10/9]
> [UUUU_UUUU_]
> [===============>.....] reshape = 77.5% (1490403328/1922131968)
> finish=2544246.9min speed=2K/sec

It shows you have a failed device (sdg4) but you don't mention anything about
that? Post your mdadm --detail /dev/md4, and what do you have in dmesg.

-- 
With respect,
Roman
