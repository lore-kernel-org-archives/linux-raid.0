From: Noah Beck <noah.b.beck@gmail.com>
Subject: Re: recovery from selinux blocking --backup-file during RAID5->6
Date: Tue, 5 Apr 2016 10:44:45 -0400
Message-ID: <CAFAW0zyNS3m4ZZ59xCkznxopo0d4soWQZrd2eBVfovfNCoX6Sg@mail.gmail.com>
References: <CAFAW0zxisX2Db_YdJxtNpF4YKayy=AnKnWcGdAgw6piy1Jjyng@mail.gmail.com>
	<CAF-Kpgaj2ycfxLumyXw1FwX+NetPa3XN0zhr6EM5O-qvnm6jrA@mail.gmail.com>
	<CAF-KpgYqa9hB7m=pNAc8GFrTuKF8YwToHXvU4U2uCncs77Jx5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgYqa9hB7m=pNAc8GFrTuKF8YwToHXvU4U2uCncs77Jx5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[re-send including linux-raid this time]

On Mon, Apr 4, 2016 at 11:58 PM, George Rapp <george.rapp@gmail.com> wrote:
>> The previous thread resulted in a patch (in
>> https://marc.info/?l=linux-raid&m=145187378405337&w=2 ).  If I want to
>> go back to having a 4-device RAID5 array before I shut this system
>> down to replace the bad disk, is the right thing to do still to apply
>> that patch to mdadm, stop /dev/md127, and assemble again with
>> --update=revert-reshape?  Or does the info above indicate I should use
>> any different solution?
>
> Noah -
>
> I was the one bitten by SELinux in the thread you linked above. However, my
> starting point was different, as I was growing a 5-disk RAID 6 array to six
> disks. Otherwise, what you described was exactly what I experienced.

Heh.  I read 5-disk RAID 6 as RAID5 in your other thread.  Apparently
wishful thinking on my part, but still pretty similar like you say.

> If you want to try NeilBrown's patch
> (https://marc.info/?l=linux-raid&m=145187378405337&w=2), I'd strongly
> suggest testing it nondestructively first, using the overlay strategy
> detailed at
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID

The overlay seems like a safe way to experiment.  I was wondering though,
since the array is still running, is it supposed to work to apply the
--update=revert-reshape to the system without shutting it down?
Or is it required to apply revert-reshape on an assemble operation?

> The steps you proposed above are correct. More detail on the exact commands
> I used: https://marc.info/?l=linux-raid&m=145349072305613&w=2
>
> Good luck. Please report success or failure to the list.

Yes I saw that.  I'm headed out to get a replacement disk then I'll
start messing
with the system.  Hopefully I'll report back with something later today.

Thanks for the help,
Noah
