From: Brad Campbell <brad@wasp.net.au>
Subject: Re: RAID 5 disks not spinning down
Date: Sat, 12 Mar 2005 18:09:18 +0400
Message-ID: <4232F80E.1030202@wasp.net.au>
References: <d0uamj$s15$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <d0uamj$s15$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Stockinger <stockina@fmi.uni-passau.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alexander Stockinger wrote:
> Hi all,
> 
> I have a linux software RAID 5 running on a Debian Sarge with 2.6.7-smp. 
> Since I installed the system (several kernel updates ago) the disks of 
> the RAID 5 won't stay spinned down. Having them sent to standy manually 
> using hdparm ends up in having the disks spin up within the next minute 
> or so.
> To further investigate the problem I watched the /proc/diskstats file 
> for /dev/md0 and realized that prior to the spinup a single read access 
> to the RAID is issued - consequently the disks attached to the read spin 
> up again...

Does it occur if you have the filesystem on the md device unmounted?

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
