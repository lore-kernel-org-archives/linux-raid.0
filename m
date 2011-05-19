From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: check which disk is a problem
Date: Thu, 19 May 2011 12:47:34 +0100
Message-ID: <4DD50356.50403@anonymous.org.uk>
References: <201105191234.39391.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201105191234.39391.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pol Hallen <raid1@fuckaround.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/05/2011 11:34, Pol Hallen wrote:
> Hi folks :-)
>
> I've a raid6 sw on debian stable and a problem (!):
>
> cat /proc/mdstat
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdc1[0] sdf1[5] sdg1[4] sdh1[3] sdd1[1]
>        5860543744 blocks level 6, 64k chunk, algorithm 2 [6/5] [UU_UUU]
>
> so, I think /dev/sde is corrupted disk
>
> How identify this disk?
>
> blkid:
>
> /dev/sdc1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d"
> TYPE="linux_raid_member"
> /dev/sdd1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d"
> TYPE="linux_raid_member"
> /dev/sde1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d"
> TYPE="linux_raid_member"
> /dev/sdf1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d"
> TYPE="linux_raid_member"
> /dev/sdg1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d"
> TYPE="linux_raid_member"
> /dev/sdh1: UUID="9bd6372e-e2ea-b1d5-d2bd-c3cbad12f41d"
> TYPE="linux_raid_member"
>
> has same uuid, why?
>
> and now how can I resolve?

You can find out which discs/partitions are meant to be in the array with
   mdadm -D /dev/md0

and if as it appears there's one missing you can see what state it's in with
   mdadm -E /dev/sde1
(or similar).

You should look through your logs to see if you can see what happened to 
it. You should also check its SMART status with e.g.
   smartctl -a /dev/sde

If it's not dead or dying, you may be able to re-add it with
   mdadm /dev/md0 --add /dev/sde1

Hope this helps!

Cheers,

John.

