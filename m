From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: recovery of hosed raid5 array
Date: Sun, 12 Oct 2003 10:39:50 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com>
 <slrnboirt8.me8.lunz@orr.homenet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnboirt8.me8.lunz@orr.homenet>
To: Jason Lunz <lunz@falooley.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 12 Oct 2003, Jason Lunz wrote:

> What was foolish was me provoking /dev/hde by asking it to report
> diagnostics with smartctl at the same time the array was rebuilding
> /dev/hdg. Even if something _was_ wrong with hde, it wouldn't have
> helped me to find out then during the rebuild. Had the resync completed,
> I'd have all my data now and one dead disk.

querying SMART shouldn't cause this to happen -- but i've seen it occur
with a promise controller and maxtor disks.  i used to query the SMART
data once a night just to have a log.  then i switched it to once every 5
minutes so i could graph the drive temperature... and when i went to once
every 5 minutes the system became unstable.  the kernel would randomly
lose the ability to talk to a disk.  the problem would go away after a
reboot.  i assume it was some sort of race condition.

i've since switched from promise to 3ware, and now i can't use smartctl to
query the data.  (mind you a kind engineer from 3ware sent me the code i
need to query SMART from the drives, i've just never had the chance to
merge it into smartctl).


> The question remains: What's the best way to get at the mostly unharmed
> data on hdg from before the rebuild started? I know it's there.

mdadm can do it for you ... you need to know exactly which disk was in
which position in the raid.  then you recreate the raid using "missing" in
the slot where /dev/hde belonged.  then you'll have a degraded array, so
md won't try rebuilding it.  then you can copy off the data.

you need to know the exact numberings, and the exact commands you used to
create the array in the first place.

-dean
