From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: Re: md raid6 not working
Date: Wed, 22 Aug 2012 12:57:27 +0000
Message-ID: <CC5A4D65.28AF2%michael.vanhorn@wright.edu>
References: <20120822083824.4dc16431@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120822083824.4dc16431@notabene.brown>
Content-Language: en-US
Content-ID: <8A1D9C971D1D5F4C9F32AA0A1C365A73@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/21/12 6:38 PM, "NeilBrown" <neilb@suse.de> wrote:

>># mdadm -Avvv /dev/md0
>>mdadm: looking for devices for /dev/md0
>>mdadm: cannot open device /dev/sdi1: Device or resource busy
>>mdadm: /dev/sdi1 has no superblock - assembly aborted
>>#
>
>So /dev/sdi1 is busy.  You need to find out why.  (the "no superblock"
>message is a bit misleading... I might have fixed that in newer mdadm, I'm
>not sure).
>
>The "/proc/mdstat" that you showed in the original email had sdi1 as a
>member
>of md0, so it clearly wasn't being used by anything else then.
>"mdadm -S /dev/md0" would have removed it from md0 so it shouldn't have
>been
>busy.
>The fact that it is busy is very odd.
>
>A device can be busy if:
>- it is mounted as a filesystem
>- it is active as swap
>- it is part of an md array
>- it is part of a dm device
>- probably something else, but those are the main ones.
>
>


Okay, I have gone to investigate what was using /dev/sdi1 yesterday
morning when I tried to assemble the array. I couldn't find anything at
all that would have been doing something with that disk, so I simply tried
the assemble again, and this time it worked (well, sort of):

# mdadm -Avvv /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is not one of
/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1,/dev/sdg1,/dev/sdh1,/dev/sdi1
mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 8.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: added /dev/sdh1 to /dev/md0 as 2
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: added /dev/sdf1 to /dev/md0 as 4
mdadm: added /dev/sdg1 to /dev/md0 as 5
mdadm: no uptodate device for slot 6 of /dev/md0
mdadm: no uptodate device for slot 7 of /dev/md0
mdadm: added /dev/sdi1 to /dev/md0 as 8
mdadm: added /dev/sdd1 to /dev/md0 as -1
mdadm: added /dev/sdc1 to /dev/md0 as 1
mdadm: /dev/md0 assembled from 5 drives and 2 spares - not enough to start
the array.
#

So, sdi1 seems to be just fine. However, since two of the disks are
getting marked as spares, it can't start the array. I don't ever recall
setting the two disks as spares, and even if I had, would one of the
spares have kicked in when sdb1 went bad? Or, am I not understanding the
concept of a spare as it applies to a level 6 raid?

At this point, I'm thinking that sdd1 and sdi1 really should be in either
slot 0, 6 or 7, but I'm not sure which ones. Is there a way to use
trial-and-error to assemble the array with, for example, sdd1 as slot 0,
and see if it works ("working" meaning that I could then mount the xfs
file system) and, if it doesn't, stop the array, and then try it in slot 6?

I am, I guess, making the assumption that it being marked a spare is
incorrect, and that it does, in fact, have data on it.


---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




