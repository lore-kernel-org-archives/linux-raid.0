From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Proper way to delete an old RAID1?
Date: Tue, 18 Jun 2013 11:55:08 -0700
Message-ID: <CAK2H+eebtek=fRrXxLLdc27OO5xLXaq3r6jCYiPxoFkJcZD=8w@mail.gmail.com>
References: <CAKFseUOGX=9MQLfs3JMdku7D8AOsnFHosKc0DHL3b2crWtqxRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUOGX=9MQLfs3JMdku7D8AOsnFHosKc0DHL3b2crWtqxRA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Caspar Smit <c.smit@truebit.nl>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 18, 2013 at 11:42 AM, Caspar Smit <c.smit@truebit.nl> wrote:
> Hi Mark,
>
> Stopping an MD device will not remove/delete anything.
> The --remove command cannot be used AFTER an MD device is stopped.
> (--remove is only for removing drives/partitions from a running MD
> device NOT to remove the MD itself e.g. mdadm --remove /dev/mdX
> /dev/sdb, furthermore a drive/partition can only be removed after you
> fail the drive first or it has failed by itself offcouse, see the
> --fail switch)
>
> To completely erase the MD you need to stop it and then remove the
> superblocks from the member drives:
>
> mdadm --stop /dev/md127
> mdadm --zero-superblock /dev/sdb5
> mdadm --zero-superblock /dev/sdc5
> mdadm --zero-superblock /dev/sdd5
>
> You can combine the last 3 commands to:
>
> mdadm --zero-superblock /dev/sd[b-d]5
>
> but to be 100% safe use them seperately.
>
> This will erase the superblocks on the members of /dev/md127 and you
> will not be able to assemble it again and it will not be started
> during a reboot (remove it from the mdadm.conf too offcourse, but
> since the array comes up as /dev/md127 I presume it is already not
> present in mdadm.conf)
>
> Kind regards,
> Caspar
>

Thanks Caspar. What you are saying makes more sense to me and is, as
best I can tell, consistent with man mdadm.

I've used this site a few times as it seems to come up a lot when
Googling mdadm questions:

http://www.ducea.com/2009/03/08/mdadm-cheat-sheet/

Apparently his instructions in #3 are incorrect.

Cheers,
Mark

> 2013/6/18 Mark Knecht <markknecht@gmail.com>:
<SNIP>
>>
>> mdadm --stop /dev/md127
>> mdadm --remove /dev/md127
>>
>> to remove the raid1?
<SNIP>
