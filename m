From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Monitoring for failed drives
Date: Wed, 25 Apr 2012 18:18:05 +0200
Message-ID: <4F9823BD.8040300@computer.org>
References: <20120425123951.GB10172@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120425123951.GB10172@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brian Candler wrote:
> The problem is, how to detect and report this? At the md RAID level,
> `cat /proc/mdstat` and `mdadm --detail` show nothing amiss.
>
>      # cat /proc/mdstat
>      Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>      md127 : active raid0 sdk[8] sdf[4] sdb[0] sdj[9] sdc[1] sde[2] sdd[3] sdi[6] sdg[5] sdh[7] sdv[20] sdw[21] sdl[11] sdu[19] sdt[18] sdn[13] sds[17] sdq[14] sdm[10] sdx[22] sdr[16] sdo[12] sdp[15] sdy[23]
>            70326362112 blocks super 1.2 512k chunks

Brian,

I know that you know this, but this is a RAID0 which does not have any 
redundancy. What would you expect md to do? It cannot kick the drive 
from the array since this would bring the entire array down.

Unlike with other RAID levels it is practicable to kick failed drives 
from the array because you can reconstruct their contents from the 
parity information.

Jan
