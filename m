From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or destructive
 result?
Date: Wed, 27 Mar 2013 15:10:58 -0500
Message-ID: <51535252.2080105@hardwarefreak.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra> <51534450.8050905@hardwarefreak.com> <CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/27/2013 2:23 PM, Mark Knecht wrote:

> Note that another level of understanding (which I don't have) has to
> do with getting chunk sizes that work well for my needs. That's a
> whole other kettle of fish...
...
> mark@c2stable ~ $ cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md6 : active raid5 sdc6[1] sdd6[2] sdb6[0]
>       494833664 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       bitmap: 0/2 pages [0KB], 65536KB chunk
> 
> md3 : active raid6 sdd3[2] sdc3[1] sdb3[0] sde3[3] sdf3[5]
>       157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
> 
> md7 : active raid6 sdd7[2] sdc7[1] sdb7[0] sde2[3] sdf2[4]
>       395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]
> 
> md126 : active raid1 sdb5[0] sdd5[2] sdc5[1]
>       52436032 blocks [3/3] [UUU]

Your problem isn't chunk sizes, but likely the 4 md/RAID devices atop
the same set of physical disks.  If you have workloads that are
accessing these md devices concurrently that will tend to wreak havoc
WRT readahead, the elevator, and thus the disk head actuators.  If these
are low RPM 'green' drives it will be exacerbated due to the slow
spindle speed.

The purpose of RAID is to prevent data loss when a drive fails.  The
purpose of striped RAID is to add performance atop that.  Thus you
normally have one RAID per set of physical disks.  The Linux md/RAID
driver allows you to stack multiple RAIDs atop one set of disks, thus
shooting yourself in the foot.  Look at any hardware RAID card, SAN
controller, etc, and none of them allow this--only one RAID per disk set.

At this point you obviously don't won't to blow away your current setup,
create one array and restore, as you probably don't have backups.
Reshaping with different chunk sizes won't gain you anything either.  So
about the only things you can optimize at this point are your elevator
and disk settings such as nr_requests and read_ahead_kb.  Switching from
CFQ to deadline could help quite a lot.

-- 
Stan

