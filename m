From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Seeking help fixing a failed array
Date: Fri, 23 May 2014 17:22:55 +0200
Message-ID: <537F67CF.5000008@grumpydevil.homelinux.org>
References: <CAGcAkBKnp8J5zGuwgVv98zMrDLVPZWAi57rqpgLW6VByAcm94g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGcAkBKnp8J5zGuwgVv98zMrDLVPZWAi57rqpgLW6VByAcm94g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marnitz Gray <marnitz@xdesigns.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Marnitz,

did you try mdadm assemble with -f (force)?

Cheers

Rudy

On 23-05-14 12:14, Marnitz Gray wrote:
> Hello good people of linux-raid.
>
> I come here seeking advice on how to repair my raid 5 which I have
> managed to royally break.
> The raid was initially created in 2009 with 5 1.5TB hdds. Since then I
> have replaced 2 drives, 1 with a 2TB and 1 with a 3TB.
> The current mdadm version is mdadm - v3.3 - 3rd September 2013
> The /etc/debian_version file reads: jessie/sid
>
> The story:
> My intention was to replace all the 1.5TB drives with 3TB drives, and
> then grow the size of the array.
> Yesterday I replaced /dev/sdf, with a 3TB and re-sync'd the array.
> The process finished sometime during the night with no errors, so this
> morning I continued and replaced /dev/sdb. However, after booting the
> machine I was unable to re-mount the partition (the error was on the
> lines of: specify filesystem type).
>
> After fumbling around with a couple of mdadm --assembles, removing the
> new drive and replacing the old 1.5TB, re-trying some more assembles,
> I stumbled upon the wiki article
> (https://raid.wiki.kernel.org/index.php/RAID_Recovery) which led me
> here.
>
> I thus turn to the list seeking advice/help or simply guidance.
> Attached is the current mdadm --examine of all drives, however, my
> attempted assembles have clearly damaged something.
>
> Heres the breakdown of the drives currently in the system (90% sure
> this is correct):
> /dev/sda: OS Hdd, not part of the raid
> /dev/sdb: 1.5TB HDD removed this morning
> /dev/sdc: 3TB added yesterday, replaced /dev/sdg
> /dev/sdd: 2TB HDD, replaced a failed 1.5TB a few years back
> /dev/sde: 1.5TB HDD, has not been replaced, should be part of the array
> /dev/sdf: 3TB HDD, replaced a failed 1.5TB last year
> /dev/sdg: 1.5TB HDD removed yesterday (replaced by /dev/sdc)
>
> My assumption is that I need to try re-creating the array with drives b,c,d,e,f.
>
> Here is the mdadm --assemble --force output for those drives:
> mdadm --assemble --force --verbose /dev/md0 /dev/sdb /dev/sdc /dev/sdd
> /dev/sde /dev/sdf
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
> mdadm: added /dev/sde to /dev/md0 as 1
> mdadm: added /dev/sdd to /dev/md0 as 2
> mdadm: added /dev/sdb to /dev/md0 as 3 (possibly out of date)
> mdadm: no uptodate device for slot 8 of /dev/md0
> mdadm: added /dev/sdc to /dev/md0 as 5
> mdadm: added /dev/sdf to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 3 drives and 1 spare - not enough to
> start the array.
>
> Where did this all go wrong:
> I believe the 3TB drive that I plugged in this morning came out of a
> Seagate BlackArmor NAS400. It thus likely had other superblock
> information on it which confused mdadm (purely speculative, I'm not
> sure if this is even likely/possible).
>
> I currently have 4 3TB drives spare, however, I do not have any spare
> SATA ports to plug them into. While the data on the raid isn't
> critical, I would be rather sad (and cry for many days) if it
> disappeared.
>
> Any suggestions welcome.
>
> Thanks in advance,
> Marnitz Gray

