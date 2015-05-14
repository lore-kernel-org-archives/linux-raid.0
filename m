From: Jason Keltz <jas@cse.yorku.ca>
Subject: Re: [PATCH 0/7] mdadm support for caching layer in raid 5/6
Date: Thu, 14 May 2015 07:30:57 -0400
Message-ID: <14d5230fde0.276a.cf392d89e21755b689a9b33faa59c92f@cse.yorku.ca>
References: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14d521c83b0.276a.cf392d89e21755b689a9b33faa59c92f@cse.yorku.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi..
I'm curious - why not support write cache for other raid levels? If the 
write cache becomes a fast SSD (with high endurance) for a pool that is all 
standard HD then wouldn't the write cache benefit there as well? (Eg. 
Raid10) .  Can the write cache also be an MD device? I would think you 
could use that to improve performance and redundancy of the cache?

I'm using RHEL 7.1 on an NFS server for a virtualization back end. Because 
of sync writes the write performance is poor. Its really no surprise.. I've 
got a 22 disk raid10. At the moment I could try dm-cache in rhel7 in an 
effort to improve write performance but its a technology preview and not 
sure I'd want to rely on that for production.  It's not really just a 
simple write cache either which is all that I'm really after.  I like 
simple! I could also enable async writes on my NFS export and not sleep at 
night (only 3 virtualization nodes.. UPS protection everywhere protected.. 
But what if the file server crashes? You want eerie? I just got an email 
that power is off on one node of my test setup....UPS failed... Aie! That 
could just as easily have been the FS.)  ..I could stop using MD for NFS 
backend storage altogether and rely on a raid card with battery backed 
cache as well and then when there's some kind of card firmware issue wait 
for the hardware vendor to close my support ticket due to inactivity before 
they even respond.... which has happened several times with a common 3 
letter storage company that has more than 3 letters in their name now...  I 
could wait for someone to create a magical hardware device that would do 
for MD software raid what the battery backed cache does for hardware raid. 
To this day I really don't  understand why that hasn't been done. It would 
be a whole lot cheaper than SSD. . it would have higher longevity.... I'd 
buy it... And I suspect a billion other people as well... But I guess 
simple write caching will help as well....

Since I don't have any of the above goodies I've decided to try a switch 
from ext4 to xfs.   Then test with HD based external log... Then Ill try 
SSD based external log ... And finally potentially external log to an MD 
raid1 SSD log device.... Though I can't find too many details, I've got a 
hunch that if the log fails I'd be in trouble...

J.

Sent with AquaMail for Android
http://www.aqua-mail.com


On May 14, 2015 2:44:04 AM Song Liu <songliubraving@fb.com> wrote:

> Hi,
>
> These are mdadm patches to support cache layer in raid 5/6. Shaohua
> has sent the kernel patch earlier with subject "a caching layer
> for raid 5/6".
>
> These patches add write cache support for the following commands:
>
>   mdadm --detail
>   mdadm --create
>   mdadm --assemble
>   mdadm --incremental
>   mdadm --examine
>   mdadm --zero-super
>
> Cache device is assigned with dev_role 0xFFFD (where 0xFFFF is for
> spare and 0xFFFE is for failed). Note that there is compatibility
> issue that older mdadm will show cache device as spare in --detail:
>
>     Number   Major   Minor   RaidDevice State
>        0       8       32        0      active sync   /dev/sdc
>        1       8       48        1      active sync   /dev/sdd
>        2       8       64        2      active sync   /dev/sde
>        3       8       80        3      active sync   /dev/sdf
>
>        4       8       17        -      spare   /dev/sdb1
>
> Also, older mdadm will show cache device as "Active device 65533"
> in --examine:
>
>    Device Role : Active device 65533
>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>
>
> Song Liu (7):
>   Show device as cache in --detail
>   Enable create array with write cache (--write-cache DEVICE).
>   Create write-cache superblock in mdadm --create
>   Assemble array with writecache
>   Check write cache in incremental
>   Zero write-cache superblock in --zero-super
>   Add information about write-cache superblock to --examine
>
>  Assemble.c    |  52 +++++++++++++----
>  Create.c      |  21 +++++--
>  Detail.c      |   3 +-
>  Examine.c     |  29 +++++++++-
>  Incremental.c |  37 ++++++++++--
>  Kill.c        |  19 ++++++
>  ReadMe.c      |   1 +
>  md_p.h        |  74 ++++++++++++++++++++++++
>  mdadm.c       |  19 ++++++
>  mdadm.h       |  11 +++-
>  super1.c      | 182 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  util.c        |   3 +-
>  12 files changed, 422 insertions(+), 29 deletions(-)
>
> --
> 1.8.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


