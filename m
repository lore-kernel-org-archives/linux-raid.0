From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fail to assemble raid4 with replaced disk
Date: Tue, 25 Oct 2016 19:35:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1610251933280.12036@uplift.swm.pp.se>
References: <CAJh8RqUjr7L_Of0fbW_mAXshmmgcPdXvhtsvhFXKF+XxjOTrFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJh8RqUjr7L_Of0fbW_mAXshmmgcPdXvhtsvhFXKF+XxjOTrFw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Santiago DIEZ <santiago.diez@caoba.fr>
Cc: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 25 Oct 2016, Santiago DIEZ wrote:

> # mdadm --assemble /dev/md10 --verbose /dev/sda10 /dev/sdb10 /dev/sdc10
> mdadm: looking for devices for /dev/md10
> mdadm: /dev/sda10 is identified as a member of /dev/md10, slot 0.
> mdadm: /dev/sdb10 is identified as a member of /dev/md10, slot 1.
> mdadm: /dev/sdc10 is identified as a member of /dev/md10, slot 2.
> mdadm: added /dev/sda10 to /dev/md10 as 0 (possibly out of date)
> mdadm: added /dev/sdc10 to /dev/md10 as 2 (possibly out of date)
> mdadm: no uptodate device for slot 3 of /dev/md10
> mdadm: added /dev/sdb10 to /dev/md10 as 1
> mdadm: /dev/md10 assembled from 1 drive - not enough to start the array.

This means sda10 and sdc10 most likely have a lower event count than 
sdb10.

> I examined the status again with:
> # cat /proc/mdstat
> md10 : inactive sdb10[1](S) sdc10[2](S) sda10[0](S)
>      5778741888 blocks
>
> Now I'm SCARED!
> What does the (S) mean?
> How do I reassemble my array and add the new sdd10 partition?

Check with mdadm -E /dev/sd[abc]10, check the event count, if it differs 
just a little (5-10 perhaps), then you can use --assemble --force to start 
it even though the event count is not exactly the same on each drive.

The event count is increased every time a drive is written to, when there 
is an unclean shutdown mdadm won't auto-assemble drives without operator 
intervention to understand the situation and act accordingly.


-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
