From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Fri, 20 Jul 2012 08:53:05 -0400 (EDT)
Message-ID: <f05fcb33-b518-426e-b308-6fac462554fd@zmail15.collab.prod.int.phx2.redhat.com>
References: <50078375.7050208@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50078375.7050208@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Unfortunately many drives do that. This happens transparently
> > during the drive's idle surface checks,
> 
> Please list the SATA drives you have verified that perform firmware
> self
> initiated surface scans when idle, and transparently (to the OS)
> relocate bad sectors during this process.
> 
> Then list the drives that have relocated sectors during such a
> process
> for which they could not read all the data, causing the silent data
> corruption you describe.

I can't say I "have verified" that, since that doesn't happen everyday
and in such cases I'm trying to focus on saving my data. I accept 
It's my fault that I had no mental power to play with the failing
drives more prior to returning them for warranty replacement.
I just know that I had corrupted data on the clones whilst there were
no I/O errors in any logs during the cloning. I experienced that 
mainly on systems without RAID (=with single drive). One of my drives
became unbootable due to a MBR data corruption. There were no intentional
writes to that sector for a long time. I was able to read it by dd,
I was able to clean it with zeroes by dd and I was able to create
a new partition table with fdisk. All of these operations worked
without problems and the number of reallocated sectors didn't increase
when I was writing to that sector. I used to periodically check
the SMART attributes by calling smartctl instead of retrieving emails
from smartd and I remember there were no reallocated sectors shortly
before it happened. But they were present after the incident.
That doesn't verify such behavior, but I seems to me that it's exactly
what happened. 

I experienced data corruptions with the following drives:
Seagate Barracuda 7200.7 series (120GB, 200GB, 250GB).
Seagate U6 series (40GB). All of them were IDE drives.
Western Digital (320GB) ... SATA one, don't remember exact type.
And now I'm playing with recently failed WDC WD2500AAJS-60M0A1,
that was as member of RAID1.

In the last case I put the failing drive to a different computer
and assembled two independent arrays in degraded mode since it got
out of sync / kicked the healthy drive out of the RAID1 for unknown
reason. I then mounted partitions from the failing drive via sshfs
and did a directory diff to find modification made in the meantime
and copy all the recently modified files from the failing (but more
recent) drive to the healthy one. I found one patch file, that had
a total binary mess inside on the failing drive, but that mess was
still perfectly readable. And even if it was not caused by the drive
itself, it's a data corruption that would be hopefully prevented
with chunk checksums.

> For one user to experience silent corruption once is extremely rare.
>  To
> experience it multiple times within a human lifetime is statistically
> impossible, unless you manage very large disk farms with high cap
> drives.
> 
> If your multiple silent corruptions relate strictly to RAID1 pairs,
> it
> would seem the problem is not with the drives, but lay somewhere
> else.

I admit, that the problem could lie elsewhere ... but that doesn't 
change anything on the fact, that the data became corrupted without
me noticing that. I don't feel well when I see what happened because
I trusted this solution a bit too much. Sorry if I look too anxious.

Regards,
Jaromir.
