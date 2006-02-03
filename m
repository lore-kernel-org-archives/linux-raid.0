From: Mike Hardy <mhardy@h3c.com>
Subject: Re: ludicrous speed: raid6 reconstruction
Date: Fri, 03 Feb 2006 13:56:04 -0800
Message-ID: <43E3D174.3090608@h3c.com>
References: <20060203211558.GA7559@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060203211558.GA7559@amd64.of.nowhere>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I saw this on my array, and other(s) have reported it as well.

Apparently the reconstruction speed algorithm doesn't understand that
it's not syncing all the blocks and hilarity ensues. I believe that was
it, anyway

Either that or you really have a hell of a server :-)

-Mike

jurriaan wrote:
> Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [raid6] 
> md0 : active raid6 sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
>       1465175424 blocks level 6, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]
>       [==================>..]  resync = 91.0% (222239104/244195904) finish=0.0min speed=7369041K/sec
>       bitmap: 23/233 pages [92KB], 512KB chunk
> I am reminded of Spaceball's 'ludicrous speed' here. This is after a
> reboot from 2.6.16-rc1-mm3 (where the array was built) to 2.6.16-rc1-mm5
> (where rebuilding continued thanks to the bitmap).
