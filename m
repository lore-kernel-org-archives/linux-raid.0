From: Frank Baumgart <frank.baumgart@gmx.net>
Subject: Re: RAID5 in strange state
Date: Thu, 09 Apr 2009 00:19:46 +0200
Message-ID: <49DD2302.3010206@gmx.net>
References: <49DD1730.4070108@gmx.net> <878wmag62s.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878wmag62s.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow schrieb:
> Stop the raid and assemble it with just the two reliable disks. For me
> that always works automatically. After that add the flaky disk again.
>
> If you fear the disk might flake out again I suggest you add a bitmap
> to the raid by runing (works any time the raid is not resyncing)
>
> mdadm --grow --bitmap internal /dev/md0
>
> This will cost you some performance but when a disk fails and you
> readd it it will only have to sync regions that have changed and not
> the full disk.
>
> You can also remove the bitmap again with
>
> mdadm --grow --bitmap none /dev/md0
>
> at any later time. So I really would do that till you have figured out
> if the cable is falky or not.
>   

Adding an internal bitmap to an existing array will not destroy any
data, correct?

mdadm --stop /dev/md0
mdadm --assemble /dev/md0 /dev/sdc1 /dev/sdd1
mdadm /dev/md0 --re-add /dev/sde1

appears to do the trick (still sync'ing...)

Anyway I wonder why the array did not come up automatically as 2 out of
the 3 devices were still working and in sync.
On previous occasions with just the same kind of setup, this always
worked fine out of the box.

Thanks for your help!

Frank

